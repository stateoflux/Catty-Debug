class AssembliesController < ApplicationController
  # Ensures that only an admin can manipulate assembly objects 
  before_filter :admin?

  # GET /assemblies
  def index
    @assemblies = Assembly.all

    # I couldn't figure out a way to render the users index view from within
    # the assembly index view such that the user index view is appended to
    # the assembly index view.  I'm just going to append the user index view
    # erb to the assembly index erb...ugly hack :(
    @users = User.all
    @r2d2_debugs = R2d2Debug.first_ten
  end

  # GET /assemblies/1
  def show
    @assembly = Assembly.find(params[:id])
    # what happens if assembly is not found?
  end

  # GET /assemblies/new
  def new
    @assembly = Assembly.new
  end

  # GET /assemblies/1/edit
  def edit
    @assembly = Assembly.find(params[:id])
    # what happens if assembly is not found?
  end

  # POST /assemblies
  def create
    @assembly = Assembly.new(params[:assembly])

    # Remove any extra R2D2 objects...this is a hack for now
    @assembly.r2d2s = @assembly.r2d2s.shift(@assembly.num_of_r2d2s)

    @assembly.r2d2s.each_with_index do |r2d2, i|
      r2d2.update_attributes(:instance => i)
      r2d2.rx_memories.each_with_index do |rx_mem, j|
        rx_mem.update_attributes(:instance => j)
      end
      r2d2.tx_memories.each_with_index do |tx_mem, j|
        tx_mem.update_attributes(:instance => j)
      end
    end

    if @assembly.save
      redirect_to(assemblies_path, :notice => 'Assembly was successfully created.')
      # redirect_to(@assembly,.. is a shortcut for redirect_to(assembly_path(:id => @assembly)
      #redirect_to(@assembly, :notice => 'Assembly was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /assemblies/1
  def update
    @assembly = Assembly.find(params[:id])

    if @assembly.update_attributes(params[:assembly])
      redirect_to(assemblies_path, :notice => 'Assembly was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /assemblies/1
  def destroy
    @assembly = Assembly.find(params[:id])
    @assembly.destroy
    redirect_to(assemblies_url)
  end
end
