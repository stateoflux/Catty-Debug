class R2d2DebugsController < ApplicationController
  # Ensures that only an admin can destroy a
  # r2d2 debug session
  before_filter :admin?, :only => [:index, :destroy]
  # Ensures that a r2d2_debug object cannot be created, destroyed or editted
  # unless the user has logged in
  # before_filter :authenticate, :except => [:index, :show]

  def index
    if current_user.admin
      @r2d2_debugs = R2d2Debug.all
    else
      @r2d2_debugs = current_user.r2d2_debugs
      #redirect_to 
    end
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
        @r2d2_debug.extract_and_set_attr params[:test_result]

        # Baseboards only have 4 R2D2s, therefore redirect to new and display error if
        # r2d2 device number is greater than 4
        if @r2d2_debug.r2d2_instance.to_i > 3 && @r2d2_debug.assembly.project_name != "Senga"
          wrong_board = true
        elsif @r2d2_debug.assembly.project_name == 'Senga'
          @r2d2_debug.r2d2_instance -= 4  # normalize the r2d2 device number
        end

        unless wrong_board
          if @r2d2_debug.save
            @just_created = true
            @data_read_dump = @r2d2_debug.generate_data_read
            render 'show_results', :notice => 'Debug session was successfully created.' 
          else
            render 'new'
          end
        else
           flash.now[:alert] = 'The R2D2 instance is greater than 4, you should select the Senga board'
           render 'new' 
        end
      else
        flash.now[:alert] = 'Did you forget to paste your packet buffer test result?'
        render 'new' 
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

  def destroy
    @r2d2_debug = current_user.r2d2_debugs.find(params[:id])
    redirect_to r2d2_debugs_path, :notice => 
      if @r2d2_debug.destroy
       'Debug session was successfully deleted.'
      else 
       'Uh oh! Debug session was not deleted for some reason.'
      end
  end
end
