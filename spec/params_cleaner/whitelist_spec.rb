require "spec_helper"

describe ParamsCleaner::Whitelist do
  describe "verify!" do
    it "raises an error if given bad params" do
      params = HashWithIndifferentAccess.new(
        :root => HashWithIndifferentAccess.new(
          :foo => "foo",
          :bar => "bar",
          :baz => "baz"
        )
      )

      whitelist = ParamsCleaner::Whitelist.new([:root => [:foo, :bar]])

      expect do
        whitelist.verify!(params)
      end.to raise_error("[ParamsCleaner] Invalid keys provided: baz")
    end
  end
end
