require "spec_helper"

describe ParamsCleaner do
  describe "version" do
    it "is 0.1.2" do
      ParamsCleaner::VERSION.should == "0.1.2"
    end
  end

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
        "foo" => "foo",
        "bar" => "bar"
      }
    end

    it "handles top level params" do
      klass = Class.new do
        include ParamsCleaner

        allowed_params(
          :top1,
          :root => [:foo, :bar]
        )

        def params
          {
            :top1 => "value 1",
            :top2 => "value 2",
            :root => {
              :foo => "foo",
              :bar => "bar",
              :baz => "baz"
            }
          }
        end
      end

      instance = klass.new

      instance.clean_params.should == {
        "top1" => "value 1",
        "root" => {
          "foo" => "foo",
          "bar" => "bar"
        }
      }
    end

    it "handles hashes with indifferent_access" do
      klass = Class.new do
        include ParamsCleaner

        allowed_params :root => [:foo, :bar]

        def params
          HashWithIndifferentAccess.new(
            :root => HashWithIndifferentAccess.new(
              :foo => "foo",
              :bar => "bar",
              :baz => "baz"
            )
          )
        end
      end

      instance = klass.new

      instance.clean_params[:root].should == {
        "foo" => "foo",
        "bar" => "bar"
      }
    end

    it "handles nested params" do
      klass = Class.new do
        include ParamsCleaner

        allowed_params(
          :root => [:foo, :bar],
          :foo => [:a, :b]
        )

        def params
          {
            :root => {
              :foo => {
                :a => 1,
                :b => 2,
                :c => 3
              },
              :bar => "bar",
              :baz => "baz"
            }
          }
        end
      end

      instance = klass.new

      instance.clean_params[:root][:foo].should == {
        "a" => 1,
        "b" => 2
      }
    end
  end
end
