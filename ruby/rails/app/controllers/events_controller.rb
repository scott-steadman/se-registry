class EventsController < ApplicationController

  before_filter :require_user

  helper_method :event_type, :index_path

  # GET /events
  # GET /events.xml
  def index
    @events = events.paginate(:page=>page, :per_page=>per_page)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml=>@events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = events.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml=>@event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = events.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml=>@event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = events.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    redirect_to index_path and return unless request.post?

    @event = events.new(params[:event], :as => role)

    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to index_path }
        format.xml  { render :xml=>@event, :status=>:created, :location=>@event }
      else
        format.html { render :action=>:new }
        format.xml  { render :xml=>@event.errors, :status=>:unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    redirect_to index_path and return unless request.put?

    @event = events.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event], :as => role)
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to index_path }
        format.xml  { head :ok }
      else
        format.html { render :action=>"edit" }
        format.xml  { render :xml=>@event.errors, :status=>:unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    redirect_to index_path and return unless request.delete?

    @event = events.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to index_path }
      format.xml  { head :ok }
    end
  end

private

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
