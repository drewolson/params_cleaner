require "spec_helper"

describe ParamsCleaner do
  describe "clean_params" do
    it "returns params that respect the allowed_params" do
      klass = Class.new do
        include ParamsCleaner

        allowed_params :root => [:foo, :bar]

        def params
          {
            :root => {
              :foo => "foo",
              :bar => "bar",
              :baz => "baz"
            }
          }
        end
      end

      instance = klass.new

      instance.clean_params[:root].should == {
        :foo => "foo",
        :bar => "bar"
      }
    end
  end
end
