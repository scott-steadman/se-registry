# == Schema Information
#
# Table name: givings
#
#  user_id    :integer          not null
#  gift_id    :integer          not null
#  intent     :string(4)        default("will"), not null
#  created_at :datetime
#  updated_at :datetime
#

class Giving < ActiveRecord::Base
  belongs_to :user
  belongs_to :gift
end
