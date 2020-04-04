class PagesController < ApplicationController

  skip_before_action :verify_authenticity_token
  include HTTParty


  def home
    if $browser.nil?
      $browser = Watir::Browser.new :chrome, args: %w[--headless --no-sandbox --disable-dev-shm-usage --disable-gpu --remote-debugging-port=9222]
    end
  end

  def about
  end

  def results
    $search = params[:search]
    $city = params[:city]
  end

  def fetch_for_homepage
    ordered_jobs = order_indeed_by_date(scrape_all_indeed("Ruby on rails", "Lisboa"))
    render json: ordered_jobs
  end

  def fetch_for_results_page
    if params.key?('url')
      if params[:url].include? "indeed"
        scrape_one_indeed(params[:url])
      elsif params[:url].include? "github"
        scrape_one_github_jobs(params[:url])
      else
        scrape_one_landing_jobs(params[:url])
      end
    elsif american_states_array.include? $search
      scrape_all_indeed($search, $city)
    elsif $city == "Remote"
      ordered_jobs = order_cards_by_date(scrape_all_remoteok($search))
      render json: ordered_jobs
    else
      indeed_jobs = scrape_all_indeed($search, $city)
      landing_jobs = scrape_all_landing_jobs($search, $city)
      github_jobs = scrape_all_github_jobs($search, $city)
      ordered_jobs =  order_cards_by_date(indeed_jobs + github_jobs)
      render json: landing_jobs + ordered_jobs
    end
  end

  def fetch_portuguese_cities
    @cities = City.where(country: "Portugal")
    render json: @cities
  end

  def fetch_england_cities
    @cities = City.where(country: "England")
    render json: @cities
  end

  def fetch_american_states
    @cities = City.where(country: "United States")
    render json: @cities
  end

  def fetch_french_cities
    @cities = City.where(country: "France")
    render json: @cities
  end

  def fetch_german_cities
    @cities = City.where(country: "Germany")
    render json: @cities
  end

  def fetch_spanish_cities
    @cities = City.where(country: "Spain")
    render json: @cities
  end

  def fetch_dutch_cities
    @cities = City.where(country: "Netherlands")
    render json: @cities
  end

  def fetch_italian_cities
    @cities = City.where(country: "Italy")
    render json: @cities
  end
end

  private

  def scrape_all_indeed(skill, location)
    if skill.include?(" ")
      skill.gsub! ' ', '%20'
    end
    if english_cities_array.include? location
      location_for_url = location.include?(" ") ? location.gsub(' ', '%20') : location
      url = "https://www.indeed.co.uk/jobs?q=#{skill}&l=#{location_for_url}"
    elsif american_states_array.include? location
      location_for_url = location.include?(" ") ? location.gsub(' ', '%20') : location
      url = "https://www.indeed.com/jobs?q=#{skill}&l=#{location_for_url}"
    elsif french_cities_array.include? location
      location_for_url = location.include?(" ") ? location.gsub(' ', '%20') : location
      url = "https://www.indeed.fr/jobs?q=#{skill}&l=#{location_for_url}"
    elsif german_cities_array.include? location
      location_for_url = location.include?(" ") ? location.gsub(' ', '%20') : location
      url = "https://de.indeed.com/Jobs?q=#{skill}&l=#{location_for_url}"
    elsif spanish_cities_array.include? location
      location_for_url = location.include?(" ") ? location.gsub(' ', '%20') : location
      url = "https://www.indeed.es/ofertas?q=#{skill}&l=#{location_for_url}"
    elsif dutch_cities_array.include? location
      location_for_url = location.include?(" ") ? location.gsub(' ', '%20') : location
      url = "https://www.indeed.nl/vacatures?q=#{skill}&l=#{location_for_url}"
    elsif italian_cities_array.include? location
      location_for_url = location.include?(" ") ? location.gsub(' ', '%20') : location
      url = "https://it.indeed.com/jobs?q=#{skill}&l=#{location_for_url}"
    else
      location_for_url = location.include?(" ") ? location.gsub(' ', '%20') : location
      url = "https://www.indeed.pt/jobs?q=#{skill}&l=#{location_for_url}"
    end
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    jobs = []
    parsed_page.css('div.jobsearch-SerpJobCard').each do |card|
      scraped_date = card.css('span.date').text.scan(/\d+/).join
      date_code = 0
      final_date = ""
      if card.css('span.date').text.include? "30"
        final_date = "+" + scraped_date + "d"
        date_code = 2
      elsif scraped_date == ""
        final_date = "Today"
      else
        final_date = scraped_date + "d"
        date_code = 2
      end
      job = {
        title: card.css('div.title', 'a.title').text.gsub("\n",''),
        location: location,
        url: url + "&vjk=" + card.attribute('data-jk'),
        company: card.css('div.sjcl', 'div.span.company').text.gsub("\n",'').gsub(location, '').match(/[a-zA-Z]+/)[0],
        source: "Indeed",
        posted_date: final_date,
        date_code: date_code
      }
      jobs << job
    end
    jobs
  end

  def scrape_one_indeed(url)
    job = {}
    $browser.goto url
    doc = Nokogiri::HTML($browser.html)
    divs = []
    doc.css('div.jobsearch-jobDescriptionText').each do |div|
      divs << div.to_s.gsub("\n", "")
    end
    date = doc.css('div.jobsearch-JobMetadataFooter').text.scan(/\d+/)
    date_string = date.empty? ? "" : date[0] + " days ago"
    final_date_string =  ""
    if date_string.match(/^1\s/)
      final_date_string = date_string.tr('s', '')
    elsif date_string.include?("30")
      final_date_string = date_string.insert(2, '+')
    else
      final_date_string = date_string
    end
    job[:posted_date] = final_date_string
    job[:description] = divs.join
    render json: job
  end

  def scrape_all_landing_jobs(skill, location)
    country_code = ""
    if english_cities_array.include? location
      country_code = "EN"
    elsif german_cities_array.include? location
      country_code = "DE"
    elsif spanish_cities_array.include? location
      country_code = "ES"
    elsif dutch_cities_array.include? location
      country_code = "NL"
    else
      country_code = "PT"
    end
    if skill.include? " "
      skill.gsub!(" ", "+")
    end
    url = "https://landing.jobs/jobs?city_search=#{location}&country=#{country_code}&page=1&q=#{skill}&hd=false&t_co=false&t_st=false"
    $browser.goto url
    sleep 4
    parsed_page = Nokogiri::HTML($browser.html)
    jobs = []
    parsed_page.css('li.lj-jobcard').each do |card|
      job = {
        title: card.css('a.lj-jobcard-name').text,
        location: location,
        url: card.css('a.lj-jobcard-name').attribute('href').text,
        company: card.css('a.lj-jobcard-company').text,
        source: "Landing.jobs"
      }
      jobs << job
    end
    jobs
  end

  def scrape_one_landing_jobs(url)
    job = {}
    parsed_page = Nokogiri::HTML(HTTParty.get(url))
    divs = []
    parsed_page.css('section.ld-job-offer-section').each do |div|
      divs << div.to_s.gsub("\n", "")
    end
    divs.pop
    divs.shift
    job[:description] = divs.join
    render json: job
  end

  def scrape_all_github_jobs(skill, location)
    if skill.include? " "
      skill.gsub!(" ", "+")
    end
    if location.include? " "
      location.gsub!(" ", "+")
    end
    url = "https://jobs.github.com/positions?utf8=%E2%9C%93&description=#{skill}&location=#{location}"
    parsed_page = Nokogiri::HTML(HTTParty.get(url))
    jobs = []

    parsed_page.css('tr.job').each do |job|
      scraped_date = job.css('span.relatize').text
      if (scraped_date.include? "days") || (scraped_date.include? "day")
        final_date = scraped_date.scan(/\d+/).join + "d"
        date_code = 2
      elsif (scraped_date.include? "months") || (scraped_date.include? "month")
        final_date = scraped_date.scan(/\d+/).join + "mo"
        date_code = 3
      elsif (scraped_date.include? "hours") || (scraped_date.include? "hour")
        final_date = scraped_date.scan(/\d+/).join + "h"
        date_code = 1
      else
        final_date = scraped_date.scan(/\d+/).join + "yr"
        date_code = 4
      end
      job = {
        title: job.css('td.title h4 a').text,
        location: job.css('td.meta span.location').text,
        url: job.css('td.title h4 a').attribute('href').value,
        company: job.css('p.source a').text,
        source: "GitHub Jobs",
        posted_date: final_date,
        date_code: date_code
      }
      jobs << job
    end
    jobs
  end

  def scrape_one_github_jobs(url)
    parsed_page = Nokogiri::HTML(HTTParty.get(url))
    job = {
      description: parsed_page.css('div.main').to_s.gsub("\n", "")
    }
    render json: job
  end

  def unduplicate_title(title)
    word_array = title.split(" ")
    median_index = median(word_array)
    word_array.delete_at(median_index)
    word_array.uniq.join(" ")
  end

  def median(array)
    indexes = array.count - 1
    middle_index = indexes / 2
  end

  def scrape_all_remoteok(skill)
    if skill.include? " "
      skill.gsub!(" ", "-")
    end
    url = "https://remoteok.io/remote-#{skill.downcase}-jobs"
    p url
    parsed_page = Nokogiri::HTML(HTTParty.get(url))
    jobs = []
    parsed_page.css('tr.job').each do |row|

      duplicated_title = row.css('td.company h2').text
      date = row.css("td.time a").text

      if date.include? "h"
        date_code = 1
      elsif date.include? "d"
        date_code = 2
      elsif date.include? "mo"
        date_code = 3
      else
        date_code = 4
      end

      job = {
        title: unduplicate_title(duplicated_title),
        location: "Remote",
        url: 'https://remoteok.io' + row.attribute('data-url').value,
        company: row.css('td.company a.companyLink h3').text,
        source: "remote|OK",
        posted_date: date,
        date_code: date_code
      }
      jobs << job
    end
    jobs
  end

  def order_cards_by_date(array)
    sorted_array = []
    array.each do |element|
      sorted_array = array.sort_by { |element| [element[:date_code], element[:posted_date].match(/\d+/).to_s.to_i] }
    end
    sorted_array.reverse
  end

  def english_cities_array
    english_cities = City.where(country: "England")
    cities_array = []
    english_cities.each { |city| cities_array << city.name }
    cities_array
  end

  def american_states_array
    american_states = City.where(country: "United States")
    states_array = []
    american_states.each { |state| states_array << state.name }
    states_array
  end

  def french_cities_array
    french_cities = City.where(country: "France")
    cities_array = []
    french_cities.each { |city| cities_array << city.name }
    cities_array
  end

  def german_cities_array
    german_cities = City.where(country: "Germany")
    cities_array = []
    german_cities.each { |city| cities_array << city.name }
    cities_array
  end

  def spanish_cities_array
    spanish_cities = City.where(country: "Spain")
    cities_array = []
    spanish_cities.each { |city| cities_array << city.name }
    cities_array
  end

  def dutch_cities_array
    dutch_cities = City.where(country: "Netherlands")
    cities_array = []
    dutch_cities.each { |city| cities_array << city.name }
    cities_array
  end

  def italian_cities_array
    italian_cities = City.where(country: "Italy")
    cities_array = []
    italian_cities.each { |city| cities_array << city.name }
    cities_array
  end
