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
      @definition = Hash.new
      @examples = Hash.new
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
      parse_type
      parse_examples
      if @page.css('.num').count > 0
        parse_multiple_definitions
      else
        parse_single_definition
      end
      self
    end

    def parse_type
      @type = @page.css('.pos').first.text rescue 'unknown'
    end

    def parse_single_definition
      definitions =  @page.css('.def')
      @definition[:definition_0] = definitions.count > 0 ? definitions[0].text : definitions.text
    end

    def parse_multiple_definitions
      @page.css('.num').count.times do |index|
        @definition[:"definition_#{index}"] = @page.css('.def')[index].text
      end
    end

    def parse_examples
      @page.css(".x-g").each_with_index do |example, index|
        @examples[:"examples_#{index}"] = example.text.strip.capitalize
      end
    end
  end
end

