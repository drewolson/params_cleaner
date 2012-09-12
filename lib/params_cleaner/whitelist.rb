module ParamsCleaner
  class Whitelist
    def initialize(whitelist)
      @nested_hash = whitelist[-1].kind_of?(Hash) ? whitelist[-1] : {}
      @top_level_keys = @nested_hash.empty? ? whitelist : whitelist[0..-2]
      @nested_keys = @nested_hash.keys
    end

    def sanitize(obj, parent = nil)
      if obj.kind_of?(Hash)
        whitelist = @nested_keys.dup
        whitelist.concat(@top_level_keys) unless parent
        whitelist.concat(@nested_hash[parent]) if @nested_keys.include?(parent)
        cleaned = obj.map do |key, value|
          [key, sanitize(value, key.to_sym)] if whitelist.include?(key.to_sym)
        end
        HashWithIndifferentAccess.new(Hash[cleaned.compact])
      elsif obj.kind_of?(Array)
        obj.map { |item| sanitize(item, parent) }
      else
        obj
      end
    end
  end
end
