require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase

  test 'new' do
    get :new
    assert_not_nil assigns['user_session']
  end

  test 'create when logged out' do
    create_user(:login=>'user', :password=>'testme1', :password_confirmation=>'testme1')
    logout
    post :create, :user_session=>{:login=>'user', :password=>'testme1'}
    assert_redirected_to home_url
    assert_match 'successful', @response.flash[:notice]
  end

  test 'create when logged in' do
    login_as('user')
    post :create, :user_session=>{:login=>'user', :password=>'testme1'}
    assert_redirected_to home_url
  end

  test 'create with failed save' do
    create_user(:login=>'user', :password=>'testme1', :password_confirmation=>'testme1')
    logout
    post :create, :user_session=>{:login=>'user', :password=>'foo'}
    assert_template 'new'
  end

  test 'destroy when logged out' do
    get :destroy
    assert_redirected_to login_url
  end

  test 'destroy when logged in' do
    login_as('user')
    get :destroy
    assert_redirected_to login_url
  end

end
