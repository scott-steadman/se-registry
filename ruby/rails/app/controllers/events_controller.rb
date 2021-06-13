class EventsController < ApplicationController

  before_action :require_user

  # GET /events
  # GET /events.xml
  def index
    @events = events.paginate(:page => page, :per_page => per_page)
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = events.find(params[:id])
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = build_event
  end

  # GET /events/1/edit
  def edit
    @event   = events.find(params[:id])
    @event ||= build_event
  end

  # POST /events
  # POST /events.xml
  def create
    redirect_to index_path and return unless request.post?

    @event = build_event

    if @event.save
      flash[:notice] = 'Event was successfully created.'
      redirect_to index_path
    else
      render :action => :new
    end
  end

  # PATCH /events/1
  # PATCH /events/1.xml
  def update
    redirect_to index_path and return unless request.patch?

    @event = events.find(params[:id])

    if @event.update(event_params)
      flash[:notice] = 'Event was successfully updated.'

      if request.xhr?
        render :action => :show
      else
        redirect_to index_path
      end
    else
      render :action => 'edit'
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    redirect_to index_path and return unless request.delete?

    @event = events.find(params[:id])
    @event.destroy

    redirect_to index_path
  end

private

  def events
    page_user.events
  end

  def event_params
    params[:event]&.permit(:description, :date, :recur) || {}
  end

  def build_event
    events.new(event_params)
  end

  def index_path
    user_events_path(page_user)
  end

  helper_method :delete_path
  def delete_path(event)
    user_event_path(page_user, event)
  end

end # class EventsController
