module OxfordLearnersDictionaries
  class Example
    attr_reader :text

    def initialize page
      @page = page
      parse
    end

    def parse
      @text = @page.text.strip
    end
  end
end
