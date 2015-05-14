require 'spec_helper'

describe OxfordLearnersDictionaries::WordOfTheDay do

  let(:word) { 'eye-catching' }
  let(:wotd) { described_class.new }

  let(:formatted_word)   { word.strip.gsub(' ', '-') }
  let(:param_word)       { formatted_word.gsub('-', '+') }
  let(:short_definition) { 'immediately noticeable because it is' }

  let(:url)          { 'http://www.oxfordlearnersdictionaries.com' }
  let(:word_url)     { "http://www.oxfordlearnersdictionaries.com/definition/english/#{formatted_word}?q=#{param_word}" }
  let(:fixture_wotd) { './spec/fixtures/wotd.html' }
  let(:fixture)      { './spec/fixtures/election.html' }

  describe '.initialize' do
    it 'matches word of the day' do
      expect(wotd.word).to eq word
    end

    it 'gets short definition for wotd' do
      expect(wotd.short_definition).to match short_definition
    end
  end

  describe '.look_up' do
    context 'when word is nil' do
      before do
        stub_request(:any, url).to_return(body: nil)
        wotd.look_up
      end

      it 'does not instantiate English class' do
        expect(OxfordLearnersDictionaries::English).to_not receive(:new)
      end

      it 'keeps english attribute as nil' do
        expect(wotd.english).to be_nil
      end
    end

    context 'when word is valid' do
      before do
        wotd.look_up
      end

      let(:definition) { 'immediately noticeable because it is particularly interesting, bright or attractive' }

      it 'matches description count' do
        expect(wotd.english.count).to eq 1
        expect(wotd.english.first.signification).to match definition
      end
    end
  end
end
