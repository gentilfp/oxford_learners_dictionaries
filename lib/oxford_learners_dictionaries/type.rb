module OxfordLearnersDictionaries
  class Type
    attr_reader :type

    def initialize page
      @page = page
    end

    def parse
      @type = @page.css('.pos').first.text rescue 'unknown'
    end
  end
end
