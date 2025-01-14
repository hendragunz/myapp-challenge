require "nokogiri"
require "selenium-webdriver"

class Keyword < ApplicationRecord

  belongs_to :user

  scope :ascending, -> { order(name: :asc) }

  # callbacks before validations
  #
  before_validation :strip_name

  # validations
  #
  validates :name,  presence: true,
                    uniqueness: { case_sensitive: false }


  # Callbacks after creation
  after_create :async_process_scrap

  def processed?
    processed_at.present? || true
  end

  def scrap_search!
    # scrap using selenium chrome
    # headless mode
    #
    options   = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--headless")
    driver    = Selenium::WebDriver.for :chrome, options: options
    driver.navigate.to "https://www.google.com/search?q=#{CGI.escape(name)}"
    document  = Nokogiri::HTML(driver.page_source)

    # scrap the data
    self.total_search_results = document.at_css("div#result-stats").text # ex: Sekitar 46.000.000 hasil (0,19 detik)
    self.total_links          = document.xpath('//a').size # find all link tags, and return the total
    self.total_adwords        = document.css('div[data-text-ad="1"]').size
    self.html_page            = driver.page_source
    self.processed_at         = Time.now
    self.save!

    self
  end

  # send to worker to process scrap data asynchronously
  def async_process_scrap
    WebScrapperWorker.perform_async(id)
  end

  private

  def strip_name
    self.name = name.to_s.strip.downcase
  end
end

# == Schema Information
#
# Table name: keywords
#
#  id                   :bigint           not null, primary key
#  name                 :string
#  total_adwords        :integer
#  total_links          :integer
#  total_search_results :string
#  html_page            :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :bigint
#  processed_at         :datetime
#
