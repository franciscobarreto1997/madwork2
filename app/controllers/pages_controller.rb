class PagesController < ApplicationController

  #skip_before_action :authenticate_user!, only: [:home]
  include HTTParty

  def home

  end

  def about
  end

  def fetch
    url = "https://www.indeed.pt/jobs?q=ruby+on+rails&l=Lisboa%2C++Distrito+de+Lisboa"
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    jobs = []
    parsed_page.css('div.jobsearch-SerpJobCard').each do |card|
      job = {
        title: card.css('div.title', 'a.title').text.gsub("\n",''),
        location: "Lisbon",
        url: url + "&vjk=" + card.attribute('data-jk'),
        company: card.css('div.sjcl', 'div.span.company').text.gsub("\n",'').gsub("Lisbon", '').match(/[a-zA-Z]+/)[0],
        summary: card.css('div.summary').text.gsub("\n", '')
      }
      jobs << job
    end
    render json: jobs
  end
end
