class GiftsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_filter :require_user

  # GET /gifts
  # GET /gifts.xml
  def index
    @gifts = gifts.paginate :conditions=>conditions, :joins=>joins, :page=>page, :per_page=>per_page, :order=>order
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml=>@gifts }
      format.csv  { export }
    end
  end

  # GET /gifts/new
  def new
    @gift = Gift.new
  end

  # POST /gifts
  # POST /gifts.xml
  def create
    @gift = gifts.new(params[:gift], :as => role)
    render :action=>:new and return unless request.post?
    if @gift.save
      respond_to do |format|
        format.html { redirect_to user_gifts_path(page_user) }
        format.xml  { render :xml=>@gift, :status=>:created, :location=>@gift }
      end
    else
      render :action=>:new
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
    if gift.update_attributes(params[:gift], :as => role)
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
    current_user.give(gift) if request.post?
    respond_to do |format|
      format.html { redirect_to user_gifts_path(page_user) }
      format.xml  { head :ok }
    end
  end

  # DELETE /gifts/:id/wont
  def wont
    if request.delete?
      if current_user.admin? && page_user != current_user
        gift.givings.clear
      else
        current_user.givings.delete(gift)
      end
    end
    respond_to do |format|
      format.html { redirect_to user_gifts_path(page_user) }
      format.xml  { head :ok }
    end
  end

private

  def conditions
    conditions, values = tag_conditions
    [conditions, *values] if conditions
  end

  def tag_conditions
    ['tags.name IN (?)', params[:tag]] if params[:tag]
  end


  def joins
    [
      "JOIN #{GiftTag.table_name} on (#{GiftTag.table_name}.gift_id = #{Gift.table_name}.id)",
      "JOIN #{Tag.table_name} on (#{Tag.table_name}.id = #{GiftTag.table_name}.tag_id)"
    ] if params[:tag]
  end

  def per_page
    params[:per_page] || 20
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

  helper_method :order
  def order
    params[:order] || 'description ASC'
  end

  def export
    require 'csv'
    data = CSV.generate(:row_sep => "\r\n") do |csv|
      csv << ['Tags','Description','Multiples','Price', 'Giver']
      page_user.gifts.each do |gift|
        csv << [
          gift.tag_names,
          gift.description,
          gift.multi,
          number_to_currency(gift.price),
          gift.givings.map {|ii| ii.display_name}.join(' & ')
        ]
      end
    end
    send_data(data, {:filename => 'gifts.csv', :type => 'text/csv', :disposition => 'inline'})
  end

end
