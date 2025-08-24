# == Schema Information
#
# Table name: gifts
#
#  id          :bigint           not null, primary key
#  user_id     :bigint
#  description :string           not null
#  url         :string
#  multi       :boolean          default(FALSE)
#  price       :float
#  created_at  :datetime
#  updated_at  :datetime
#  visibility  :text
#
class Gift::ForGiving < Gift

  def editable_by?(other)
    super or (hidden? and given_by?(other))
  end

  has_and_belongs_to_many :givings,
    :class_name               => 'User',
    :join_table               => 'givings',
    :foreign_key              => 'gift_id',
    :association_foreign_key  => 'user_id',
    :autosave                 => true,
    :uniq                     => true

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

end # class Gift::ForGiving
