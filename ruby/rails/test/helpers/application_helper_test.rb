require 'test_helper'

class ApplicaitonHelperTest < ActionView::TestCase
  include ApplicationHelper

  test 'possessivize with no trailing s' do
    assert_equal "Scott's", possessivize('Scott')
  end

  test 'possessivize with trailing s' do
    assert_equal "Scotts'", possessivize("Scotts")
  end

  test 'link_to_function' do
    assert_match 'bar();return false;',  link_to_function('foo', 'bar()'), 'return false should be added'
    assert_match 'bar(); return false;', link_to_function('foo', 'bar(); return false;'), 'return false already there'
  end

  # Issue 39
  test 'external_link_to adds rel noopener' do
    assert_match 'noopener', external_link_to('http://foo.com')
  end

end # class ApplicationHelperTest
