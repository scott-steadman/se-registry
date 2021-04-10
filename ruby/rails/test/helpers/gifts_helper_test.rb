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
    create_user('giver').givings << gift
    assert_equal 'giver Will', intent(gift)
  end

  test 'tags_for no tag parameter' do
    gift.update(:tag_names => 'foo bar')
    stubs(:params => {}, :url_for => 'url')
    gift.tag_names.each do |tag|
      assert_match %r{<a href="url">#{tag}</a>}, tags_for(gift)
    end
  end

  test 'tags_for with tag parameter' do
    gift.update(:tag_names => 'foo bar')
    stubs(:params => {:tag => 'foo'}, :url_for => 'url')
    assert_equal 'foo <a href="url">bar</a>', tags_for(gift), 'foo should not be a link'
  end

  test 'gift_actions will' do
    stubs(:current_user => giver, :page_user => recipient, :protect_against_forgery? => false)
    assert_match 'will', gift_actions(gift), 'will link should be present'
  end

  test 'gift_actions wont' do
    giver.givings << gift
    stubs(:current_user => giver, :page_user => recipient, :protect_against_forgery? => false)
    assert_match wont_user_gift_path(recipient, gift), gift_actions(gift), 'wont link should be present'
  end

  test 'gift_actions edit and remove' do
    stubs(:current_user => recipient, :page_user => recipient, :protect_against_forgery? => false)

    result = gift_actions(gift)

    assert_match edit_user_gift_path(recipient, gift), result, 'edit link should be present'
    assert_match user_gift_path(recipient, gift), result, 'remove link should be present'
  end

private

  def recipient
    @recipient ||= create_user('recipient')
  end

  def giver
    @giver ||= create_user(:login => 'giver')
  end

  def gift(attrs={})
    @gift ||= create_gift({:user => recipient, :class => Gift::ForGiving}.merge!(attrs))
  end

end
