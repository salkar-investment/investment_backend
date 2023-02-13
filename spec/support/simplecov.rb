# frozen_string_literal: true

require "simplecov"
SimpleCov.start

if ENV["CI"]
  require "simplecov-cobertura"
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end
