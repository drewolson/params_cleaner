module ParamsCleaner
  class Whitelist
    def initialize(whitelist)
      @whitelist = whitelist
    end

    def sanitize(params, top_level = true)
      cleaned_params = params.map do |key, value|
        if value.kind_of?(Hash)
          _clean_hash(key, value)
        elsif value.kind_of?(Array)
          _clean_array(key, value)
        else
          _clean_value(key, value, top_level)
        end
      end

      cleaned_params_hash = Hash[cleaned_params]
      HashWithIndifferentAccess.new(cleaned_params_hash)
    end

    def _allowed_nested
      @whitelist.detect { |params_group| params_group.is_a?(Hash) } || {}
    end

    def _allowed_top_level
      params_groups = []
      @whitelist.each do |params_group|
        unless params_group.is_a?(Hash)
          params_groups << params_group
        end
      end
      params_groups
    end

    def _clean_array(key, value)
      cleaned_values = value.map do |sub_value|
        if sub_value.is_a?(Hash)
          _clean_hash(key, sub_value).last
        else
          sub_value
        end
      end
      [key, cleaned_values]
    end

    def _clean_hash(key, value)
      allowed_keys = value.slice(*_allowed_nested[key.to_sym])
      clean_values = sanitize(allowed_keys, false)
      [key, clean_values]
    end

    def _clean_value(key, value, top_level)
      return [key, value] unless top_level

      if _allowed_top_level.include?(key.to_sym)
        [key, value]
      else
        []
      end
    end
  end
end
