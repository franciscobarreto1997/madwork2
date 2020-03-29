class PagesController < ApplicationController

  skip_before_action :verify_authenticity_token
  include HTTParty

  def home
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
end

  private

  def scrape_all_indeed(skill, location)
    if skill.include?(" ")
      skill.gsub! ' ', '%20'
    end
    url = "https://www.indeed.pt/jobs?q=#{skill}&l=#{location}"
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
    chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    if chrome_bin
      p "GOOGLE_CHROME_SHIM IS PRESENT"
      Selenium::WebDriver::Chrome.path = "/app/.apt/usr/bin/google-chrome"
      Selenium::WebDriver::Chrome::Service.driver_path = "/app/.chromedriver/bin/chromedriver"
    end
    browser = Watir::Browser.new :chrome, args: %w[--headless --no-sandbox --disable-dev-shm-usage --disable-gpu --remote-debugging-port=9222]
    browser.goto url
    doc = Nokogiri::HTML(browser.html)
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
    job[:description] = doc.css('div#jobDescriptionText').text
    render json: job
  end
