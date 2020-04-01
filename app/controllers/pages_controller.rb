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
    render json: scrape_all_indeed("Ruby on rails", "Lisboa")
  end

  def fetch_for_results_page
    if params.key?('url')
      if params[:url].include? "indeed"
        scrape_one_indeed(params[:url])
      else
        scrape_one_landing_jobs(params[:url])
      end
    elsif american_states_array.include? $search
      scrape_all_indeed($search, $city)
    else
      indeed_jobs = scrape_all_indeed($search, $city)
      landing_jobs = scrape_all_landing_jobs($search, $city)
      render json: landing_jobs + indeed_jobs
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
      p url
    else
      location_for_url = location.include?(" ") ? location.gsub(' ', '%20') : location
      url = "https://www.indeed.pt/jobs?q=#{skill}&l=#{location_for_url}"
    end
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    jobs = []
    parsed_page.css('div.jobsearch-SerpJobCard').each do |card|
      job = {
        title: card.css('div.title', 'a.title').text.gsub("\n",''),
        location: location,
        url: url + "&vjk=" + card.attribute('data-jk'),
        company: card.css('div.sjcl', 'div.span.company').text.gsub("\n",'').gsub(location, '').match(/[a-zA-Z]+/)[0],
        source: "Indeed"
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
    else
      country_code = "PT"
    end
    if skill.include? " "
      skill.gsub!(" ", "+")
    end
    url = "https://landing.jobs/jobs?city_search=#{location}&country=#{country_code}&page=1&q=#{skill}&hd=false&t_co=false&t_st=false"
    $browser.goto url
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

