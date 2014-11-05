require 'spec_helper'

describe Oxford::Learners::Dictionaries::English do

  let(:word) { "word" }
  let(:dictionary) { described_class.new(word) }
  let(:url) { "http://www.oxfordlearnersdictionaries.com/definition/english/#{word}"  }

  describe '.initialize' do

    it 'initializes @word' do
      expect(dictionary.word).to eq word
    end

    it 'initializes @url' do
      expect(dictionary.url).to eq url
    end

    it 'initializes @definition' do
      expect(dictionary.definition).to eq Hash.new
    end

    it 'does not initialize page' do
      expect(dictionary.page).to be_nil
    end
  end

  describe '#look_up' do
    it 'open url and parse data' do
      stub_request(:any, url).to_return(body: "fpgentil")
      expect(dictionary).to receive(:parse).and_return(true)
      dictionary.look_up
    end
  end

  describe "looking up a word" do
    before :each do
      stub_request(:any, url).to_return(body: File.new(fixture))
      dictionary.look_up
    end

    describe 'random words' do
      let(:fixture) { "./spec/fixtures/#{word}.html" }

      context 'aviator' do
        let(:word)  { 'aviator' }
        let(:type)  { 'noun' }
        let(:count) { 1 }

        it 'matches noun' do
          expect(dictionary.type).to eq type
        end

        it 'counts 3 definitions' do
          expect(dictionary.definition.count).to eq count
        end
      end

      context 'purse' do
        let(:word)  { 'purse' }
        let(:type)  { 'noun' }
        let(:count) { 3 }

        it 'matches noun' do
          expect(dictionary.type).to eq type
        end

        it 'counts 3 definitions' do
          expect(dictionary.definition.count).to eq count
        end
      end
    end

    describe 'when a word has more than one definitions' do
      let(:definition_0) { "a road vehicle with an engine and four wheels that can carry a small number of passengers" }
      let(:definition_1) { "a separate section of a train" }
      let(:definition_2) { "a coach/car on a train of a particular type" }
      let(:fixture) { "./spec/fixtures/car.html" }

      it 'counts 3 definitions' do
        expect(dictionary.definition.count).to eq 3
      end

      it 'shows all definitions in Hash' do
        expect(dictionary.definition[:definition_0]).to eq definition_0
        expect(dictionary.definition[:definition_1]).to eq definition_1
        expect(dictionary.definition[:definition_2]).to eq definition_2
      end
    end

    describe 'when a word has only one definition' do
      let(:definition) { "a large powerful animal of the cat family, that hunts in groups" }
      let(:fixture) { "./spec/fixtures/lion.html" }

      it 'counts 1 definition' do
        expect(dictionary.definition.count).to eq 1
      end

      it 'shows definition in Hash' do
        expect(dictionary.definition[:definition_0]).to match definition
      end
    end

    describe 'getting type from words' do
      let(:fixture) { "./spec/fixtures/#{word}.html" }

      context 'when its a noun' do
        let(:type) { "noun" }
        let(:word) { "car" }

        it 'matches noun' do
          expect(dictionary.type).to eq type
        end
      end

      context 'when its a verb' do
        let(:type) { "verb" }
        let(:word) { "live" }

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
end
