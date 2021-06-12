class Events::OccasionsController < EventsController

private

  def event_params
    params[:occasion]&.permit(:description, :date, :recur) || super
  end

  def events
    page_user.occasions
  end

  def index_path
    user_occasions_path(page_user)
  end

  def delete_path(event)
    user_occasion_path(page_user, event)
  end

end # class Events::OccasionsController
