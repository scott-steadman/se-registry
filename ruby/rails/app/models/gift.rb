# == Schema Information
#
# Table name: gifts
#
#  id          :bigint           not null, primary key
#  user_id     :bigint
#  description :string           not null
#  url         :string
#  multi       :boolean          default("false")
#  hidden      :boolean          default("false")
#  price       :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Gift < ActiveRecord::Base

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

  has_and_belongs_to_many :givings,
    :class_name => 'User',
    :join_table => 'givings',
    :association_foreign_key => 'user_id',
    :autosave => true,
    :uniq => true

  validates_length_of       :description, :within => 1..256,  :allow_nil => false
  validates_length_of       :url,         :within => 0..255,  :allow_nil => true
  validates_numericality_of :price,                           :allow_nil => true

  def given?
    not givings.empty?
  end

  def givable_by?(other)
    return false if user == other
    return true  if givings.empty?
    return false if given_by?(other)
    multi
  end

  def given_by?(other)
    givings.include?(other)
  end

  def editable_by?(other)
    other.admin? or user == other or (hidden? and given_by?(other))
  end

  def price=(value)
    super sanitize_price(value)
  end

  # Issue #84
  def urls=(array)
    self.url = array.join(' ')
  end

  # Issue #84
  def urls
    url.to_s.split(/[,\s]+/)
  end

private

  def sanitize_price(value)
    value.is_a?(String) ? value.gsub(/[^\d.]/, '') : value
  end

end
