class Events::OccasionsController < ApplicationController

  before_action :require_user

  # GET /occasions
  # GET /occasions.xml
  def index
    @occasions = occasions.paginate(:page => page, :per_page => per_page)
  end

  # GET /occasions/1
  # GET /occasions/1.xml
  def show
    @occasion = occasions.find(params[:id])
  end

  # GET /occasions/new
  # GET /occasions/new.xml
  def new
    @occasion = occasions.new
  end

  # GET /occasions/1/edit
  def edit
    @occasion = occasions.find(params[:id])
  end

  # POST /occasions
  # POST /occasions.xml
  def create
    redirect_to user_occasions_path(page_user) and return unless request.post?

    @occasion = occasions.create!(occasion_params)

    flash[:notice] = 'Event was successfully created.'
    redirect_to user_occasions_path(page_user)

  rescue StandardError => ex
    @occasion = occasions.new
    @occasion.errors.add(:base, ex.message)
    render :action => :new
  end

  # PATCH /occasions/1
  # PATCH /occasions/1.xml
  def update
    redirect_to user_occasions_path(page_user) and return unless request.patch?

    @occasion = occasions.find(params[:id])

    if @occasion.update(occasion_params)
      flash[:notice] = 'Event was successfully updated.'
      redirect_to user_occasions_path(page_user)
    else
      render :action => 'edit'
    end
  end

  # DELETE /occasions/1
  # DELETE /occasions/1.xml
  def destroy
    redirect_to user_occasions_path(page_user) and return unless request.delete?

    @occasion = occasions.find(params[:id])
    @occasion.destroy

    redirect_to user_occasions_path(page_user)
  end

private

  def occasion_params
    params.require(:occasion).permit(:description, :date, :recur)
  end

  def occasions
    page_user.occasions
  end

end
