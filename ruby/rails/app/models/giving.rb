# == Schema Information
#
# Table name: givings
#
#  user_id :bigint
#  gift_id :bigint
#  intent  :string           default("will"), not null
#

class Giving < ActiveRecord::Base
  belongs_to :user
  belongs_to :gift
end
