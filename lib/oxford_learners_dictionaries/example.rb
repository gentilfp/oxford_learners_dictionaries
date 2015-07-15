module OxfordLearnersDictionaries
  class Example
    attr_reader :example

    def initialize page
      @page = page
    end

    def parse
      @page.css('.x-g').each do |example|
        @examples = example.text
      end
      self
    end
  end
end
