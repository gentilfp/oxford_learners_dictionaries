require 'nokogiri'
require 'open-uri'

module Oxford
  module Learners
    module Dictionaries
      class WordOfTheDay
        attr_reader :word, :short_definition#, :english

        URL = "http://www.oxfordlearnersdictionaries.com"

        def initialize
          parse
        end

        private
        def parse
          @wotd = Nokogiri::HTML(open(URL)).at("#daybox")
          @word = word
          @short_definition = short_definition
        end

        def word
          wotd.css(".h").text unless wotd.nil?
        end

        def short_definition
          wotd.css(".d").text unless wotd.nil?
        end
      end
    end
  end
end

# TODO
# @english -> look up using English module
