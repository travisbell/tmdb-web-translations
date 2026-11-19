# frozen_string_literal: true

require "ripper"
require "tmdb/atomic_file"

module TMDb
  class PluralizationFiles
    def initialize(rules)
      @rules = rules
      rules.each do |locale, rule|
        unless locale.match?(/\A[a-z]{2}-[A-Z]{2}\z/) && rule.match?(/\A[a-z]+(?:_[a-z]+)*\z/)
          raise ArgumentError, "invalid pluralization mapping: #{locale.inspect} => #{rule.inspect}"
        end
      end
    end

    def render(locale)
      rule = @rules.fetch(locale)
      name = rule.split("_").map(&:capitalize).join
      "require 'weblate/pluralization/#{rule}'\n\n::Weblate::Pluralization::#{name}.with_locale(:'#{locale}')\n"
    end

    def differences(directory)
      expected = @rules.keys.map { |locale| "#{locale}.rb" }
      changes = @rules.keys.reject do |locale|
        path = File.join(directory, "#{locale}.rb")
        File.exist?(path) && equivalent?(File.read(path), render(locale))
      end
      extras = Dir.glob(File.join(directory, "*.rb")).map { |path| File.basename(path) } - expected
      [changes, extras]
    end

    def write(directory)
      changes, extras = differences(directory)
      raise ArgumentError, "unmapped pluralization files: #{extras.join(', ')}" unless extras.empty?

      changes.each { |locale| AtomicFile.write(File.join(directory, "#{locale}.rb"), render(locale)) }
      changes
    end

    private

    # Ignore quoting, whitespace and token positions, while refusing to accept
    # extra executable statements as an equivalent generated wrapper.
    def equivalent?(actual, expected)
      actual_tree = Ripper.sexp(actual)
      actual_tree && normalize(actual_tree) == normalize(Ripper.sexp(expected))
    end

    def normalize(tree)
      return tree unless tree.is_a?(Array)
      return tree[0..1] if tree.first.is_a?(Symbol) && tree.first.to_s.start_with?("@")

      tree.map { |child| normalize(child) }
    end
  end
end
