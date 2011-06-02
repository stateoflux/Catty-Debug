class UsersController < ApplicationController
  # Ensures that a user can only edit his own information
  before_filter :require_login, :only => [:edit, :update, :show]
  # Ensures that only an admin can list or delete users
  before_filter :admin?, :only => [:destroy, :index, :new, :create]

  def index
    logger.debug "response from admin? #{admin?}"
    @users = User.all
  end

  def new
    @user = User.new
    render 'new'
    # uses the session layout
    #render 'new', :layout => 'sessions'
  end

  def create
    #@user = User.new(params[:user])
    @user = User.new
    @user.first_name = params[:user]["first_name"].downcase
    @user.last_name = params[:user]["last_name"].downcase
    @user.email = params[:user]["email"].downcase
    @user.admin = params[:user]["admin"] == "true" ? true : false 

    if @user.save
      redirect_to assemblies_path, :notice => "User was successfully added" 
      #redirect_to users_path, :notice => "User was successfully added" 
      #redirect_to login_path, :notice => "You're In! Now just log in with the email id you just provided" 
    else
      render :action => "new", :layout => 'sessions', :notice => 'Are you sure you entered your information correctly? Please try again.'
      #redirect_to new_user_path, :alert => 'Are you sure you entered your information correctly? Please try again.'
    end
  end

  def show
    if params[:id] == current_user.id.to_s
      @user = current_user
      @r2d2_debugs = current_user.r2d2_debugs
      #@rework_requests = current_user.rework_requests
    elsif admin? 
      @user = User.find(params[:id]) 
      @r2d2_debugs = @user.r2d2_debugs 
      #@r2d2_debugs = R2d2Debug.all
      #@rework_requests = ReworkRequest.all
    end
    # needed a way to tell the r2d2_debug & rework requests views
    # that they were initiated from the user's home page.  This
    # way I can remove the "debug another" link
    # session[:from_user_page] = true
  end

  def edit
    if params[:id] == current_user.id.to_s
      @user = current_user 
    elsif admin? 
      @user = User.find(params[:id]) 
    end
  end

  def update
    if params[:id] == current_user.id.to_s
      logger.debug "User is updating their own data"
      @user = current_user
    elsif admin? 
      logger.debug "User is an admin"
      @user = User.find(params[:id])
    end
    # not sure why i need this additional return since the false clause of admin? method
    # has a return already.  Maybe returns just exit the current block and not the
    # entire method.
    return unless @user  

    if @user.update_attributes(params[:user])
      if current_user.admin
        redirect_to assemblies_path, :notice => 'User was successfully updated.'
        #redirect_to users_path, :notice => 'User was successfully updated.'
      else
        redirect_to @user, :notice => 'User was successfully updated.'
      end
    else
      render :action => "edit", :notice => 'User information did not update.'
    end
  end

  def destroy
    @user = User.find(params[:id])
    redirect_to assemblies_path, :notice => 
    #redirect_to users_path, :notice => 
    if @user.destroy 
      'User was successfully deleted.' 
    else
      'Uh oh! I was not able to delete this user.'
    end
  end
end
