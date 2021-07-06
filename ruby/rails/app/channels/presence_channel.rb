class PresenceChannel < ApplicationCable::Channel

  def subscribed
    stream_for user

    user.appear
  end

  def unsubscribed
    user.disappear
  end

private

  def user
    @user ||= current_user.becomes(User::ForPresence)
  end

end # PresenceChannel
