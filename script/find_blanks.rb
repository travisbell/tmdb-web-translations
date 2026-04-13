#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

# Finds keys that are blank/nil in a target locale file but have a value in en-US.yml.
# Useful for identifying what needs translating before running an AI translation pass.
#
# Usage:
#   script/find_blanks.rb <locale>
#   script/find_blanks.rb de-DE
#   script/find_blanks.rb de-DE pt-BR
#
# Output:
#   BLANK: some.key.path => "English value"

def find_blanks(de_node, en_node, path = "")
  return unless de_node.is_a?(Hash)

  de_node.each do |key, de_val|
    full_path = path.empty? ? key.to_s : "#{path}.#{key}"
    en_val = en_node.is_a?(Hash) ? en_node[key] : nil

    if de_val.nil? && !en_val.nil? && !en_val.is_a?(Hash)
      puts "BLANK: #{full_path} => #{en_val.inspect}"
    elsif de_val.is_a?(Hash)
      find_blanks(de_val, en_val.is_a?(Hash) ? en_val : {}, full_path)
    end
  end
end

locales = ARGV.empty? ? abort("Usage: script/find_blanks.rb <locale> [locale ...]") : ARGV

en = YAML.load_file(File.join(__dir__, "../locales/en-US.yml"))

locales.each do |locale|
  path = File.join(__dir__, "../locales/#{locale}.yml")
  abort("File not found: #{path}") unless File.exist?(path)

  target = YAML.load_file(path)
  root_key = target.keys.first

  puts "# #{locale}" if locales.size > 1
  find_blanks(target[root_key], en["en-US"])
end
