class UserSession < Authlogic::Session::Base
  authenticate_with User::ForAuthentication
end
