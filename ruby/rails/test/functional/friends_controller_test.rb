require File.dirname(__FILE__) + '/../test_helper'

class FriendsControllerTest < ActionController::TestCase

  def setup
    @user = create_user('user')
    @friend = create_user('friend')
    @user.friends << @friend
    login_as('user')
  end

  test 'index with friend' do
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
    assert_difference('Friendship.count') do
      post :create, :id => another_friend.id
    end
    assert_redirected_to user_friends_path(@user)
    assert_equal 2, @user.friends(true).size
  end

  test 'destroy' do
    assert_difference('Friendship.count', -1) do
      delete :destroy, :id => @friend.id
    end
    assert_redirected_to user_friends_path(@user)
  end
end
