#!/usr/bin/env ruby

require "yaml"

# Usage:
# script/locale_check.rb [target_dirs ... target_files ...]

at_exit do
  yaml_files(ARGV).each do |file_path|
    locale = File.basename(file_path, ".yml")
    yaml = YAML.load_file(file_path)

    warn "Root key #{yaml.keys.first} does not match filename #{file_path}" unless yaml.keys.first == locale
  end
end

def yaml_files(args)
  args.flat_map { |file_name|
    File.directory?(file_name) ? Dir.glob(File.join(file_name, "**/*.yml")) : file_name
  }
end
