require 'nokogiri'

module OxfordLearnersDictionaries
  class Definition
    attr_reader :signification, :examples

    def initialize page
      @page = page
      @signification = Array.new
    end

    def parse_single_definition
      signification =  @page.css('.def')
      @signification = signification.count > 0 ? signification[0].text : signification.text
      self
    end

    def parse_multiple_definitions index
      @signification = @page.css('.def')[index].text
      self
    end
  end
end
