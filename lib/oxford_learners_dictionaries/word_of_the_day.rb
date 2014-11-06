require 'nokogiri'
require 'open-uri'

module OxfordLearnersDictionaries
  class WordOfTheDay
    attr_reader :word, :short_definition#, :english

    URL = "http://www.oxfordlearnersdictionaries.com"

    def initialize
      parse
    end

    private
    def parse
      @wotd = Nokogiri::HTML(open(URL)).at("#daybox")
      @word = parse_word
      @short_definition = parse_short_definition
    end

    def parse_word
      @wotd.css(".h").text unless @wotd.nil?
    end

    def parse_short_definition
      @wotd.css(".d").text unless @wotd.nil?
    end
  end
end

# TODO
# @english -> look up using English module
