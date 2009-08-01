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

require File.dirname(__FILE__) + '/../test_helper'

class GiftTest < ActiveRecord::TestCase

  def test_description_must_not_be_nil
    gift = Gift.create
    assert_match /is too short/, gift.errors.on(:description)
  end

  def test_description_must_not_be_blank
    gift = Gift.create(:description=>'')
    assert_match /is too short/, gift.errors.on(:description)
  end

  def test_url_must_not_be_blank
    gift = Gift.create(:description=>'test', :url=>'')
    assert_match /is too short/, gift.errors.on(:url)
  end

  def test_price_must_be_number
    gift = Gift.create(:description=>'description', :price=>'a')
    assert_equal "is not a number", gift.errors.on(:price)
  end

  def test_should_create_gift
    assert_difference 'Gift.count' do
      gift = create_gift
      assert !gift.new_record?, "#{gift.errors.full_messages.to_sentence}"
    end
  end

end
