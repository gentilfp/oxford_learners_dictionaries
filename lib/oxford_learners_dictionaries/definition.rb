module OxfordLearnersDictionaries
  class Definition
    attr_reader :definition, :examples

    def intialize page
      @page = page
    end

    def parse
      if @page.css('.num').count > 0
        parse_multiple_definitions
      else
        parse_single_definition
      end
    end

    private
    def parse_single_definition
      definitions =  @page.css('.def')
      @definition[:definition_0] = definitions.count > 0 ? definitions[0].text : definitions.text
    end

    def parse_multiple_definitions
      @page.css('.num').count.times do |index|
        @definition[:"definition_#{index}"] = @page.css('.def')[index].text
      end
    end
  end
end
