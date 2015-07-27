module OxfordLearnersDictionaries
  class Example
    attr_reader :sentence

    def initialize page
      @page = page
      parse
    end

    def parse
      @sentence = @page.text.strip
    end
  end
end
