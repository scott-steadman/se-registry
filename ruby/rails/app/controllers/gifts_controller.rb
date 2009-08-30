class GiftsController < ApplicationController

  before_filter :require_user

  # GET /gifts
  # GET /gifts.xml
  def index
    @gifts = gifts.paginate :page=>page, :per_page=>per_page, :order=>order
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml=>@gifts }
    end
  end

  # GET /gifts/new
  def new
    @gift = Gift.new
  end

  # POST /gifts
  # POST /gifts.xml
  def create
    @gift = gifts.new(params[:gift])
    render :action=>:new and return unless request.post?
    @gift.save
    respond_to do |format|
      format.html { redirect_to user_gifts_path(page_user) }
      format.xml  { render :xml=>@gift, :status=>:created, :location=>@gift }
    end
  end

  # GET /gifts/1/edit
  def edit
    @gift = gift
  end

  # PUT /gifts/1
  # PUT /gifts/1.xml
  def update
    gift
    render :action=>:edit and return unless request.put?
    # work-around bug in acts_as_taggable
    gift.tags.clear
    if gift.update_attributes(params[:gift])
      flash[:notice] = 'Gift updated!'
      respond_to do |format|
        format.html { redirect_to user_gifts_path(page_user) }
        format.xml  { render :xml=>gift, :status=>:created, :location=>gift }
      end
    else
      render :action => :edit
    end
  end

  # DELETE /gifts/1
  # DELETE /gifts/1.xml
  def destroy
    gifts.delete(gift) if request.delete?
    respond_to do |format|
      format.html { redirect_to user_gifts_path(page_user) }
      format.xml  { head :ok }
    end
  end

  # POST /gifts/:id/will
  def will
    current_user.givings << gift if request.post?
    respond_to do |format|
      format.html { redirect_to user_gifts_path(page_user) }
      format.xml  { head :ok }
    end
  end

  # DELETE /gifts/:id/wont
  def wont
    current_user.givings.delete(gift) if request.delete?
    respond_to do |format|
      format.html { redirect_to user_gifts_path(page_user) }
      format.xml  { head :ok }
    end
  end


private

  def per_page
    20
  end

  def page_user
    @page_user ||= User.find_by_id(params[:user_id]) || current_user
  end

  def gifts
    page_user.gifts
  end

  def gift
    @gift ||= gifts.find(gift_id)
  end

  def gift_id
    params[:gift_id] || params[:id]
  end

  def order
    'description'
  end

end
