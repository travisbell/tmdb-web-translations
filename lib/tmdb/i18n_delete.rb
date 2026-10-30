# frozen_string_literal: true

class I18nDelete
  attr_reader :delete_key

  def initialize(delete_key:)
    unless delete_key.is_a?(Array) && !delete_key.empty? && delete_key.all? { |key| key.is_a?(String) && !key.empty? }
      raise ArgumentError, "delete_key must be a non-empty array of string keys"
    end
    @delete_key = delete_key
  end

  def apply(target)
    locale = target.keys.first

    node = target[locale]
    parents = []
    delete_key[0...-1].each do |key|
      return target unless node.is_a?(Hash) && node.key?(key)

      parents << [node, key]
      node = node[key]
    end
    return target unless node.is_a?(Hash) && node.key?(delete_key.last)

    node.delete(delete_key.last)
    parents.reverse_each do |parent, key|
      break unless parent[key].is_a?(Hash) && parent[key].empty?

      parent.delete(key)
    end

    target
  end
end
