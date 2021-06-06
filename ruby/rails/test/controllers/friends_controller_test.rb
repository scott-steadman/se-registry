require 'test_helper'

class FriendsControllerTest < ActionController::TestCase

  def setup
    @friend = create_user('friend')
    user.befriend(@friend)
  end

  test 'index requires login' do
    logout
    get :index
    assert_redirected_to login_url
  end

  test 'index with friend' do
    @friend.gifts.create!(:description => 'description', :price => 1.00, :multi => true)

    login_as user
    get :index
    assert_response :success

    assert_select "a[href='#{user_gifts_path(@friend)}']", @friend.login
  end

  test 'index without friend' do
    login_as 'stranger'
    get :index
    assert_response :success

    assert_no_match 'stranger', @response.body
  end

  test 'create with id' do
    another_friend = create_user('another_friend')

    assert_difference 'Friendship.count' do
      login_as user
      post :create, :params => {:id => another_friend.to_param}
      assert_redirected_to user_friends_path(@user)
    end

    assert_equal 2, @user.friends.reload.size
  end

  test 'create with login' do
    another_friend = create_user('another_friend')

    assert_difference 'Friendship.count' do
      login_as user
      post :create, :params => {:friend_login => another_friend.login}
      assert_redirected_to user_friends_path(@user)
    end

    assert_equal 2, @user.friends.reload.size
  end

  test 'create requires post' do
    assert_no_difference 'Friendship.count' do
      login_as user
      get :create
      assert_redirected_to user_friends_path(@user)
    end
  end

  test 'cannot friend self' do
    assert_no_difference 'Friendship.count' do
      login_as user
      post :create, :params => {:id => @user.to_param}
      assert_redirected_to users_path
    end

    assert_match 'yourself', flash[:notice]
  end

  test 'cannot add friend again' do
    assert_no_difference 'Friendship.count' do
      login_as user
      post :create, :params => {:id => @friend.to_param}
      assert_redirected_to users_path
    end

    assert_match 'already friends with', flash[:notice]
  end

  test 'destroy requires login' do
    logout
    get :destroy, :params => {:id => @friend.to_param}
    assert_redirected_to login_url
  end

  test 'destroy fails on GET' do
    assert_no_difference 'Friendship.count' do
      login_as user
      get :destroy, :params => {:id => @friend.to_param}
      assert_redirected_to user_friends_path(@user)
    end
  end

  test 'destroy' do
    assert_difference 'Friendship.count', -1 do
      login_as user
      delete :destroy, :params => {:id => @friend.to_param}
      assert_redirected_to user_friends_path(@user)
    end
  end

  test 'export' do
    gift = @friend.gifts.create!(:description => 'description', :price => 1.00, :multi => true)
    @user.give(gift)

    login_as user
    get :export
    assert_response :success

    assert_equal 3, @response.body.split(/\r\n/m).size, 'header, friend, and gift lines should be returned'
  end

end
