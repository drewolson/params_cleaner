require "ostruct"
require "active_support/concern"
require "active_support/core_ext/hash/deep_merge"
require "active_support/core_ext/hash/slice"
require "active_support/hash_with_indifferent_access"
require "./lib/params_cleaner/whitelist"

module ParamsCleaner
  extend ActiveSupport::Concern

  VERSION = "0.4.0"

  def clean_params
    sanitized_params = _applicable_whitelists.map do |whitelist|
      whitelist.sanitize(params)
    end

    sanitized_params.inject(HashWithIndifferentAccess.new) do |new_params, sanitized|
      new_params.deep_merge(sanitized)
    end
  end

  def _action_whitelists
    self.class._action_whitelists
  end

  def _applicable_whitelists
    [_action_whitelists[:_all_], _action_whitelists[_current_action_name]].compact
  end

  def _current_action_name
    if respond_to?(:action_name)
      action_name.to_sym
    else
      nil
    end
  end

  module ClassMethods
    def allowed_params(*params_groups)
      @action_whitelists ||= {}
      @action_whitelists[:_all_] = Whitelist.new(params_groups)
    end

    def allowed_params_for(action, *params_groups)
      @action_whitelists ||= {}
      @action_whitelists[action] = Whitelist.new(params_groups)
    end

    def _action_whitelists
      @action_whitelists
    end
  end
end
