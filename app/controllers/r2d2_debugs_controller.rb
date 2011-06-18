class R2d2DebugsController < ApplicationController
  # Ensures that a r2d2_debug object cannot be created, destroyed or editted
  # unless the user has logged in
  before_filter :require_login
  # Ensures that only an admin can destroy a
  # r2d2 debug session or access a listing
  before_filter :admin?, :only => [:index, :destroy]

  def index
    #if current_user.admin
      @r2d2_debugs = R2d2Debug.all
    #end
  end

  def show
    # should i restrict user to only view their own sessions?
    @r2d2_debug = R2d2Debug.find(params[:id])
    render 'show_results'
  end

  def new
    @r2d2_debug = R2d2Debug.new
  end

  def create
    @r2d2_debug = current_user.r2d2_debugs.new(params[:r2d2_debug])
    unless params[:test_result] == ""
      if (@r2d2_debug.extract_and_set_attr params[:test_result])
        if @r2d2_debug.save
          logger.debug "r2d2_debug was written to db"
          @just_created = true
          session[:debug_id] = @r2d2_debug.id;
          respond_to do |format|
            format.html { render 'show_results', :notice => 'Debug session was successfully created.' }
            format.js
          end
        else
          logger.debug "r2d2_debug write operation failed"
          logger.debug "errors: #{@r2d2_debug.errors}"
          flash.now[:alert] = "Something is wrong"
          respond_to do |format|
            format.html { render 'new' }
            format.js { render 'create_fail'}
          end
        end
      else
        flash.now[:alert] = @r2d2_debug.validation_error 
        respond_to do |format|
          format.html { render 'new' }
          format.js { render 'create_fail'}
        end
      end
    else
      flash.now[:alert] = 'Did you forget to paste your packet buffer test result?'
      respond_to do |format|
        format.html { render 'new' }
        format.js { render 'create_fail'}
      end
    end
  end

  def destroy
    @r2d2_debug = R2d2Debug.find(params[:id])
    redirect_to assemblies_path, :notice => 
      if @r2d2_debug.destroy
       'Debug session was successfully deleted.'
      else 
       'Uh oh! Debug session was not deleted for some reason.'
      end
  end

=begin
  def edit
    @r2d2_debug = current_user.r2d2_debugs.find(params[:id]) 
  end

  def update
    @r2d2_debug = current_user.r2d2_debugs.find(params[:d]) 
    if @r2d2_debug.update_attributes(params[:r2d2_debug])
      redirect_to new_r2d2_debug_path, :notice => 'Debug session was successfully updated.'
    else
      render :action => "edit"
    end
  end
=end
end
