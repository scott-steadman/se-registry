require File.dirname(__FILE__) + '/../test_helper'

class UserSessionsControllerTest < ActionController::TestCase

  def test_new
    get :new
    assert_not_nil assigns['user_session']
  end

  def test_create_when_logged_out
    create_user(:login=>'user', :password=>'testme1', :password_confirmation=>'testme1')
    @controller.send(:current_user_session).destroy
    post :create, :user_session=>{:login=>'user', :password=>'testme1'}
    assert_redirected_to home_url
    assert_match 'successful', @response.flash[:notice]
  end

  def test_create_when_logged_in
    login_as('user')
    post :create, :user_session=>{:login=>'user', :password=>'testme1'}
    assert_redirected_to home_url
  end

  def test_create_with_failed_save
    create_user(:login=>'user', :password=>'testme1', :password_confirmation=>'testme1')
    @controller.send(:current_user_session).destroy
    post :create, :user_session=>{:login=>'user', :password=>'foo'}
    assert_template 'new'
  end

  def test_destroy_when_logged_out
    get :destroy
    assert_redirected_to login_url
  end

  def test_destroy_when_logged_in
    login_as('user')
    get :destroy
    assert_redirected_to login_url
  end

end
