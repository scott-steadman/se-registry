require File.dirname(__FILE__) + '/../test_helper'

class GiftTest < ActiveRecord::TestCase

  test 'description must not be nil' do
    gift = Gift.create
    assert_match /is too short/, gift.errors.on(:description)
  end

  test 'description must not be blank' do
    gift = Gift.create(:description=>'')
    assert_match /is too short/, gift.errors.on(:description)
  end

  test 'price sanitization' do
    gift = Gift.new(:description=>'description', :price=>'$1 million dollars')
    assert_equal 1, gift.price
  end

  test 'should create gift' do
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
