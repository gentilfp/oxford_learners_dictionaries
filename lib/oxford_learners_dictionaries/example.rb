module OxfordLearnersDictionaries
  class Example
    attr_reader :example

    def initialize page
      @page = page
    end

    def parse
      @page.css(".x-g").each_with_index do |example, index|
        @examples[:"examples_#{index}"] = example.text.strip.capitalize
      end
    end
  end
end
