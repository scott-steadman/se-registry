module EventsHelper

  def new_event_links
    links = []
    case event_type
      when Occasion.name
        links << link_to('New', new_user_occasion_path(page_user))
      when Reminder.name
        links << link_to('New', new_user_reminder_path(page_user))
      else
        links << link_to('New Occasion', new_user_occasion_path(page_user))
        links << link_to('New Reminder', new_user_reminder_path(page_user))
    end
    links.join('|')
  end

  def event_actions(event, user=page_user)
    case event_type
      when Occasion.name
        edit_path   = edit_user_occasion_path(user, event)
        delete_path = user_occasion_path(user, event)
      when Reminder.name
        edit_path   = edit_user_reminder_path(user, event)
        delete_path = user_reminder_path(user, event)
      else
        edit_path   = edit_user_event_path(user, event)
        delete_path = user_event_path(user, event)
    end
    links = []
    links << link_to('Edit', edit_path)
    links << link_to('Delete', delete_path, :confirm=>'Are you sure?', :method=>:delete)
    links.join('|')
  end

  def user_event_path(user, event)
    case event_type
      when Occasion.name
        user_occasion_path(user, event)
      when Reminder.name
        user_reminder_path(user, event)
      else
        super(user, event)
    end
  end
end
