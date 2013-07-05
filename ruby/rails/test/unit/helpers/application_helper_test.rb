require 'test_helper'

class ApplicaitonHelperTest < ActionView::TestCase
  include ApplicationHelper

  test 'possessivize with no trailing s' do
    assert_equal "Scott's", possessivize('Scott')
  end

  test 'possessivize with trailing s' do
    assert_equal "Scotts'", possessivize("Scotts")
  end

end
