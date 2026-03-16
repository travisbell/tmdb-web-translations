class I18nDelete
  attr_reader :delete_key

  def initialize(delete_key:)
    @delete_key = delete_key
  end

  def apply(target)
    locale = target.keys.first

    # Walks through nested keys and deletes the last value and empty parent hashes.
    # Given "meep.moop.beep"
    #   => ["meep", "moop"], "beep"
    #   => ["meep"], "moop"
    #   => [], "meep"
    delete_key.length.downto(1).each do |i|
      *rest, key = delete_key[0...i]
      case target.dig(locale, *rest, key)
      when String, {}, nil
        target.dig(locale, *rest)&.delete(key)
      else
        break
      end
    end

    target
  end
end
