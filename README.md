OxfordLearnersDictionaries Parser
=================================
[![Code Climate](https://codeclimate.com/github/fpgentil/oxford_learners_dictionaries/badges/gpa.svg)](https://codeclimate.com/github/fpgentil/oxford_learners_dictionaries)
[![Build Status](https://travis-ci.org/fpgentil/oxford_learners_dictionaries.svg?branch=master)](https://travis-ci.org/fpgentil/oxford_learners_dictionaries)

Parser for Oxford Learners Dictionary.

It parses http://www.oxfordlearnersdictionaries.com/ and return the definition(s) of the word you're looking up.

## Features

#### v0.1
Classification (verb, noun, adverb, etc) with its definition(s) and word of the day.

#### v0.2
Definitions including example(s) and Recent Popular searches.

#### v0.3
Including picture and pronunciation (American(NAmE) and British(BrE)).

#### v0.4
Usage, e.g. when looking for 'car', it'll also provide information about 'having a car', 'driving a car', etc.

#### Further versions
Please let me know :)

## Installation

Add this line to your application's Gemfile:

```ruby
# Add to your Gemfile
gem 'oxford_learners_dictionaries'

# or install manually
gem install oxford_learners_dictionaries
```

And then execute:

    $ bundle

## Usage

#### Example 1
```
# Creates object
word = OxfordLearnersDictionaries::English.new("car")

# Goes to the dictionary and parse its data
word.look_up
```

```
word.definition
=> {
  :definition_0 => "a road vehicle with an engine and four wheels that can carry a small number of passengers",
  :definition_1 => "a separate section of a train",
  :definition_2 => "a coach/car on a train of a particular type"
}
```

#### Example 2
```
# Gets word of the day and short definition
word_of_the_day = OxfordLearnersDictionaries::WordOfTheDay.new
```

```word_of_the_day.word
 => "pragmatic"
```

```word_of_the_day.short_definition
 => "solving problems in a practical…"
```

```
# Get the full definition
word_of_the_day.look_up
```

```word_of_the_day.english.definition
 => {:definition_0=>"solving problems in a practical and sensible way rather than by having fixed ideas or theories"}
 ```


## Contributing

1. Fork it ( https://github.com/fpgentil/oxford_learners_dictionaries/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
