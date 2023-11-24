require "test_helper"

module ApplicationCable
  class ConnectionTest < ActionCable::Connection::TestCase

    test "connects with cookies" do
      connect :session => {ApplicationCable::Connection.session_key => user.id}

      assert_equal user, connection.current_user
    end

  end # class ConnectionTest
end # module ApplicationCable
