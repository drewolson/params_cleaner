Params Cleaner
===========================

[![Travis CI Status](http://travis-ci.org/drewolson/params_cleaner.png)](http://travis-ci.org/drewolson/params_cleaner)

# Usage

Params cleaner allows you to protect your Rails application from mass assignment attacks at the controller level.
In any controller, simply mix in the ParamsCleaner module and specify which sub-keys are allowed for a given
root key. Then, access your params using the clean_params method.

```ruby
class PlayersController < ApplicationController
  include ParamsCleaner

  allowed_params :player => [:name, :email]

  def create
    @player = Player.new(clean_params[:player])

    if @player.save
      redirect_to player_path(@player)
    else
      render :new
    end
  end
end
```

The root keys specified will be checked on every level of the params hash, so you can easily protect deeply nested
params hashes as well. For example, assume the following allowed_params declaration:

```ruby
  allowed_params :player => [:name, :email]
                 :name => [:first, :last]
```

Now, assume the following params hash:

```ruby
{
  :player => {
    :email => "drew@drewolson.org"
    :bad_key => "nefarious stuff",
    :name => {
      :first => "Drew",
      :last => "Olson",
      :nested_bad_key => "more nefarious stuff"
    }
  }
}
```

Here's what you'd see when calling the clean_params method:

```ruby
clean_params[:player]
# => {:email => "drew@drewolson.org", :name => {:first => "Drew", :last => "Olson"}}

clean_params[:player][:name]
# => {:first => "Drew", :last => "Olson"}
```

ParamsCleaner also supports validating top-level params.

```ruby
  allowed_params(
    :game_id,
    :player => [:name, :email]
  )
```

Now, assume the following params hash:

```ruby
{
  :game_id => "id",
  :rating_id => "id",
  :player => {
    :email => "drew@drewolson.org"
    :bad_key => "nefarious stuff",
    :name => "Drew Olson"
  }
}
```

Here's what you'd see when calling the clean_params method:

```ruby
clean_params
# => {:game_id => "id", :player => {:email => "drew@drewolson.org", :name => "Drew Olson"}}
```

You can even specify valid params for a given action:

```ruby
  allowed_params_for :create, :player => [:name, :email]
  allowed_params_for :update, :player => [:name]
```
