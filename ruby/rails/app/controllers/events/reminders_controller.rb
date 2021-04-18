class Events::RemindersController < ApplicationController

  before_action :require_user

  # GET /reminders
  # GET /reminders.xml
  def index
    @reminders = reminders.paginate(:page => page, :per_page => per_page)
  end

  # GET /reminders/1
  # GET /reminders/1.xml
  def show
    @reminder = reminders.find(params[:id])
  end

  # GET /reminders/new
  # GET /reminders/new.xml
  def new
    @reminder = reminders.new
  end

  # GET /reminders/1/edit
  def edit
    @reminder = reminders.find(params[:id])
  end

  # POST /reminders
  # POST /reminders.xml
  def create
    redirect_to user_reminders_path(page_user) and return unless request.post?

    @reminder = reminders.create!(reminder_params)

    flash[:notice] = 'Event was successfully created.'
    redirect_to user_reminders_path(page_user)

  rescue StandardError => ex
    @reminder = reminders.new
    @reminder.errors.add(:base, ex.message)
    render :action => :new
  end

  # PATCH /reminders/1
  # PATCH /reminders/1.xml
  def update
    redirect_to user_reminders_path(page_user) and return unless request.patch?

    @reminder = reminders.find(params[:id])

    if @reminder.update(reminder_params)
      flash[:notice] = 'Event was successfully updated.'
      redirect_to user_reminders_path(page_user)
    else
      render :action => 'edit'
    end
  end

  # DELETE /reminders/1
  # DELETE /reminders/1.xml
  def destroy
    redirect_to user_reminders_path(page_user) and return unless request.delete?

    @reminder = reminders.find(params[:id])
    @reminder.destroy

    redirect_to user_reminders_path(page_user)
  end

private

  def reminder_params
    params.require(:reminder).permit(:description, :date, :recur)
  end

  def reminders
    page_user.reminders
  end

end
