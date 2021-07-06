require "test_helper"

class Presence::DisappearJobTest < ActiveJob::TestCase

  test 'perform' do
    User::ForPresence.any_instance.expects(:disappear).once
    Presence::DisappearJob.perform_now(user)
  end

end # Presence::DisappearJobTest
