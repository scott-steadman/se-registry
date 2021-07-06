class Presence::AppearJob < ApplicationJob
  queue_as :default

  def perform(user)
    user.becomes(User::ForPresence).appear
  end
end
