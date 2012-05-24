require "active_support/concern"
require "active_support/core_ext/hash/slice"
require "active_support/hash_with_indifferent_access"

module ParamsCleaner
  extend ActiveSupport::Concern

  VERSION = "0.2.1"

  def clean_params(root_params = params, top_level = true)
    cleaned_params = root_params.map do |key, val|
      if val.kind_of?(Hash)
        _clean_hash(key, val)
      else
        _clean_value(key, val, top_level)
      end
    end

    cleaned_params_hash = Hash[cleaned_params]
    HashWithIndifferentAccess.new(cleaned_params_hash)
  end

  def _clean_hash(key, value)
    allowed_keys = value.slice(*self.class._allowed_nested[key.to_sym])
    clean_values = clean_params(allowed_keys, false)
    [key, clean_values]
  end

  def _clean_value(key, value, top_level)
    return [key, value] unless top_level

    if self.class._allowed_top_level.include?(key.to_sym)
      [key, value]
    else
      []
    end
  end

  module ClassMethods
    def allowed_params(*params_groups)
      @allowed_top_level = []

      params_groups.each do |params_group|
        if params_group.is_a?(Hash)
          @allowed_nested = params_group
        else
          @allowed_top_level << params_group
        end
      end
    end

    def _allowed_nested
      @allowed_nested
    end

    def _allowed_top_level
      @allowed_top_level
    end
  end
end
