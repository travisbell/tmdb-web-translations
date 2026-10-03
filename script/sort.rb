#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "yaml"
require "tmdb/yaml_file"

at_exit do
  each_yaml(ARGV) do |file_path, yaml|
    sorted_yaml = deep_sort_keys(yaml)

    abort "YAML structure changed in #{file_path}!" unless yaml == sorted_yaml

    sorted_yaml
  end
end

def deep_sort_keys(obj, new_obj = {})
  obj.each do |key, value|
    new_obj[key] = if value.is_a?(Hash)
      deep_sort_keys(value, {}).sort.to_h
    else
      value
    end
  end

  new_obj
end

def each_yaml(paths, &block)
  yaml_files = paths.flat_map do |file_name|
    File.directory?(file_name) ? Dir.glob(File.join(file_name, "**/*.yml")) : file_name
  end

  yaml_files.each do |file_path|
    yaml = TMDb::YamlFile.load(file_path)
    new_yaml = yield file_path, yaml

    TMDb::YamlFile.write(file_path, new_yaml)
  end
end
