require 'nokogiri'
require 'open-uri'

module Oxford
  module Learners
    module Dictionaries
      class English
        attr_reader :definition, :type, :url, :word, :page

        def initialize word
          @word = word
          @url = "http://www.oxfordlearnersdictionaries.com/definition/english/#{word}"
          @definition = Hash.new
          @type = nil
        end

        def look_up
          @page = Nokogiri::HTML(open(@url))
          parse
        end

        private
        def parse
          if @page.css(".n-g").count > 0
            parse_multiple_definitions
          else
            parse_unique_definition
          end
          parse_type
        end

        def parse_type
          @type = @page.css('.pos').text
        end

        def parse_unique_definition
          @definition[:definition_0] = @page.css(".d").text
        end

        def parse_multiple_definitions
          @page.css(".n-g").each_with_index do |definition, index|
            @definition["definition_#{index}".to_sym] = definition.css(".d").text
          end
        end

      end
    end
  end
end

# definition.css(".x-g").each do |examples|
#   puts "# #{examples.css(".x").text}"
# end
