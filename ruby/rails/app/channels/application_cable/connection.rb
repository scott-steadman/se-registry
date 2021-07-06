module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_user
    end

    def self.session_key
      "user/for_authentication_credentials_id"
    end

  private

    def user_id
      request.session[self.class.session_key]
    end

    def find_user
      user = User.find_by(:id => user_id)

      user ? user : reject_unauthorized_connection
    end

  end # class Connection
end # module ActionCable

