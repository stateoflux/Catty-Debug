class R2d2sController < ApplicationController
  # GET /r2d2s
  # GET /r2d2s.xml
  def index
    @r2d2s = R2d2.all

    respond_to do |format|
     format.html # index.html.erb
      format.xml  { render :xml => @r2d2s }
    end
  end

  # GET /r2d2s/1
  # GET /r2d2s/1.xml
  def show
    @r2d2 = R2d2.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @r2d2 }
    end
  end

  # GET /r2d2s/new
  # GET /r2d2s/new.xml
  def new
    @r2d2 = R2d2.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @r2d2 }
    end
  end

  # GET /r2d2s/1/edit
  def edit
    @r2d2 = R2d2.find(params[:id])
  end

  # POST /r2d2s
  # POST /r2d2s.xml
  def create
    @r2d2 = R2d2.new(params[:r2d2])

    respond_to do |format|
      if @r2d2.save
        format.html { redirect_to(@r2d2, :notice => 'R2d2 was successfully created.') }
        format.xml  { render :xml => @r2d2, :status => :created, :location => @r2d2 }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @r2d2.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /r2d2s/1
  # PUT /r2d2s/1.xml
  def update
    @r2d2 = R2d2.find(params[:id])

    respond_to do |format|
      if @r2d2.update_attributes(params[:r2d2])
        format.html { redirect_to(@r2d2, :notice => 'R2d2 was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @r2d2.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /r2d2s/1
  # DELETE /r2d2s/1.xml
  def destroy
    @r2d2 = R2d2.find(params[:id])
    @r2d2.destroy

    respond_to do |format|
      format.html { redirect_to(r2d2s_url) }
      format.xml  { head :ok }
    end
  end

  # Not sure if I need this method
  #private
  # def load_assembly
  #    @assembly = Assembly.find(params[:assembly_id])
  #  end
end
