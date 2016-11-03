
require './bin/config'
require './lib/list_provider'
require 'selenium-webdriver'

require 'open-uri'
require 'open_uri_redirections'

require './lib/mylogger'
require './lib/partial_download'


class CodeSchoolDownloader


  DOWNLOAD_LOCATION = Dir.home + '/Desktop/Codeschool'

  def initialize username, password

    @base_url = "https://www.codeschool.com"

    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['thatoneguydotnet.QuickJava.startupStatus.Images'] = 2

    @driver = Selenium::WebDriver.for :firefox, :profile => profile
    # @driver = Selenium::WebDriver.for :firefox    
    
    @wait = Selenium::WebDriver::Wait.new(:timeout => 360)


    # @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 360

    @driver.get(@base_url + "/users/sign_in")

    $logger.debug("Sleeping for 5...")
    sleep(5)
    wait_element(:link, "Sign in").click()

    login(username, password)
    puts("Logged In!")

    create_dir DOWNLOAD_LOCATION
    # @browser.wait
    # sleep(10)
    download_videos
  end


  def wait_element(type, id)
    $logger.debug("Waiting for [#{id}] #{type}")
    input = @wait.until do
        element = @driver.find_element(type, id)
        $logger.debug("Dislayed: #{element.displayed?}")
        element if element.displayed?
    end
    # $logger.debug("Found!")
    input
  end


  def login(username, password)

    puts("Entering credentials...")

    username = wait_element(:id, 'user_login')
    username.clear()
    username.send_keys(ConfigCodeSchool::USERNAME)

    password = wait_element(:id, 'user_password')
    password.clear();
    password.send_keys(ConfigCodeSchool::PASSWORD)

    login_button = @driver.find_element(:class, 'form-btn')
    login_button.click()
  end


  def download_videos
    require 'nokogiri'

    # deal_with_screencasts
    deal_with_courses
  end


  def deal_with_courses
    puts("Dealing with courses...")
    dir_name = DOWNLOAD_LOCATION + '/courses'
    create_dir dir_name

    LinkGenerator.course_urls.each do |url|
    # ListProvider.get_video_list().each do |url|
    puts url
      #download url, dir_name
    end


  end


  def deal_with_screencasts
    dir_name = DOWNLOAD_LOCATION + '/screencasts'
    create_dir dir_name
    LinkGenerator.screencast_urls.each do |url|
      # download_screencasts url, dir_name, url.split('/').last.gsub('-', ' ')
      puts("'#{url}',")
    end
  end


  def download url, dir_name, passed_in_filename = nil
    puts "\nCourse"
    p url
    puts

    @driver.navigate.to(url)

    html = @driver.page_source
    page = Nokogiri::HTML.parse(html)
    sub_dir_name =  dir_name + '/' + page.css('h1').text.gsub('Screencast', '').strip.gsub(/\W/, ' ').gsub(/\s+/, ' ').gsub(/\s/, '-')
    create_dir sub_dir_name
    filenames = page.css('.tct').map(&:text)
    counter = 1
    links = @driver.find_elements(:class, "js-level-open")
    videos_total = links.size

    puts("Found #{videos_total} video(s)")

    links.each do |course|

      $logger.debug(url)
      downloaded_list = PartialDownload::MAP[url]

      if downloaded_list && !downloaded_list.include?(counter) 
        begin
          puts "Processing video #{counter} of #{videos_total}..."        
          course.click()
          video_page = Nokogiri::HTML.parse(@driver.page_source)
          url = video_page.css('div#level-video-player video').attribute('src').value
          puts "URL retrieved"
          puts "Closing video..."
          
          @driver.find_elements(:class, "modal-close")[3].click()
          index_str = "%02d" % counter
          name = passed_in_filename ? passed_in_filename : "#{index_str} - #{filenames[counter -1]}"
          filename = "#{sub_dir_name}/#{name}.mp4"
          
          max_retry = 5
          File.open(filename, 'wb') do |f|
            
            retries = 0
            begin
              puts("Retry #{retries} of #{max_retry}") if retries > 0
              puts "Downloading video #{name}..."
              f.write(open(url, allow_redirections: :all).read)            
            rescue => e
              retry if (retries += 1) < max_retry
            end
            if retries >= max_retry
              puts("Failed after #{retries} attempts. #{url}")
            else
              puts "Saving #{filename}..."
            end
          end
        rescue => e
          counter -= 1  # retry
          p e.inspect
        end

      end  # skip
      counter += 1
    end
  end


  def download_screencasts url, dir_name, passed_in_filename = nil
    puts "\nCourse"
    p url
    puts

    @browser.goto url
    html = @browser.html
    page = Nokogiri::HTML.parse(html)
    sub_dir_name =  dir_name + '/' + page.css('h1 span:last').text.gsub(/\//,'-')
    create_dir sub_dir_name
    begin
      puts "Opening video..."
      video_page = Nokogiri::HTML.parse(@browser.html)
      video_url = video_page.css('div#code-school-screencasts video').attribute('src').value
      puts "VIDEO URL retrieved: #{video_url}"
      puts "Closing video..."
      @browser.back
      name = page.css('h1').text.gsub('Screencast', '').strip.gsub(/\W/, ' ').gsub(/\s+/, ' ').gsub(/\s/, '-')
      filename = "#{sub_dir_name}/#{name}.mp4"
      File.open(filename, 'wb') do |f|
        puts "Downloading video #{name}..."
        f.write(open(video_url, allow_redirections: :all).read)
        puts "Saving #{filename}..."
      end
    rescue => e
      p e.inspect
    end
  end


  def create_dir filename
    unless File.exists? filename
      FileUtils.mkdir filename
    end
  end

end


class LinkGenerator
  
  def self.screencast_urls
    # screencast_url = 'https://www.codeschool.com/shows/code-tv'
    screencast_url = 'https://www.codeschool.com/screencasts/all'
    screencast_selector = 'article.screencast a'
    screencast_urls = []
    screencast_page = Nokogiri::HTML.parse(open(screencast_url))

    screencast_page.css(screencast_selector).each do |element|
      screencast_urls << 'https://www.codeschool.com' + element.attributes['href'].value
    end
    screencast_urls
  end


  def self.course_urls
    course_url = 'https://www.codeschool.com/courses'
    course_selector = '.course-title-link'
    course_urls = []
    course_page = Nokogiri::HTML.parse(open(course_url))

    course_page.css(course_selector).each do |element|
      course_urls << 'https://www.codeschool.com' + element.attributes['href'].value + '/videos'
    end
    course_urls
  end

end


CodeSchoolDownloader.new(ConfigCodeSchool::USERNAME, ConfigCodeSchool::PASSWORD)



