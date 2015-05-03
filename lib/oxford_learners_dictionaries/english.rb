require 'nokogiri'
require 'open-uri'

module OxfordLearnersDictionaries
  class English
    attr_reader :definition, :type, :urls, :word, :examples

    def initialize word
      formatted_word = word.strip.gsub(' ', '-') rescue ''
      param_word = formatted_word.gsub('-', '+')
      main_url =  "http://www.oxfordlearnersdictionaries.com/definition/english/#{formatted_word}?q=#{param_word}"

      @urls = [ main_url, main_url.gsub('?q=', '1?q=') ]
      @word = formatted_word
    end

    def look_up
      @urls.each do |url|
        begin
          @page = Nokogiri::HTML(open(url))
          break
        rescue OpenURI::HTTPError
          @page = nil
        end
      end
      return {} if @page.nil?

      @page.css('.idm-gs').remove
      parse
      self.definition
    end

    private
    def parse
      @definition = Definition.new(@page).parse
      # parse_type
      # parse_examples
      # self
    end
  end
end

