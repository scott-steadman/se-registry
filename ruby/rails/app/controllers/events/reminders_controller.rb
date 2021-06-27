class Events::RemindersController < EventsController

private

  def event_params
    params[:reminder]&.permit(:description, :date, :recur) || super
  end

  def events
    page_user.reminders
  end

  def index_path
    user_reminders_path(page_user)
  end

  def delete_path(event)
    user_reminder_path(page_user, event)
  end

  def event_type
    Reminder.name
  end

end # class Events::RemindersController
