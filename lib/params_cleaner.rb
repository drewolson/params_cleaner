require "active_support/concern"
require "active_support/core_ext/hash/slice"

module ParamsCleaner
  extend ActiveSupport::Concern

  VERSION = "0.1.0"

  def clean_params(root_params = params)
    cleaned_params = root_params.map do |key, val|
      if val.is_a?(Hash)
        clean_values = clean_params(val.slice(*self.class._allowed_params[key]))
        [key, clean_values]
      else
        [key, val]
      end
    end

    Hash[cleaned_params]
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
