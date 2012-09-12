module ParamsCleaner
  class Whitelist
    def initialize(whitelist)
      @whitelist_hash = whitelist.last.kind_of?(Hash) ? whitelist.pop : {}
      @top_level_keys = whitelist
    end

    def sanitize(obj, parent = nil)
      if obj.kind_of?(Hash)
        whitelist = @whitelist_hash.keys
        whitelist.concat(@top_level_keys) unless parent
        whitelist.concat(@whitelist_hash[parent]) if @whitelist_hash[parent]
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
