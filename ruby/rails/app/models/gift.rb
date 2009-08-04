# == Schema Information
#
# Table name: gifts
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)      not null
#  description :string(256)     default(""), not null
#  url         :string(256)
#  price       :integer(10)
#  multi       :boolean(1)
#

class Gift < ActiveRecord::Base

  attr_accessible :description, :url, :multi, :price

  belongs_to :user

  acts_as_taggable :join_class_name=>'GiftTag', :dependent=>:destroy

  has_and_belongs_to_many :givings,
    :class_name => 'User',
    :join_table => 'givings',
    :association_foreign_key => 'user_id',
    :autosave => true,
    :uniq => true

  validates_length_of       :description, :within => 1..256,  :allow_nil => false
  validates_length_of       :url,         :within => 1..256,  :allow_nil => true
  validates_numericality_of :price,                           :allow_nil => true

end
