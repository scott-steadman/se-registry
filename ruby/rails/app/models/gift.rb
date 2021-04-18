# == Schema Information
#
# Table name: gifts
#
#  id          :bigint           not null, primary key
#  user_id     :bigint
#  description :string           not null
#  url         :string
#  multi       :boolean          default(FALSE)
#  hidden      :boolean          default(FALSE)
#  price       :float
#  created_at  :datetime
#  updated_at  :datetime
#

class Gift < ApplicationRecord

  inheritance_column = :_type_disabled

  belongs_to :user

  acts_as_taggable

  alias :tag_names  :tag_list
  def tag_names=(string)
    self.tag_list = string.split(/[,\s]+/)
  end

  def tag(values)
    values = values.to_s.split(/[\s,]+/) unless values.is_a?(Array)
    self.tag_names = values
  end

  validates_length_of       :description, :within => 1..256,  :allow_nil => false
  validates_length_of       :url,         :within => 0..255,  :allow_nil => true
  validates_numericality_of :price,                           :allow_nil => true

  def editable_by?(other)
    other.admin? or user == other
  end

  def price=(value)
    super sanitize_price(value)
  end

  # Issue 84
  def urls=(array)
    self.url = array.join(' ')
  end

  # Issue 84
  def urls
    url.to_s.split(/[,\s]+/)
  end

  # Issue 28
  # Prevent rails helpers from generating method names like: user_gift_for_giving_path
  def self.model_name
    ActiveModel::Name.new(Gift)
  end

private

  def sanitize_price(value)
    value.is_a?(String) ? value.gsub(/[^\d.]/, '') : value
  end

end # class Gift
