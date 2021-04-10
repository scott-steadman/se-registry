# == Schema Information
#
# Table name: users
#
#  id                :bigint           not null, primary key
#  login             :string           not null
#  role              :string           default("user"), not null
#  notes             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  email             :string
#  crypted_password  :string           not null
#  password_salt     :string           not null
#  persistence_token :string
#  current_login_at  :datetime
#  last_login_at     :datetime
#  lead_time         :integer          default(10)
#  lead_frequency    :integer          default(10)
#
class User::ForAuthentication < User

  class OldCrypto
    def self.encrypt(password, salt=nil)
      require 'digest/sha1'
      Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    end

    def self.matches?(crypted_password, password, salt=nil)
      encrypt(password, salt) == crypted_password
    end
  end

  acts_as_authentic do |config|
    config.transition_from_crypto_providers = OldCrypto
  end

  # Validate email, login, and password as you see fit.
  #
  # Authlogic < 5 added these validation for you, making them a little awkward
  # to change. In 4.4.0, those automatic validations were deprecated. See
  # https://github.com/binarylogic/authlogic/blob/master/doc/use_normal_rails_validation.md
  validates :email,
    format: {
      with: /@/,
      message: "should look like an email address."
    },
    length: { within: 3..100 },
    uniqueness: {
      case_sensitive: false,
      if: :will_save_change_to_email?
    }

  validates :login,
    format: {
      with: /\A[a-z0-9_]+\z/i,
      message: "should use only letters and numbers."
    },
    length: { within: 3..40 },
    uniqueness: {
      case_sensitive: false,
      if: :will_save_change_to_login?
    }

  validates :password,
    confirmation: { if: :require_password? },
    length: {
      minimum: 5,
      if: :require_password?
    }
  validates :password_confirmation,
    length: {
      minimum: 5,
      if: :require_password?
  }

end # class User::ForAuthentication
