class TxMemoriesController < ApplicationController
  # GET /tx_memories
  # GET /tx_memories.xml
  def index
    @tx_memories = TxMemory.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tx_memories }
    end
  end

  # GET /tx_memories/1
  # GET /tx_memories/1.xml
  def show
    @tx_memory = TxMemory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tx_memory }
    end
  end

  # GET /tx_memories/new
  # GET /tx_memories/new.xml
  def new
    @tx_memory = TxMemory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tx_memory }
    end
  end

  # GET /tx_memories/1/edit
  def edit
    @tx_memory = TxMemory.find(params[:id])
  end

  # POST /tx_memories
  # POST /tx_memories.xml
  def create
    @tx_memory = TxMemory.new(params[:tx_memory])

    respond_to do |format|
      if @tx_memory.save
        format.html { redirect_to(@tx_memory, :notice => 'Tx memory was successfully created.') }
        format.xml  { render :xml => @tx_memory, :status => :created, :location => @tx_memory }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tx_memory.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tx_memories/1
  # PUT /tx_memories/1.xml
  def update
    @tx_memory = TxMemory.find(params[:id])

    respond_to do |format|
      if @tx_memory.update_attributes(params[:tx_memory])
        format.html { redirect_to(@tx_memory, :notice => 'Tx memory was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tx_memory.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tx_memories/1
  # DELETE /tx_memories/1.xml
  def destroy
    @tx_memory = TxMemory.find(params[:id])
    @tx_memory.destroy

    respond_to do |format|
      format.html { redirect_to(tx_memories_url) }
      format.xml  { head :ok }
    end
  end
end
