require 'nokogiri'
require 'watir-webdriver'
require 'open-uri'
require 'open_uri_redirections'

require './bin/config'


class CodeSchoolDownloader


  attr_accessor :browser
  DOWNLOAD_LOCATION = Dir.home + '/Desktop/Codeschool'
  TIMEOUT = 0


  def initialize username, password

    @browser = Watir::Browser.new
    login username, password
    puts "Logged In!"

    create_dir DOWNLOAD_LOCATION
    download_videos
  end


  def download_videos
    deal_with_screencasts
    # deal_with_courses
  end


  def login username, password
    puts "Loading signin page..."
    @browser.goto 'https://www.codeschool.com/users/sign_in'
    puts "Loaded"

    t = @browser.text_field :id => 'user_login'
    t.set username

    t = @browser.text_field :id => 'user_password'
    t.set password

    @browser.button(class: 'form-btn').click
    puts("Logging in...")
  end


  def deal_with_screencasts
    dir_name = DOWNLOAD_LOCATION + '/screencasts'
    create_dir dir_name
    LinkGenerator.screencast_urls.each do |url|
      download_screencasts url, dir_name, url.split('/').last.gsub('-', ' ')
      # puts("'#{url}',")
    end
  end


  def deal_with_courses
    puts("Dealing with courses...")
    dir_name = DOWNLOAD_LOCATION + '/courses'
    create_dir dir_name

    # LinkGenerator.course_urls.each do |url|
    get_links().each do |url|
      download url, dir_name
    end

  end


  def get_links()
    return [    
    'https://www.codeschool.com/courses/powering-up-with-react/videos',
    'https://www.codeschool.com/courses/try-sql/videos',
    'https://www.codeschool.com/courses/try-ember/videos',
    'https://www.codeschool.com/courses/flying-through-python/videos',
    'https://www.codeschool.com/courses/javascript-road-trip-part-1/videos',
    'https://www.codeschool.com/courses/javascript-road-trip-part-2/videos',
    'https://www.codeschool.com/courses/app-evolution-with-swift/videos',
    'https://www.codeschool.com/courses/es2015-the-shape-of-javascript-to-come/videos',
    'https://www.codeschool.com/courses/the-sequel-to-sql/videos',
    'https://www.codeschool.com/courses/the-magical-marvels-of-mongodb/videos',
    'https://www.codeschool.com/courses/breaking-the-ice-with-regular-expressions/videos',
    'https://www.codeschool.com/courses/rails-for-zombies-2/videos',
    'https://www.codeschool.com/courses/try-ruby/videos',
    'https://www.codeschool.com/courses/rails-for-zombies-redux/videos',
    'https://www.codeschool.com/courses/rails-testing-for-zombies/videos',
    'https://www.codeschool.com/courses/ruby-bits-part-2/videos',
    'https://www.codeschool.com/courses/adventures-in-web-animations/videos',
    'https://www.codeschool.com/courses/unmasking-html-emails/videos',
    'https://www.codeschool.com/courses/you-me-svg/videos',
    'https://www.codeschool.com/courses/staying-sharp-with-angular-js/videos',
    'https://www.codeschool.com/courses/blasting-off-with-bootstrap/videos',
    'https://www.codeschool.com/courses/building-blocks-of-express-js/videos',
    'https://www.codeschool.com/courses/front-end-foundations/videos',
    'https://www.codeschool.com/courses/mastering-github/videos',
    'https://www.codeschool.com/courses/shaping-up-with-angular-js/videos',
    'https://www.codeschool.com/courses/exploring-google-maps-for-ios/videos',
    'https://www.codeschool.com/courses/surviving-apis-with-rails/videos',
    'https://www.codeschool.com/courses/javascript-road-trip-part-3/videos',
    'https://www.codeschool.com/courses/front-end-formations/videos',
    'https://www.codeschool.com/courses/core-ios-7/videos',
    'https://www.codeschool.com/courses/rails-4-patterns/videos',
    'https://www.codeschool.com/courses/fundamentals-of-design/videos',
    'https://www.codeschool.com/courses/jquery-the-return-flight/videos',
    'https://www.codeschool.com/courses/ios-operation-mapkit/videos',
    'https://www.codeschool.com/courses/git-real-2/videos',
    'https://www.codeschool.com/courses/ios-operation-models/videos',
    'https://www.codeschool.com/courses/try-objective-c/videos',
    'https://www.codeschool.com/courses/rails-4-zombie-outlaws/videos',
    'https://www.codeschool.com/courses/discover-devtools/videos',
    'https://www.codeschool.com/courses/try-jquery/videos',
    'https://www.codeschool.com/courses/anatomy-of-backbone-js-part-2/videos',
    'https://www.codeschool.com/courses/assembling-sass-part-2/videos',
    'https://www.codeschool.com/courses/try-ios/videos',
    'https://www.codeschool.com/courses/try-r/videos',
    'https://www.codeschool.com/courses/assembling-sass/videos',
    'https://www.codeschool.com/courses/ruby-bits/videos',
    'https://www.codeschool.com/courses/git-real/videos',
    'https://www.codeschool.com/courses/try-git/videos',
    'https://www.codeschool.com/courses/real-time-web-with-node-js/videos',
    'https://www.codeschool.com/courses/anatomy-of-backbone-js/videos',
    'https://www.codeschool.com/courses/journey-into-mobile/videos',
    'https://www.codeschool.com/courses/css-cross-country/videos',
    'https://www.codeschool.com/courses/coffeescript/videos',
    'https://www.codeschool.com/courses/the-elements-of-web-design/videos']
  end


  def download url, dir_name, passed_in_filename = nil
    puts "\nCourse"
    p url
    puts

    @browser.goto url
    puts "Loaded videos URL"

    html = @browser.html
    page = Nokogiri::HTML.parse(html)
    sub_dir_name =  dir_name + '/' + page.css('h1').text.gsub('Screencast', '').strip.gsub(/\W/, ' ').gsub(/\s+/, ' ').gsub(/\s/, '-')
    create_dir sub_dir_name
    filenames = page.css('.tct').map(&:text)
    counter = 1
    links = @browser.links(:class, "js-level-open")
    videos_total = links.size

    puts("Found #{videos_total} video(s)")

    links.each do |course|
      if counter >= 1 # begin skip

        begin
          puts "Processing video #{counter} of #{videos_total}..."        
          course.when_present.fire_event("click")
          sleep 3
          video_page = Nokogiri::HTML.parse(@browser.html)
          url = video_page.css('div#level-video-player video').attribute('src').value
          puts "URL retrieved"
          puts "Closing video..."
          @browser.links(:class, "modal-close")[3].when_present.fire_event("click")
          name = passed_in_filename ? passed_in_filename : "#{(counter).to_s.ljust 2}- #{filenames[counter -1]}"
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
      puts "VIDEO URL retrieved"
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


  def download_video()

  end


  def create_dir filename
    unless File.exists? filename
      FileUtils.mkdir filename
    end
  end


  def timeout
    TIMEOUT + rand(5)
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



