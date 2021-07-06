class Presence::DisappearJob < ApplicationJob
  queue_as :default

  def perform(user)
    user.becomes(User::ForPresence).disappear
  end
end
