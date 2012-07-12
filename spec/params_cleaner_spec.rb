require "spec_helper"

describe ParamsCleaner do
  describe "version" do
    it "is 0.3.1" do
      ParamsCleaner::VERSION.should == "0.3.1"
    end
  end

  describe "clean_params" do
    it "returns params that respect the allowed_params" do
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

    it "handles top level params" do
      klass = Class.new do
        include ParamsCleaner

        allowed_params(
          :top1,
          :root => [:foo, :bar]
        )

        def params
          HashWithIndifferentAccess.new(
            :top1 => "value 1",
            :top2 => "value 2",
            :root => HashWithIndifferentAccess.new(
              :foo => "foo",
              :bar => "bar",
              :baz => "baz"
            )
          )
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
          HashWithIndifferentAccess.new(
            :root => HashWithIndifferentAccess.new(
              :foo => HashWithIndifferentAccess.new(
                :a => 1,
                :b => 2,
                :c => 3
              ),
              :bar => "bar",
              :baz => "baz"
            )
          )
        end
      end

      instance = klass.new

      instance.clean_params[:root][:foo].should == {
        "a" => 1,
        "b" => 2
      }
    end

    it "handles only specifying top level params even with nested params" do
      klass = Class.new do
        include ParamsCleaner

        allowed_params :top_level

        def params
          HashWithIndifferentAccess.new(
            :top_level => 1,
            :nested => HashWithIndifferentAccess.new
          )
        end
      end

      instance = klass.new

      instance.clean_params[:top_level].should == 1
    end

    it "handles array params" do
      klass = Class.new do
        include ParamsCleaner

        allowed_params(
          :root => [:foo, :bar]
        )

        def params
          HashWithIndifferentAccess.new(
            :root => [
              HashWithIndifferentAccess.new(:foo => "foo1", :bar => "bar1", :baz => "baz1"),
              HashWithIndifferentAccess.new(:foo => "foo2", :bar => "bar2", :baz => "baz2")
            ]
          )
        end
      end

      instance = klass.new

      instance.clean_params[:root].should == [
        {"foo" => "foo1", "bar" => "bar1"},
        {"foo" => "foo2", "bar" => "bar2"}
      ]
    end
  end
end
