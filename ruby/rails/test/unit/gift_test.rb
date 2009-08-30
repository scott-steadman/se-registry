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

  test 'work around bug in acts_as_taggable' do
    gift = create_gift(:tag_names=>'one two')
    gift.reload
    gift.tags.clear
    gift.update_attributes(:tag_names=>'one two three')
    gift.reload
    assert_equal %w[one three two], gift.tag_names.sort
  end

end
