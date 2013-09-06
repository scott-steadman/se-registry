require 'test_helper'

class GiftTest < ActiveRecord::TestCase

  test 'description must not be nil' do
    gift = Gift.create
    assert_match /is too short/, gift.errors[:description].first
  end

  test 'description must not be blank' do
    gift = Gift.create({:description => ''}, :as => :tester)
    assert_match /is too short/, gift.errors[:description].first
  end

  test 'price sanitization' do
    assert_equal 1, Gift.new({:description => 'description', :price => '$1 million dollars'}, :as => :tester).price
    assert_equal 1, Gift.new({:description => 'description', :price => '1.50'}, :as => :tester).price
  end

  test 'should create gift' do
    assert_difference 'Gift.count' do
      gift = create_gift
      assert !gift.new_record?, "#{gift.errors.full_messages.to_sentence}"
    end
  end

  test 'given' do
    assert ! gift.given?
    giver.give(gift)
    assert gift.reload.given?
  end

  test 'givable_by' do
    gift(:multi => true)

    assert ! gift.givable_by?(recipient), 'cannot give self a gift'
    assert gift.givable_by?(giver), 'gifts should be givable if not already given'

    giver.give(gift)
    assert ! gift.reload.givable_by?(giver), 'giver cannot give same gift more than once'

    assert gift.givable_by?(create_user), 'multi gifts can be give by many givers'
  end

  test 'editable_by admin' do
    user = create_user(:role => 'admin')
    gift = create_gift
    assert gift.editable_by?(user), 'admins should be able to edit any gift'
  end

  test 'editable_by other' do
    user = create_user
    gift = create_gift
    assert !gift.editable_by?(user), 'others should NOT be able to edit any gift'
  end

  test 'editable_by self' do
    user = create_user
    gift = create_gift(:user => user)
    assert gift.editable_by?(user), 'users should be able to edit their own gift'
  end

  # Issue 85
  test 'editable_by other can edit hidden' do
    user  = create_user('user')
    gift  = create_gift(:user => user, :hidden => true)
    other = create_user('other')
    other.give(gift)
    assert gift.editable_by?(other), 'others can edit hidden gifts they give'
  end

  # Issue 95
  test 'tag_names= splits tags' do
    assert_equal ['one', 'two'], Gift.new({:tag_names => 'one, two'}, :as => :tester).tag_names
  end

  # Issue #84
  test 'urls' do
    assert_equal ['one'],        Gift.new({:url => 'one'},           :as => :tester).urls
    assert_equal ['one', 'two'], Gift.new({:urls => ['one', 'two']}, :as => :tester).urls
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
