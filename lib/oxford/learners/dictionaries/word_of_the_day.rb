require 'nokogiri'
require 'open-uri'

module Oxford
  module Learners
    module Dictionaries
      class WordOfTheDay
        attr_reader :word, :short_definition, :english

        URL = "http://www.oxfordlearnersdictionaries.com/us/wotd/american_english/wotdrss.xml"

        def initialize
          parse
        end

        private
        def parse
          @xml = Nokogiri::HTML(open(URL))
          @word = word
          @short_definition = short_definition
          # TODO
          # @english -> look up using English module
        end

        def word
          @xml.xpath("//entry")[0].at("summary").content.
            split("...")[0].split(":")[0].strip
        end

        def short_definition
          @xml.xpath("//entry")[0].at("summary").content.
            split("...")[0].split(":")[1].strip
        end
      end
    end
  end
end
