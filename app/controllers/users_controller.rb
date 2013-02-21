class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]

  def test
    @info = @client.user_info
  end
end
