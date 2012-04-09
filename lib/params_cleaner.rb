require "active_support"
require "active_support/core_ext/hash/slice"

module ParamsCleaner
  extend ActiveSupport::Concern

  def clean_params
    cleaned_params = params.map do |key, val|
      if val.is_a?(Hash)
        [key, val.slice(*self.class._allowed_params[key])]
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
