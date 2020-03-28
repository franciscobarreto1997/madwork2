class PagesController < ApplicationController

  #skip_before_action :authenticate_user!, only: [:home]
  include HTTParty

  def home
  end

  def about
  end

  def results
  end

  def fetch_for_homepage
    fetch_indeed("Ruby on rails", "Lisboa")
  end

  def fetch_for_results_page
    params
  end
end

  private

  def fetch_indeed(skill, location)
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
