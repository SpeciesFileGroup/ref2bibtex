# require 'coveralls'
# Coveralls.wear!

# These are development helpers.
require 'awesome_print'
require 'byebug'
require 'yaml'

# These are required to run tests.
require 'ref2bibtex' 


CITATIONS = YAML.load_file(File.expand_path('support/citations.yml', File.dirname(__FILE__)))


RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
end

