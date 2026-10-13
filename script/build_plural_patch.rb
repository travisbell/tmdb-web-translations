#!/usr/bin/env ruby

# This is used to build a patch for plural keys as part of the transition to Weblate.
# The input is lines descripting the path to each key, as output by yayaml. eg.
#
# ya -p '\.(zero|one|two|few|many|other)$' locales/be-BY.yml
# locales/be-BY.yml:578 be-BY.accounts.events.emails.number_of_items.one: %{count} электронны ліст
# locales/be-BY.yml:579 be-BY.accounts.events.emails.number_of_items.other: %{count} электронных лістоў
#
# The --rule argument can be used to describe which plurals to copy to an extra key, eg.
# --rule other:few,many will copy the 'other' key to new 'few' and 'many' keys.

require "optparse"
require "yaml"

@rules = {}
@patch = {}

OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [options] < MATCHING_LINES"
  parser.on("--rule VALUE", "Rules, eg. other:many,few") do |value|
    value.split(":", 2) => key, value
    @rules.merge!(key => value.to_s.split(","))
  end
end.parse!

at_exit do
  patch_parts = ARGF.each_line(chomp: true).map { |line| line.split(" ", 3) => _, key, value; [key.chomp(":").split("."), value] }
  patch_parts.each do |keys, value|
    sub_patch = @patch
    keys => *path_keys, plural_key

    path_keys.each do |key|
      sub_patch = sub_patch[key] ||= {}
    end

    @rules[plural_key].to_a.each do |key|
      sub_patch[key] ||= value
    end

    sub_patch[plural_key] = value
  end

  puts YAML.dump(@patch, line_width: -1)
end
