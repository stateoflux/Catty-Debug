class RxMemoriesController < ApplicationController
  # GET /rx_memories
  # GET /rx_memories.xml
  def index
    @rx_memories = RxMemory.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rx_memories }
    end
  end

  # GET /rx_memories/1
  # GET /rx_memories/1.xml
  def show
    @rx_memory = RxMemory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rx_memory }
    end
  end

  # GET /rx_memories/new
  # GET /rx_memories/new.xml
  def new
    @rx_memory = RxMemory.new

   respond_to do |format|
     format.html # new.html.erb
      format.xml  { render :xml => @rx_memory }
    end
  end

  # GET /rx_memories/1/edit
  def edit
    @rx_memory = RxMemory.find(params[:id])
  end

  # POST /rx_memories
  # POST /rx_memories.xml
  def create
    @rx_memory = RxMemory.new(params[:rx_memory])

    respond_to do |format|
      if @rx_memory.save
        format.html { redirect_to(@rx_memory, :notice => 'Rx memory was successfully created.') }
        format.xml  { render :xml => @rx_memory, :status => :created, :location => @rx_memory }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rx_memory.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rx_memories/1
  # PUT /rx_memories/1.xml
  def update
    @rx_memory = RxMemory.find(params[:id])

    respond_to do |format|
      if @rx_memory.update_attributes(params[:rx_memory])
        format.html { redirect_to(@rx_memory, :notice => 'Rx memory was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rx_memory.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rx_memories/1
  # DELETE /rx_memories/1.xml
  def destroy
    @rx_memory = RxMemory.find(params[:id])
    @rx_memory.destroy

    respond_to do |format|
      format.html { redirect_to(rx_memories_url) }
      format.xml  { head :ok }
    end
  end
end
