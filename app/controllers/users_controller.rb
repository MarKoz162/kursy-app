class UsersController < ApplicationController
  def index
    @user = User.all.order(created_at: :desc)
  end      
end

    