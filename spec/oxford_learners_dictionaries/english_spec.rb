require 'spec_helper'

describe OxfordLearnersDictionaries::English, :vcr do

  let(:word) { "word" }
  let(:formatted_word)    { word.strip.gsub(' ', '-') }
  let(:param_word)        { formatted_word.gsub('-', '+') }

  let(:dictionary) { described_class.new(word) }
  let(:url_1)      { "http://www.oxfordlearnersdictionaries.com/definition/english/#{formatted_word}?q=#{param_word}" }
  let(:url_2)      { "http://www.oxfordlearnersdictionaries.com/definition/english/#{formatted_word}1?q=#{param_word}" }
  let(:urls)       { [ url_1, url_2 ] }

  describe '.initialize' do

    it 'initializes @word' do
      expect(dictionary.word).to eq word
    end

    it 'initializes @urls' do
      expect(dictionary.urls).to eq urls
    end
  end

  describe '#look_up' do
    it 'open url and parse data' do
      stub_request(:any, url_1).to_return(body: "fpgentil")
      expect(dictionary).to receive(:parse).and_return(true)
      dictionary.look_up
    end
  end

  context "looking up" do
    before :each do
      dictionary.look_up
    end

    describe 'important words' do
      context '#take' do
        let(:word)  { 'take' }
        let(:type)  { 'verb' }
        let(:count) { 42 }

        it 'matches noun' do
          expect(dictionary.type).to eq type
        end

        it 'counts 42 definitions' do
          expect(dictionary.definition.count).to eq count
        end
      end

      context '#get' do
        let(:word)  { 'get' }
        let(:type)  { 'verb' }
        let(:count) { 27 }

        it 'matches noun' do
          expect(dictionary.type).to eq type
        end

        it 'counts 3 definitions' do
          expect(dictionary.definition.count).to eq count
        end
      end
    end

    describe 'when a word has more than one definitions' do
      let(:word)         { 'car' }
      let(:definition_0) { "a road vehicle with an engine and four wheels that can carry a small number of passengers" }
      let(:definition_1) { "a separate section of a train" }
      let(:definition_2) { "a coach/car on a train of a particular type" }

      it 'counts 3 definitions' do
        expect(dictionary.definition.count).to eq 3
      end

      it 'shows all definitions in Hash' do
        expect(dictionary.definition[0].text).to eq definition_0
        expect(dictionary.definition[1].text).to eq definition_1
        expect(dictionary.definition[2].text).to eq definition_2
      end
    end

    describe 'when a word has only one definition' do
      let(:word)       { 'lion' }
      let(:definition) { "a large powerful animal of the cat family, that hunts in groups" }

      it 'counts 1 definition' do
        expect(dictionary.definition.count).to eq 1
      end

      it 'shows definition in Hash' do
        expect(dictionary.definition[0].text).to match definition
      end
    end

    describe 'getting type from words' do
      context 'when its a noun' do
        let(:type) { "noun" }
        let(:word) { "car" }

        it 'matches noun' do
          expect(dictionary.type).to eq type
        end
      end

      context 'when its a verb' do
        let(:type) { "verb" }
        let(:word) { "play" }

        it 'matches verb' do
          expect(dictionary.type).to eq type
        end
      end

      context 'when its an adverb' do
        let(:type) { "adverb" }
        let(:word) { "however" }

        it 'matches adverb' do
          expect(dictionary.type).to eq type
        end
      end
    end
  end

  describe 'when the word is not found' do
    before :each do
      stub_request(:any, url_1).to_raise(OpenURI::HTTPError.new('', nil))
    end
    let(:word) { 'asdf' }

    it 'returns empty' do
      expect(dictionary.look_up).to be_nil
    end
  end
end
