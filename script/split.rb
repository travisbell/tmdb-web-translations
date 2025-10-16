#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "optparse"
require "tempfile"
require "yaml"

# Usage:
# ruby script/sort.rb --sort-keys ~/Downloads/i18n_locales.yml

OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [options]"
  parser.on("-s", "--sort-keys") do
    @sort = true
  end
end.parse!

at_exit do
  source_path = ARGV.shift
  abort if source_path.nil? || source_path.empty?

  data = YAML.load_file(source_path)
  data.each do |locale, translations|
    data = { locale => translations }
    data = deep_sort_keys(data) if @sort

    file_path = "locales/#{locale}.yml"

    tempfile = Tempfile.create(File.basename(file_path))
    tempfile.write(YAML.dump(data, line_width: -1))

    File.unlink(file_path)
    File.link(tempfile.path, file_path)
  end
end

def deep_sort_keys(obj, new_obj = {})
  obj.each do |key, value|
    if value.is_a?(Hash)
      new_obj[key] = deep_sort_keys(value, {}).sort.to_h
    else
      new_obj[key] = value
    end
  end

  new_obj
end
