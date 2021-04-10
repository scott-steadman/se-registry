require 'test_helper'

class GivingTest < ActiveSupport::TestCase

  test 'giver deletion deletes givings' do
    giver.give(gift)
    assert_difference 'Giving.count', -1 do
      giver.destroy
    end
  end

  test 'gift deletion deletes givings' do
    giver.give(gift)
    assert_difference 'Giving.count', -1 do
      gift.destroy
    end
  end

private

  def giver
    @giver ||= create_user('giver')
  end

  def gift
    @gift ||= create_gift(:class => Gift::ForGiving)
  end

end
