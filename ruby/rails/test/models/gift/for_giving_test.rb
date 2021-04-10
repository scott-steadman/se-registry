require 'test_helper'

class Gift::ForGivingTest < ActiveSupport::TestCase

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

  # Issue 85
  test 'editable_by other can edit hidden' do
    gift  = create_gift(:user => giver, :hidden => true)
    recipient.give(gift)
    assert gift.editable_by?(giver), 'others can edit hidden gifts they give'
  end

private

  def recipient
    @recipient ||= create_user(:login => 'recip')
  end

  def giver
    @giver ||= create_user(:login => 'giver')
  end

  def gift(attrs={})
    @gift ||= create_gift({:user => recipient, :class => Gift::ForGiving}.merge!(attrs))
  end

end # class Gift::ForGivingTest
