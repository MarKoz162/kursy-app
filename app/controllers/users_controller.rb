class UsersController < ApplicationController
  def index
   @q = User.ransack(params[:q])
   @user = @q.result(distinct: true)
  end      
end

    