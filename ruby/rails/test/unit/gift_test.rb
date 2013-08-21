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
