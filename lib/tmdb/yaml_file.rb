# frozen_string_literal: true

require "yaml"
require "tmdb/atomic_file"

module TMDb
  module YamlFile
    class InvalidYaml < StandardError; end

    module_function

    def load(path, locale: nil)
      source = File.read(path, encoding: "UTF-8")
      raise InvalidYaml, "#{path}: invalid UTF-8" unless source.valid_encoding?

      stream = YAML.parse_stream(source, filename: path)
      unless stream.children.length == 1
        raise InvalidYaml, "#{path}: expected exactly one YAML document"
      end
      validate_keys(stream, path)
      data = YAML.safe_load(source, permitted_classes: [Symbol], filename: path)
      raise InvalidYaml, "#{path}: expected a mapping" unless data.is_a?(Hash)

      validate_key_types(data, path)
      if locale && data.keys != [locale]
        raise InvalidYaml, "#{path}: expected only root #{locale.inspect}, got #{data.keys.inspect}"
      end
      data
    rescue Psych::Exception => error
      raise InvalidYaml, "#{path}: #{error.message}"
    end

    # Re-serializing changes quoting and wrapping, so leave a file untouched when
    # its data is unchanged. Returns true when the file was written.
    def write(path, data, original: nil)
      original = load(path) if original.nil? && File.exist?(path)
      content = YAML.dump(data, line_width: -1)
      # Compare serialized forms: Hash#== ignores key order, which sort.rb changes.
      return false if !original.nil? && YAML.dump(original, line_width: -1) == content

      AtomicFile.write(path, content)
      true
    end

    # Validate and compute every replacement before writing, so data errors do
    # not leave earlier files updated. I/O failures can still occur mid-write.
    def update_all(file_paths)
      updates = file_paths.map do |path|
        original = load(path)
        [path, original, yield(path, Marshal.load(Marshal.dump(original)))]
      end
      updates.select { |path, original, updated| write(path, updated, original: original) }.map(&:first)
    end

    def paths(arguments)
      arguments.flat_map do |path|
        File.directory?(path) ? Dir.glob(File.join(path, "**/*.yml")).sort : path
      end
    end

    def validate_keys(node, path)
      if node.is_a?(Psych::Nodes::Mapping)
        seen = {}
        node.children.each_slice(2) do |key, value|
          unless key.is_a?(Psych::Nodes::Scalar)
            raise InvalidYaml, "#{path}: non-scalar mapping key at line #{key.start_line + 1}"
          end
          if seen.key?(key.value)
            raise InvalidYaml, "#{path}: duplicate key #{key.value.inspect} at line #{key.start_line + 1}"
          end
          seen[key.value] = true
          validate_keys(value, path)
        end
      else
        node.children&.each { |child| validate_keys(child, path) }
      end
    end

    def validate_key_types(data, path)
      case data
      when Hash
        data.each do |key, value|
          raise InvalidYaml, "#{path}: non-string key #{key.inspect}; quote YAML codes such as NO/no" unless key.is_a?(String)

          validate_key_types(value, path)
        end
      when Array
        data.each { |value| validate_key_types(value, path) }
      end
    end
  end
end
