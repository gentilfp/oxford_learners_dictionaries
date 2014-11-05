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
          parse_type
          unless parse_unique_definition
            separators = [".sd-d", ".sd-g", ".d"]
            separators.each do |separator|
              if @page.css(separator).count > 1
                parse_multiple_definitions separator
                return self
              end
            end
          end
          self
        end

        def parse_type
          @type = @page.css('.pos').first.text
        end

        def parse_unique_definition
          if @page.css(".h-g").css(".n-g").to_s.empty? && @page.css(".n-g").count < 1
            @definition[:definition_0] = @page.css(".d").text
          end
          !@definition.empty?
        end

        def parse_multiple_definitions separator
          if separator == ".sd-d" || separator == ".d"
            @page.css(separator).each_with_index do |definition, index|
              @definition["definition_#{index}".to_sym] = if definition.text.empty?
                                definition.css(".d").text
                              else
                                definition.text
                              end
            end
          else
            index = 0
            @page.css(separator).each do |external_node|
              external_node.css(".n-g").each do |definition|
                @definition["definition_#{index}".to_sym] = definition.css(".d").text
                index += 1
              end
            end
          end
        end

      end
    end
  end
end

# definition.css(".x-g").each do |examples|
#   puts "# #{examples.css(".x").text}"
# end
