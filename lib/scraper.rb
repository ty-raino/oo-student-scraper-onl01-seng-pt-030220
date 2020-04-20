require 'open-uri'
require 'pry'


class Scraper

  def self.scrape_index_page(index_url)
    html = index_url
    doc = Nokogiri::HTML(open(html))
    
    students = []
    counter = 0

    while counter < doc.css("div.student-card a div.card-text-container h4.student-name").length
      student = {
        name:  doc.css("div.student-card a div.card-text-container h4.student-name")[counter].text,
        location: doc.css("div.student-card a div.card-text-container p.student-location")[counter].text,
        profile_url: doc.css(".student-card a")[counter]["href"]
       }
      counter += 1
    students << student
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    html = profile_url

    doc = Nokogiri::HTML(open(html))

    profiles = {}

    links = doc.css(".social-icon-container a")

    links.each do |element|
      if element.attr("href").include?("twitter")
        profiles[:twitter] = element.attr("href")
      elsif element.attr("href").include?("linkedin")
        profiles[:linkedin] = element.attr("href")
        elsif element.attr("href").include?("github")
          profiles[:github] = element.attr("href")
        elsif element.attr("href").include?("com/")
          profiles[:blog] = element.attr("href")
        end
      end

      profiles[:profile_quote] = doc.css(".profile-quote").text
      profiles[:bio] = doc.css(".bio-block.details-block .bio-content.content-holder .description-holder p").text

      profiles
  

  end

end




