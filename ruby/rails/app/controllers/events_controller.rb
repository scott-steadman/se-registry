class EventsController < ApplicationController

  before_action :require_user

  helper_method :event_type, :index_path

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
    redirect_to index_path and return unless request.post?

    @event = events.create!(event_params)

    flash[:notice] = 'Event was successfully created.'
    redirect_to index_path

  rescue StandardError => ex
    @event = events.new
    @event.errors.add(:base, ex.message)
    render :action=>:new
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    redirect_to index_path and return unless request.put?

    @event = events.find(params[:id])

    if @event.update(event_params)
      flash[:notice] = 'Event was successfully updated.'
      redirect_to index_path
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

  def event_params
    params.require(:event).permit(:description, :event_date, :recur)
  end

  def events
    if request.path =~ /occasion/
      page_user.occasions
    elsif request.path =~ /reminder/
      page_user.reminders
    else
      page_user.events
    end
  end

  def event_type
    if request.path =~ /occasion/
      Occasion.name
    elsif request.path =~ /reminder/
      Reminder.name
    else
      Event.name
    end
  end

  def index_path
    eval "user_#{event_type.downcase}s_path(page_user)"
  end

end
