#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "tempfile"
require "yaml"

at_exit do
  each_yaml(ARGV) do |file_path, yaml|
    sorted_yaml = deep_sort_keys(yaml)

    abort "YAML structure changed in #{file_path}!" unless yaml == sorted_yaml

    sorted_yaml
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

def each_yaml(paths, &block)
  yaml_files = paths.flat_map { |file_name|
    File.directory?(file_name) ? Dir.glob(File.join(file_name, "**/*.yml")) : file_name
  }

  yaml_files.each do |file_path|
    yaml = YAML.load_file(file_path)
    new_yaml = yield file_path, yaml

    tempfile = Tempfile.create(File.basename(file_path))
    tempfile.write(YAML.dump(new_yaml, line_width: -1))

    File.unlink(file_path)
    File.link(tempfile.path, file_path)
  end
end
