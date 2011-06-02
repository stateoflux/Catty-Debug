class SessionsController < ApplicationController

  def create
    if user = User.authenticate(params[:email])
      session[:user_id] = user.id
      redirect_to user_path(user.id)
    else
      flash.now[:alert] = "You must be a new user. Please request access from the Admin."
      render :action => 'new'
    end
  end

  def destroy
    reset_session
    redirect_to root_path, :notice => "You have successfully logged out"
  end
end
