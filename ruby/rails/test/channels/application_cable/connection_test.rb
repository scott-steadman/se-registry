require "test_helper"

class ApplicationCable::ConnectionTest < ActionCable::Connection::TestCase

  test "connects with cookies" do
    connect :session => {ApplicationCable::Connection.session_key => user.id}

    assert_equal user, connection.current_user
  end

end # ApplicationCable::ConnectionTest
