# == Schema Information
#
# Table name: givings
#
#  user_id :integer(4)      not null
#  gift_id :integer(4)      not null
#  intent  :string(4)       default("will"), not null
#

class Giving < ActiveRecord::Base
  belongs_to :user
  belongs_to :gift
end
