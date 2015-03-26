require 'nokogiri'
require 'open-uri'

module OxfordLearnersDictionaries
  class English
    attr_reader :definition, :type, :url, :word

    def initialize word
      formatted_word = word.strip.gsub(' ', '-') rescue ''
      param_word = formatted_word.gsub('-', '+')
      @url = "http://www.oxfordlearnersdictionaries.com/definition/english/#{formatted_word}?q=#{param_word}"
      @word = formatted_word
      @definition = Hash.new
    end

    def look_up
      begin
        @page = Nokogiri::HTML(open(@url))
        @page.css('.idm-gs').remove
        parse
      rescue OpenURI::HTTPError
        nil
      end
      self.definition
    end

    private
    def parse
      parse_type
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
        @definition["definition_#{index}".to_sym] = @page.css('.def')[index].text
      end
    end
  end
end

# definition.css(".x-g").each do |examples|
#   puts "# #{examples.css(".x").text}"
# end
