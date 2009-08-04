class UserSession < Authlogic::Session::Base
  include Authlogic::Session::MagicColumns
end
