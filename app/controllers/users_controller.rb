class UsersController < ApplicationController
  before_action :set_user, only: [:edit,:update]
  def index
   @q = User.ransack(params[:q])
   @user = @q.result(distinct: true)
  end      
  
  def edit
  end
  
  def update
    if @user.update(set_params)
      redirect_to users_path, notice: "User #{@user.email} was sucessfully updated"
    else
      render :edit
    end
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])  
  end
  
  def set_params
    params.require(:user).permit({role_ids: []})  
  end
end

    