require 'test_helper'

class FriendsControllerTest < ActionController::TestCase

  def setup
    @user = create_user('user')
    @friend = create_user('friend')
    @user.befriend(@friend)
  end

  test 'index requires login' do
    logout
    get :index
    assert_redirected_to login_url
  end

  test 'index with friend' do
    @friend.gifts.create!(:description => 'description', :price => 1.00, :multi => true)
    get :index
    assert_response :success
    assert_equal %w[friend], assigns(:friends).map{|ii| ii.login}.sort
  end

  test 'index without friend' do
    login_as('friend')
    get :index
    assert_response :success
    assert_equal 0, assigns(:friends).size
  end

  test 'create' do
    another_friend = create_user('another_friend')
    assert_difference 'Friendship.count' do
      post :create, :id => another_friend.to_param
    end
    assert_redirected_to user_friends_path(@user)
    assert_equal 2, @user.friends(true).size
  end

  test 'create requires post' do
    assert_no_difference 'Friendship.count' do
      get :create
      assert_redirected_to user_friends_path(@user)
    end
  end

  test 'cannot friend self' do
    assert_no_difference 'Friendship.count' do
      post :create, :id => @user.to_param
      assert_redirected_to users_path
    end
    assert_match 'yourself', flash[:notice]
  end

  test 'cannot add friend again' do
    assert_no_difference 'Friendship.count' do
      post :create, :id => @friend.to_param
      assert_redirected_to users_path
    end
    assert_match 'already friends with', flash[:notice]
  end

  test 'destroy requires login' do
    logout
    get :destroy
    assert_redirected_to login_url
  end

  test 'destroy fails on GET' do
    assert_no_difference 'Friendship.count' do
      get :destroy, :id => @friend.to_param
    end
    assert_redirected_to user_friends_path(@user)
  end

  test 'destroy' do
    assert_difference 'Friendship.count', -1 do
      delete :destroy, :id => @friend.to_param
    end
    assert_redirected_to user_friends_path(@user)
  end

  test 'export' do
    gift = @friend.gifts.create!(:description => 'description', :price => 1.00, :multi => true)
    @user.give(gift)
    get :export
    assert_response :success
    assert_equal 3, @response.body.split(/\r\n/m).size, 'header, friend, and gift lines should be returned'
  end

end
