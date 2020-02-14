require 'test_helper'

class GiftsHelperTest < ActionView::TestCase
  include ERB::Util

  # Issue #84
  test 'links_for' do
    links = 'http://one.com http://two.com'
    gift  = Gift.new(:description => 'desc', :url => links)

    result = links_for(gift)
    links.split(/\s+/).each do |link|
      assert_match link, result, "#{link} missing"
    end
  end

  test 'intent no givings' do
    assert_nil intent(Gift.new)
  end

  test 'intent with givings' do
    recip = create_user('recip')
    gift = create_gift(:user => recip)
    create_user('giver').givings << gift
    assert_equal 'giver Will', intent(gift)
  end

  test 'tags_for no tag parameter' do
    gift = create_gift
    gift.tag_names << 'foo'
    gift.tag_names << 'bar'
    stubs(:params => {}, :url_for => 'url')
    gift.tag_names.each do |tag|
      assert_match %r{<a href="url">#{tag}</a>}, tags_for(gift)
    end
  end

  test 'tags_for with tag parameter' do
    gift = create_gift
    gift.tag_names << 'foo'
    gift.tag_names << 'bar'
    stubs(:params => {:tag => 'foo'}, :url_for => 'url')
    assert_equal 'foo <a href="url">bar</a>', tags_for(gift), 'foo should not be a link'
  end

  test 'gift_actions will' do
    giver = create_user('giver')
    recip = create_user('recip')
    gift = create_gift(:user => recip)
    stubs(:current_user => giver, :page_user => recip, :protect_against_forgery? => false)
    assert_match 'will', gift_actions(gift), 'will link should be present'
  end

  test 'gift_actions wont' do
    giver = create_user('giver')
    recip = create_user('recip')
    gift = create_gift(:user => recip)
    giver.givings << gift
    stubs(:current_user => giver, :page_user => recip, :protect_against_forgery? => false)
    assert_match wont_user_gift_path(recip, gift), gift_actions(gift), 'wont link should be present'
  end

  test 'gift_actions edit and remove' do
    recip = create_user('recip')
    gift = create_gift(:user => recip)
    stubs(:current_user => recip, :page_user => recip, :protect_against_forgery? => false)

    result = gift_actions(gift)

    assert_match edit_user_gift_path(recip, gift), result, 'edit link should be present'
    assert_match user_gift_path(recip, gift), result, 'remove link should be present'
  end

end
