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
    @gift = gifts.new.tap do |gift|
      hidden = (page_user != current_user)
      gift.hidden    = hidden
      gift.tag_names = 'secret' if hidden
    end
  end

  # POST /gifts
  # POST /gifts.xml
  def create
    @gift = gifts.new(params[:gift], :as => role)

    render :action => :new and return unless request.post?

    current_user.give(@gift) if gift.hidden?

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
    gifts.destroy(gift) if request.delete?
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
      if current_user.admin? and page_user != current_user
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
      %{JOIN #{Tagging.table_name} ON
        (#{Tagging.table_name}.taggable_type = 'Gift' AND #{Tagging.table_name}.taggable_id = #{Gift.table_name}.id)
      },
      "JOIN #{Tag.table_name} on (#{Tag.table_name}.id = #{Tagging.table_name}.tag_id)"
    ] if params[:tag]
  end

  def per_page
    params[:per_page] || 20
  end

  def page_user
    @page_user ||= user_from_param || current_user
  end

  def user_from_param
    User.find_by_id(params[:user_id]) if params[:user_id]
  end

  def gifts
    if current_user == page_user
      page_user.visible_gifts
    else
      page_user.gifts
    end
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
