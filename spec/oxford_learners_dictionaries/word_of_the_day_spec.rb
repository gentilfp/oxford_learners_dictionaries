require 'spec_helper'

describe OxfordLearnersDictionaries::WordOfTheDay do

  let(:word) { 'election' }
  let(:short_definition) { 'the process of choosing a person or a group of people' }

  let(:url)          { 'http://www.oxfordlearnersdictionaries.com' }
  let(:word_url)     { "http://www.oxfordlearnersdictionaries.com/definition/english/#{word}" }
  let(:fixture_wotd) { './spec/fixtures/wotd.html' }
  let(:fixture)      { './spec/fixtures/election.html' }

  let(:wotd)    { described_class.new }

  describe '.initialize' do
    before do
      stub_request(:any, url).to_return(body: File.new(fixture_wotd))
    end

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
        stub_request(:any, url).to_return(body: File.new(fixture_wotd))
        stub_request(:any, word_url).to_return(body: File.new(fixture))
        wotd.look_up
      end

      let(:definition) { 'the process of choosing a person or a group of people for a position' }

      it 'matches description count' do
        expect(wotd.english.definition.count).to eq 2
        expect(wotd.english.definition.to_s).to match definition
      end
    end
  end
end
