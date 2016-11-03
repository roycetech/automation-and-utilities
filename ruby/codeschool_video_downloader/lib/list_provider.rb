# Provides the list of URL for the main downloader script.
class ListProvider
  def screencasts
    []
  end

  URL_PATH = 'https://www.codeschool.com/courses/'.freeze

  def self.video_course_urls
    [
      'accelerating-through-angular-2'
    ].collect { |item| "#{URL_PATH}#{item}/videos" }.first(1)
  end
end
