class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      self.current_user = @user
      redirect_to user_cities_url(@user)
    else
      render 'new'
    end  
  end
  
end
