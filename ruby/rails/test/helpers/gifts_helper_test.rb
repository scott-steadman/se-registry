require 'test_helper'

class GiftsHelperTest < ActionView::TestCase

  test 'intent no givings' do
    assert_nil intent(Gift.new)
  end

  test 'intent with givings' do
    giver.givings << gift
    assert_equal 'giver Will', intent(gift)
  end

private

  def recipient
    @recipient ||= create_user('recipient')
  end

  def giver
    @giver ||= create_user('giver')
  end

  def gift(attrs={})
    @gift ||= create_gift({:user => recipient, :class => Gift::ForGiving}.merge!(attrs))
  end

end
