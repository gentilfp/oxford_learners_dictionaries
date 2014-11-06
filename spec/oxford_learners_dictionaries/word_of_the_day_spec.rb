require 'spec_helper'

describe OxfordLearnersDictionaries::WordOfTheDay do

  let(:word) { 'election' }
  let(:short_definition) { 'the process of choosing a person or a group of people…' }

  let(:url)     { 'http://www.oxfordlearnersdictionaries.com' }
  let(:fixture) { './spec/fixtures/wotd.html' }

  let(:wotd)    { described_class.new }

  describe '.initialize' do
    before do
      stub_request(:any, url).to_return(body: File.new(fixture))
    end

    it 'matches word of the day' do
      expect(wotd.word).to eq word
    end

    it 'gets short definition for wotd' do
      expect(wotd.short_definition).to eq short_definition
    end
  end

end
