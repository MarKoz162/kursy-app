class UsersController < ApplicationController
  before_action :set_user, only: [:edit,:update,:show]
  def index
   @q = User.ransack(params[:q])
   @user = @q.result(distinct: true)
   authorize @user
  end      
  
  def edit
    authorize @user
  end
  
  def show
    
  end  
  
  def update
    authorize @user
    if @user.update(set_params)
      redirect_to users_path, notice: "User #{@user.email} was sucessfully updated"
    else
      render :edit
    end
  end
  
  private
  
  def set_user
    @user = User.friendly.find(params[:id])  
  end
  
  def set_params
    params.require(:user).permit({role_ids: []})  
  end
end

    