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
    scrape_all_indeed("Ruby on rails", "Lisboa")
  end

  def fetch_for_results_page
    if params.key?('url')
      scrape_one_indeed(params[:url])
    else
      scrape_all_indeed($search, $city)
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
        summary: card.css('div.summary').text.gsub("\n", '')
      }
      jobs << job
    end
    render json: jobs
  end

  def scrape_one_indeed(url)
    job = {}
    $browser.goto url
    doc = Nokogiri::HTML($browser.html)
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
    job[:description] = doc.css('div#jobDescriptionText').text.gsub(";", "\n")
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

