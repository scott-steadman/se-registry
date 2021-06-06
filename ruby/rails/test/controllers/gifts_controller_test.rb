require 'test_helper'

class GiftsControllerTest < ActionController::TestCase

  test 'index requires login' do
    logout
    get :index
    assert_redirected_to login_url
  end

  test 'index' do
    create_gift(:user => user)
    create_gift(:user => user)

    login_as user
    get :index
    assert_response :success

    user.gifts.each do |gift|
      assert_select "a[href='#{edit_user_gift_path(user, gift)}']", 'edit', 'edit link should be rendered'
    end
  end

  # Issue 11
  test 'index ui_version=2 renders terse external link' do
    create_gift(:user => user, :url => 'http://www.foo.com')

    login_as user
    get :index, :params => {:ui_version => 2}
    assert_response :success

    user.gifts.each do |gift|
      assert_select "a[href='http://www.foo.com']", 'foo', 'external link should be rendered'
    end
  end

  test 'index with per_page param' do
    included = create_gift(:user => user)
    excluded = create_gift(:user => user)

    login_as user
    get :index, :params => {:per_page => 1}
    assert_response :success

    assert_select 'tr[class=gift-row]', 1, 'only one gift row should be rendered'
    assert_select 'a[class=next_page]', 1, 'next page link should be rendered'
  end

  test 'index with tag param' do
    included = create_gift(:user => user, :tag_names => 'foo bar')
    excluded = create_gift(:user => user, :tag_names => 'bar')

    login_as user
    get :index, :params => {:tag => 'foo'}
    assert_response :success

    assert_select "a[href='/?tag=bar']",                              1,      'link to bar tag should be rendered'
    assert_select "a[href='#{edit_user_gift_path(user, included)}']", 'edit', 'edit link should be rendered'
    assert_select "a[href='#{edit_user_gift_path(user, excluded)}']", 0,      'edit link should NOT be rendered'
  end

  test 'index with csv format' do
    gift = create_gift(:user => user, :description => 'one', :price => 1.00, :multi => false)
    giver = create_user('giver')
    giver.give(gift)

    login_as user
    get :index, :params => {:format => 'csv'}
    assert_response :success

    assert_equal 2, @response.body.split(/\r\n/m).size, 'header, gift lines should be returned'
  end

  test 'new requires login' do
    logout
    get :new
    assert_redirected_to login_url
  end

  test 'new' do
    login_as user
    get :new
    assert_response :success
  end

  # Issue 85
  test 'new gift for other' do
    other = create_user('other')

    login_as user
    get :new, :params => {:user_id => other}
    assert_response :success

    assert_select "input[name='gift[hidden]'][type=checkbox][value=1]", 1, 'gifts created for others should be hidden'
    assert_select "input[name='gift[tag_names]'][value=secret]",        1, 'gifts created for others should tagged secret'
  end

  test 'create requires login' do
    get :create
    assert_redirected_to login_url
  end

  test 'create fails on GET' do
    assert_no_difference 'Gift.count' do
      login_as user
      get :create
      assert_redirected_to user_gifts_path(user)
    end
  end

  test 'create' do
    assert_difference 'Gift.count', 1 do
      login_as user
      post :create, :params => gift_params
      assert_redirected_to user_gifts_path(user)
    end
  end

  # Issue 11
  test 'create via xhr' do
    login_as user(:ui_version => 2)
    post :create, :params => gift_params, :xhr => true
    assert_response :success

    assert_select "a[href='#{edit_user_gift_path(user, user.gifts.last)}']", 'edit'
  end

  test 'create gift for other' do
    other = create_user('other')

    login_as user
    post :create, :params => {:user_id => other}.merge!(gift_params(:hidden => true))
    assert_redirected_to user_gifts_path(other)

    gift = other.gifts.first
    assert gift.hidden?,         'gifts created for others should be hidden'
    assert gift.given_by?(user), 'gifts created for others should be given by creator'
  end

  test 'create with error' do
    login_as user
    post :create
    assert_response :success

    assert_select "form[action='#{user_gifts_path(user)}'][method=post]"
    assert_select "form>div[id=error_explanation]"
  end

  test 'edit requires login' do
    logout
    get :edit, :params => {:id => 42}
    assert_redirected_to login_url
  end

  test 'edit' do
    gift = create_gift(:user => user)

    login_as user
    get :edit, :params => {:id => gift.id}
    assert_response :success

    assert_select "form[action='#{user_gift_path(user, gift)}'][method=post]"
  end

  test 'update requires login' do
    logout
    get :update, :params => {:id => 42}
    assert_redirected_to login_url
  end

  test 'update fails on GET' do
    gift = create_gift(:user => user)

    login_as user
    get :update, :params => {:id => gift.id, :gift => gift.attributes}
    assert_redirected_to user_gifts_path(user)
  end

  test 'update' do
    gift = create_gift(:user => user)

    login_as user
    patch :update, :params => {:id => gift.id, :gift => {:url => 'new url'}}
    assert_redirected_to user_gifts_path(user)

    assert_equal 'new url', gift.reload.url
  end

  test 'update fails with bad data' do
    gift = create_gift(:user => user)

    login_as user
    patch :update, :params => {:id => gift.id, :gift => {:description => ''}}
    assert_response :success

    assert_select "form[action='#{user_gift_path(user, gift)}'][method=post]"
  end

  test 'destroy requires login' do
    logout
    delete :destroy, :params => {:id => 42}
    assert_redirected_to login_url
  end

  test 'destroy fails on GET' do
    gift = create_gift(:user => user)

    assert_no_difference 'Gift.count' do
      login_as user
      get :destroy, :params => {:id => gift.id}
      assert_redirected_to user_gifts_path(user)
    end
  end

  test 'destroy' do
    gift = create_gift(:user => user)

    assert_difference 'Gift.count', -1 do
      login_as user
      delete :destroy, :params => {:id => gift.id}
      assert_redirected_to user_gifts_path(user)
    end
  end

  test 'will requires login' do
    logout
    get :will, :params => {:user_id => 42, :id => 42}
    assert_redirected_to login_url
  end

  test 'will fails on GET' do
    user.befriend(friend = create_user('friend'))
    gift = create_gift(:user => friend)

    assert_no_difference 'Giving.count' do
      login_as user
      get :will, :params => {:user_id => friend.id, :id => gift.id}
      assert_redirected_to user_gifts_path(friend)
    end
  end

  test 'will' do
    user.befriend(friend = create_user('friend'))
    gift = create_gift(:user => friend)

    assert_difference 'Giving.count', 1 do
      login_as user
      post :will, :params => {:user_id => friend.id, :id => gift.id}
      assert_redirected_to user_gifts_path(friend)
    end
  end

  test 'wont requires login' do
    logout
    delete :wont, :params => {:user_id => 42, :id => 42}
    assert_redirected_to login_url
  end

  test 'wont fails on GET' do
    user.befriend(friend = create_user('friend'))
    gift = create_gift(:user => friend)
    user.give(gift)

    assert_no_difference 'Giving.count' do
      login_as user
      get :wont, :params => {:user_id => friend.id, :id => gift.id}
      assert_redirected_to user_gifts_path(friend)
    end
  end

  test 'wont' do
    user.befriend(friend = create_user('friend'))
    gift = create_gift(:user => friend)
    user.give(gift)

    assert_difference 'Giving.count', -1 do
      login_as user
      delete :wont, :params => {:user_id => friend.id, :id => gift.id}
      assert_redirected_to user_gifts_path(friend)
    end
  end

  test 'admin can remove others givings' do
    other = create_user('other')
    other.befriend(friend = create_user('friend'))
    gift = create_gift(:user => other)
    friend.give(gift)

    assert_difference 'Giving.count', -1 do
      login_as admin
      delete :wont, :params => {:user_id => other.id, :id => gift.id}
      assert_redirected_to user_gifts_path(other)
    end
  end

  test 'non-admin cannot remove others givings' do
    other = create_user('other')
    other.befriend(friend = create_user('friend'))
    gift = create_gift(:user => other)
    friend.give(gift)

    assert_no_difference 'Giving.count' do
      login_as user
      delete :wont, :params => {:user_id => other.id, :id => gift.id}
      assert_redirected_to user_gifts_path(other)
    end
  end

  # Issue 95
  test 'no spaces in tags' do
    gift = create_gift(:user => user)

    login_as user
    patch :update, :params => {:id => gift.id, :gift => {:tag_names => 'one two'}}
    assert_redirected_to user_gifts_path(user)

    assert_equal ['one', 'two'], gift.reload.tag_names, 'spaces should not be allowed in tag names'
  end

private

  def gift_params(params={})
    { :gift => {
        :description => 'description',
        :url         => 'url',
        :price       => 1.00,
      }.merge!(params)
    }
  end

end
