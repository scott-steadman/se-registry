require 'test_helper'

class GiftsHelperTest < ActionView::TestCase
  include ERB::Util

  def test_description_of_no_url
    gift = Gift.new({:description => 'desc'}, :as => :tester)
    assert_equal 'desc', description_of(gift)
  end

  def test_description_of_with_url
    gift = Gift.new({:description => 'desc', :url => 'http://www.foo.com'}, :as => :tester)
    assert_match 'http://www.foo.com', description_of(gift)
  end

  def test_intent_no_givings
    assert_nil intent(Gift.new)
  end

  def test_intent_with_givings
    recip = create_user('recip')
    gift = create_gift(:user => recip)
    create_user('giver').givings << gift
    assert_equal 'giver Will', intent(gift)
  end

  def test_tags_for_no_tag_parameter
    gift = create_gift
    gift.tag_names << 'foo'
    gift.tag_names << 'bar'
    stubs(:params => {}, :url_for => 'url')
    gift.tag_names.each do |tag|
      assert_match %r{<a href="url">#{tag}</a>}, tags_for(gift)
    end
  end

  def test_tags_for_with_tag_parameter
    gift = create_gift
    gift.tag_names << 'foo'
    gift.tag_names << 'bar'
    stubs(:params => {:tag => 'foo'}, :url_for => 'url')
    assert_equal 'foo <a href="url">bar</a>', tags_for(gift), 'foo should not be a link'
  end

  def test_gift_actions_will
    giver = create_user('giver')
    recip = create_user('recip')
    gift = create_gift(:user => recip)
    stubs(:current_user => giver, :page_user => recip, :protect_against_forgery? => false)
    assert_match 'will', gift_actions(gift), 'will link should be present'
  end

  def test_gift_actions_wont
    giver = create_user('giver')
    recip = create_user('recip')
    gift = create_gift(:user => recip)
    giver.givings << gift
    stubs(:current_user => giver, :page_user => recip, :protect_against_forgery? => false)
    assert_match wont_user_gift_path(recip, gift), gift_actions(gift), 'wont link should be present'
  end

  def test_gift_actions_edit_and_remove
    recip = create_user('recip')
    gift = create_gift(:user => recip)
    stubs(:current_user => recip, :page_user => recip, :protect_against_forgery? => false)

    result = gift_actions(gift)

    assert_match edit_user_gift_path(recip, gift), result, 'edit link should be present'
    assert_match user_gift_path(recip, gift), result, 'remove link should be present'
  end

end
