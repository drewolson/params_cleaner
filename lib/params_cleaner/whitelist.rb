module ParamsCleaner
  class Whitelist
    def initialize(whitelist)
      @whitelist = whitelist
    end

    def sanitize(item, parent = nil)
      if item.kind_of?(Hash)
        _sanitize_hash(item, parent)
      elsif item.kind_of?(Array)
        item.map { |item| sanitize(item, parent) }
      else
        item
      end
    end

    def _sanitize_hash(hash, parent)
      valid_keys = _valid_keys_for_parent(parent)
      valid_pairs = hash.select { |key, value| valid_keys.include?(key.to_sym) }
      sanitized_pairs = valid_pairs.map { |key, value| [key, sanitize(value, key.to_sym)] }

      HashWithIndifferentAccess.new(Hash[sanitized_pairs])
    end

    def _top_level_keys
      @top_level_keys ||= @whitelist.reject { |item| item.kind_of?(Hash) }
    end

    def _valid_keys_for_parent(parent)
      _whitelist_hash.keys.tap do |keys|
        keys.concat(_top_level_keys) if parent.nil?
        keys.concat(_whitelist_hash[parent]) if _whitelist_hash.has_key?(parent)
      end
    end

    def _whitelist_hash
      @whitelist_hash ||= @whitelist.last.is_a?(Hash) ? @whitelist.last : {}
    end
  end
end
