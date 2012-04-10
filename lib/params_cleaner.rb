require "active_support/concern"
require "active_support/core_ext/hash/slice"
require "active_support/hash_with_indifferent_access"

module ParamsCleaner
  extend ActiveSupport::Concern

  VERSION = "0.1.1"

  def clean_params(root_params = params)
    cleaned_params = root_params.map do |key, val|
      if val.kind_of?(Hash)
        clean_values = clean_params(val.slice(*self.class._allowed_params[key.to_sym]))
        [key, clean_values]
      else
        [key, val]
      end
    end

    cleaned_params_hash = Hash[cleaned_params]
    HashWithIndifferentAccess.new(cleaned_params_hash)
  end

  module ClassMethods
    def allowed_params(params_hash)
      @allowed_params = params_hash
    end

    def _allowed_params
      @allowed_params
    end
  end
end
