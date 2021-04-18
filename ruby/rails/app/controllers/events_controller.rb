class EventsController < ApplicationController

  before_action :require_user

  # GET /events
  # GET /events.xml
  def index
    @events = events.paginate(:page=>page, :per_page=>per_page)
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = events.find(params[:id])
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = events.new
  end

  # GET /events/1/edit
  def edit
    @event = events.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    redirect_to user_events_path(page_user) and return unless request.post?

    @event = events.create!(event_params)

    flash[:notice] = 'Event was successfully created.'
    redirect_to user_events_path(page_user)

  rescue StandardError => ex
    @event = events.new
    @event.errors.add(:base, ex.message)
    render :action=>:new
  end

  # PATCH /events/1
  # PATCH /events/1.xml
  def update
    redirect_to user_events_path(page_user) and return unless request.patch?

    @event = events.find(params[:id])

    if @event.update(event_params)
      flash[:notice] = 'Event was successfully updated.'
      redirect_to user_events_path(page_user)
    else
      render :action => 'edit'
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    redirect_to user_events_path(page_user) and return unless request.delete?

    @event = events.find(params[:id])
    @event.destroy

    redirect_to user_events_path(page_user)
  end

private

  def event_params
    params.require(:event).permit(:description, :date, :recur)
  end

  def events
    page_user.events
  end

end
