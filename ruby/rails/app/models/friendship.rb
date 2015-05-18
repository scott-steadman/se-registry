# == Schema Information
#
# Table name: friends
#
#  user_id   :integer(4)      not null
#  friend_id :integer(4)      not null
#

class Friendship < ActiveRecord::Base

  self.table_name = 'friends'

  belongs_to :user,   :class_name=>'User', :foreign_key=>'user_id'
  belongs_to :friend, :class_name=>'User', :foreign_key=>'friend_id'

  attr_accessor :login_or_email

  # pseudo id since this class is primaliry used in the context of a user
  def id
    friend_id
  end

  def login_or_email
    @login_or_email ||= friend ? friend.login : ''
  end

  # overridden because there is no id on this model
  def destroy
    Friendship.delete_all(['user_id=? and friend_id=?', user_id, friend_id])
  end

private

  validate :must_have_login, :on => :create
  def must_have_login
    errors.add(:login_or_email, 'cannot be blank.') if login_or_email.blank?
  end

  validate :friendship, :on => :create
  def friendship

    unless self.friend = User.find_by_login_or_email(login_or_email)
      errors[:base] << "'#{login_or_email}' not found."
      return
    end

    if user_id == friend_id
      errors[:base] << 'You cannot befriend yourself.'
      return
    end

    if Friendship.where(['user_id = ? and friend_id = ?', user.id, friend.id]).any?
      errors[:base] << "'#{login_or_email}' is already your friend."
      return
    end

  end

end
