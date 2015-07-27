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
      @definition = Array.new
      self
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
      return nil if @page.nil?

      parse
      self
    end

    private
    def parse
      @page.css('.idm-gs').remove
      @type = ::OxfordLearnersDictionaries::Type.new(@page).parse

      if @page.css('.num').count > 0
        parse_multiple_definitions
      else
        parse_single_definition
      end
    end

    def parse_single_definition
      @definition.push(::OxfordLearnersDictionaries::Definition.new(@page).parse_single_definition)
    end

    def parse_multiple_definitions
      @page.css('.num').count.times do |index|
        @definition.push(::OxfordLearnersDictionaries::Definition.new(@page).parse_multiple_definitions(index))
      end
    end
  end
end

