class ReworkRequestsController < ApplicationController
  # Ensures that only an admin can index or destroy a
  # rework request 
  before_filter :admin?, :only => [:index, :destroy]
  # Ensures that a rework_request object cannot be created, destroyed or editted
  # unless the user has logged in
  # before_filter :authenticate, :except => [:index, :show]

  def index
    #if current_user.admin
      @rework_requests = ReworkRequest.all
    #end
  end

  def show
    # should i restrict user to only view their own sessions?
    @rework_request = ReworkRequest.find(params[:id])
  end

  def new
    @rework_request = ReworkRequest.new
  end

  def create
    @rework_request = current_user.rework_requests.new(params[:rework_request])
    @rework_request.r2d2_debug = current_user.r2d2_debugs.first

    if @rework_request.save
      render 'show', :notice => 'Rework request was successfully submitted.' 
    else
      render :action => "new"
    end
  end

=begin
  def edit
    @rework_request = current_user.rework_requests.find(params[:id]) 
  end

  def update
    @rework_request = current_user.rework_requests.find(params[:d]) 
    if @rework_request.update_attributes(params[:rework_request])
      redirect_to new_rework_request_path, :notice => 'Debug session was successfully updated.'
    else
      render :action => "edit"
    end
  end
=end

  def destroy
    @rework_request = current_user.rework_requests.find(params[:id])
    redirect_to rework_requests_path, :notice => 
      if @rework_request.destroy
       'Rework request was successfully deleted.'
      else 
       'Uh oh! Rework request was not deleted for some reason.'
      end
  end
end
