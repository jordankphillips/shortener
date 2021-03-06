class LinksController < ApplicationController
  before_filter :indecisive, :only => [:go] # Evaluate "indecisive" before "go" block
  
  # GET /links
  # GET /links.json
  def index
    @links = Link.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @links }
    end
  end

  # GET /links/1
  # GET /links/1.json
  def show
    @link = Link.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @link }
    end
  end

  # GET /links/new
  # GET /links/new.json
  def new
    @link = Link.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @link }
    end
  end

  # GET /links/1/edit
#  def edit
#    @link = Link.find(params[:id])
#  end

  # POST /links
  # POST /links.json
  def create
    @link = Link.new(params[:link])
    silly = false
    respond_to do |format|
      if @link.save && !(silly = @link.silly_length?(url_for(:root)))
        format.html { redirect_to @link, notice: 'Link was successfully created.' }
        format.json { render json: @link, status: :created, location: @link }
      else
        @silly = silly
        format.html { render action: "new" }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /links/1
  # PUT /links/1.json
  def update
    @link = Link.find(params[:id])

    respond_to do |format|
      if @link.update_attributes(params[:link])
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link = Link.find(params[:id])
    @link.destroy

    respond_to do |format|
      format.html { redirect_to links_url }
      format.json { head :no_content }
    end
  end


      # check length of original URL
        #if original length < shortened length, confirm we want to continue

  def go  
    @link.visit_count = @link.visit_count + 1
    @link.save
    redirect_to @link.original_url, :status => @link.http_status
  end

  def indecisive
    @link = Link.find_by_id(params[:id]) || Link.find_by_short_path(params[:short_path])
  end


end