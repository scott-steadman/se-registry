require "test_helper"

class Presence::AppearJobTest < ActiveJob::TestCase

  test 'perform' do
    User::ForPresence.any_instance.expects(:appear).once
    Presence::AppearJob.perform_now(user)
  end

end # class Presence::AppearJobTest
