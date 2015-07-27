require 'nokogiri'

module OxfordLearnersDictionaries
  class Definition
    attr_reader :signification, :examples

    def initialize page
      @page = page
      @examples = Array.new
    end

    def parse_single_definition
      signification =  @page.css('.def')
      @signification = signification.count > 0 ? signification[0].text : signification.text
      @examples.push(::OxfordLearnersDictionaries::Example.new(@page.css('.x-g')))
      self
    end

    def parse_multiple_definitions index
      @signification = @page.css('.def')[index].text
      return self if @page.css('.x-gs')[index].nil?

      @page.css('.x-gs')[index].css('.x-g').each do |example|
        @examples.push(::OxfordLearnersDictionaries::Example.new(example))
      end
      self
    end
  end
end
