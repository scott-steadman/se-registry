class GiftsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_action :require_user

  # GET /gifts
  # GET /gifts.xml
  def index
    @gifts = gifts
              .includes(:tags, :user, :givings)
              .joins(joins)
              .where(conditions)
              .order(order)
              .paginate(:page => page, :per_page => per_page)

    respond_to do |format|
      format.html # index.html.erb
      format.csv  { export }
    end
  end

  # GET /gifts/new
  def new
    @gift = gifts.new.becomes(Gift).tap do |gift|
      hidden = (page_user != current_user)
      gift.hidden    = hidden
      gift.tag_names = 'secret' if hidden
    end
  end

  # POST /gifts
  # POST /gifts.xml
  def create
    @gift = gifts.new(gift_params)

    render :action => :new and return unless request.post?

    @gift.save!

    current_user.give(@gift) if gift.hidden?

    redirect_to user_gifts_path(page_user)
  rescue StandardError => ex
    @gift = Gift.new
    @gift.errors.add(:base, ex.message)
    render :action => :new
  end

  # GET /gifts/1/edit
  def edit
  end

  # PATCH /gifts/1
  # PATCH /gifts/1.xml
  def update
    render :action => :edit and return unless request.patch?

    if gift.update(gift_params)
      flash[:notice] = 'Gift updated!'
      redirect_to user_gifts_path(page_user)
    else
      render :action => :edit
    end
  end

  # DELETE /gifts/1
  # DELETE /gifts/1.xml
  def destroy
    gifts.destroy(gift) if request.delete?
    redirect_to user_gifts_path(page_user)
  end

  # POST /gifts/:id/will
  def will
    current_user.give(gift) if request.post?
    redirect_to user_gifts_path(page_user)
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
    redirect_to user_gifts_path(page_user)
  end

private

  def gift_params
    params.require(:gift).permit(:description, :hidden, :multi, :price, :tag_names, :url, :urls)
  end

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

  helper_method :gift
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
