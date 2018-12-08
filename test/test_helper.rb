require 'minitest/autorun'
require 'webmock/minitest'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]
