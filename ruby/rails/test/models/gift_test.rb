require 'test_helper'

class GiftTest < ActiveSupport::TestCase

  test 'description must not be nil' do
    gift = Gift.create
    assert_match /is too short/, gift.errors[:description].first
  end

  test 'description must not be blank' do
    gift = Gift.create(:description => '')
    assert_match /is too short/, gift.errors[:description].first
  end

  test 'price sanitization' do
    assert_equal 1,   Gift.new(:description => 'description', :price => '$1 million dollars').price
    assert_equal 1.5, Gift.new(:description => 'description', :price => '1.50').price
  end

  test 'should create gift' do
    assert_difference 'Gift.count' do
      assert !gift.new_record?, "#{gift.errors.full_messages.to_sentence}"
    end
  end

  test 'editable_by admin' do
    assert gift.editable_by?(admin), 'admins should be able to edit any gift'
  end

  test 'editable_by other' do
    other = create_user('other')
    assert !gift.editable_by?(other), 'others should NOT be able to edit any gift'
  end

  test 'editable_by creator' do
    gift = create_gift(:user => user)
    assert gift.editable_by?(user), 'creators should be able to edit their own gift'
  end

  # Issue 95
  test 'tag_names= splits tags' do
    assert_equal ['one', 'two'], Gift.new(:tag_names => 'one, two').tag_names
  end

  # Issue 84
  test 'urls' do
    assert_equal ['one'],        Gift.new(:url => 'one').urls
    assert_equal ['one', 'two'], Gift.new(:urls => ['one', 'two']).urls
  end

  test 'gift deletion deletes taggings' do
    gift.tag 'foo bar baz'
    gift.save!
    assert_difference 'Tagging.count', -3 do
      gift.destroy
    end
  end

private

  def recipient
    @recipient ||= create_user(:login => 'recip')
  end

  def giver
    @giver ||= create_user(:login => 'giver')
  end

  def gift(attrs={})
    @gift ||= create_gift({:user => recipient}.merge!(attrs))
  end

end
