class AssembliesController < ApplicationController
  # Ensures that only an admin can delete users
  before_filter :admin?

  # GET /assemblies
  def index
    @assemblies = Assembly.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assemblies }
    end
  end

  # GET /assemblies/1
  def show
    @assembly = Assembly.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @assembly }
    end
  end

  # GET /assemblies/new
  def new
    @assembly = Assembly.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @assembly }
    end
  end

  # GET /assemblies/1/edit
  def edit
    @assembly = Assembly.find(params[:id])
  end

  # POST /assemblies
  def create
    @assembly = Assembly.new(params[:assembly])

    # Remove any extra R2D2 objects...this is a hack for now
    @assembly.r2d2s = @assembly.r2d2s.shift(@assembly.num_of_r2d2s)
    
   #logger.debug "Number of R2D2s: #{@assembly.r2d2s.size}"
    @assembly.r2d2s.each_with_index do |r2d2, i|
      r2d2.update_attributes(:instance => i)
      r2d2.rx_memories.each_with_index do |rx_mem, j|
        rx_mem.update_attributes(:instance => j)
      end
      r2d2.tx_memories.each_with_index do |tx_mem, j|
        tx_mem.update_attributes(:instance => j)
      end
    end

    # Build proper_name attribute
    @assembly.proper_name = params[:assembly]["project_name"] + " rev" + params[:assembly]["revision"]
    
    respond_to do |format|
      if @assembly.save
        # redirect_to(@assembly,.. is a shortcut for redirect_to(assembly_path(:id => @assembly)
        format.html { redirect_to(@assembly, :notice => 'Assembly was successfully created.') }
        format.xml  { render :xml => @assembly, :status => :created, :location => @assembly }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @assembly.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /assemblies/1
  def update
    @assembly = Assembly.find(params[:id])

    respond_to do |format|
      if @assembly.update_attributes(params[:assembly])
        format.html { redirect_to(@assembly, :notice => 'Assembly was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @assembly.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assemblies/1
  def destroy
    @assembly = Assembly.find(params[:id])
    @assembly.destroy

    respond_to do |format|
      format.html { redirect_to(assemblies_url) }
      format.xml  { head :ok }
    end
  end
end
