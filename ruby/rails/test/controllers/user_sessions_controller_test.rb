require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase

  test 'new' do
    get :new
    assert_response :success
  end

  test 'create when logged out redirects to home' do
    user # create the user
    logout
    post :create, :params => {:user_session => {:login => user.login, :password => user.password}}
    assert_redirected_to home_url

    assert_match 'successful', flash[:notice]
  end

  test 'create when logged in redirects to home' do
    login_as user
    post :create, :params => {:user_session => {:login => user.login, :password => user.password}}
    assert_redirected_to home_url
  end

  test 'create with failed save' do
    logout
    post :create, :params => {:user_session => {:login => 'user', :password => 'foo'}}
    assert_response :success

    assert_select "form[action='#{user_session_path}']"
  end

  test 'create transitions from old crypto' do
    old_salt     = 'salt'
    old_password = User::ForAuthentication::OldCrypto.encrypt('my password', old_salt)
    User.create!(:login => 'user', :crypted_password => old_password, :password_salt => old_salt)

    logout
    post :create, :params => {:user_session => {:login => 'user', :password => 'my password'}}
    assert_redirected_to home_url
  end

  test 'destroy when logged out' do
    logout
    get :destroy
    assert_redirected_to login_url
  end

  test 'destroy when logged in' do
    login_as user
    get :destroy
    assert_redirected_to login_url
  end

  # Issue 110
  test 'clear_cookies when logged out' do
    cookies[:foo] = 'bar'
    logout

    get :clear_cookies
    assert_redirected_to login_url

    assert_match 'cookies have been cleared', flash[:notice]
    assert response.cookies.empty?, 'cookies should be cleared'
  end

  # Issue 110
  test 'clear_cookies when logged in' do
    cookies[:foo] = 'bar'

    login_as user
    get :clear_cookies
    assert_redirected_to login_url

    assert_match 'cookies have been cleared', flash[:notice]
  end

end
