require 'nokogiri'

module OxfordLearnersDictionaries
  class Definition
    attr_reader :text, :examples

    def initialize page
      @page = page
      @examples = Array.new
    end

    def parse_single_definition
      text =  @page.css('.def')
      @text = text.count > 0 ? text[0].text : text.text
      @examples.push(::OxfordLearnersDictionaries::Example.new(@page.css('.x-g')))
      self
    end

    def parse_multiple_definitions index
      @text = @page.css('.def')[index].text
      return self if @page.css('.x-gs')[index].nil?

      @page.css('.x-gs')[index].css('.x-g').each do |example|
        @examples.push(::OxfordLearnersDictionaries::Example.new(example))
      end
      self
    end
  end
end
