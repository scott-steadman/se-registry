class PresenceChannel < ApplicationCable::Channel

  def subscribed
    stream_for user

    Presence::AppearJob.perform_later(user);
  end

  def unsubscribed
    user.disappear
  end

private

  def user
    @user ||= current_user.becomes(User::ForPresence)
  end

end # PresenceChannel
