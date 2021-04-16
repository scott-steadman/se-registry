require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test 'index requires login' do
    logout
    get :index
    assert_redirected_to login_url
  end

  test 'index' do
    other = create_user('other')

    login_as user
    get :index
    assert_response :success

    assert_select 'td',  other.login, 'other should be rendered'
    assert_select 'td',  {:count => 0, :text => user.login},  'user should NOT be rendered'
  end

  test 'new' do
    assert_no_difference 'User.count' do
      get :new
      assert_response :success
    end
  end

  test 'create should allow signup' do
    assert_difference 'User.count', 1 do
      post :create, :params => user_params
      assert_redirected_to home_path
    end
  end

  test 'create requires login on signup' do
    assert_no_difference 'User.count' do
      post :create, :params => user_params(:login => nil)
      assert_response :success
    end

    assert_select "div[id=error_explanation]", /Login is too short/, 'error message should be rendered'
  end

  test 'create requires password on signup' do
    assert_no_difference 'User.count' do
      post :create, :params => user_params(:password => nil)
      assert_response :success
    end

    assert_select "div[id=error_explanation]", /Password is too short/, 'error message should be rendered'
  end

  test 'create requires password confirmation on signup' do
    assert_no_difference 'User.count' do
      post :create, :params => user_params(:password_confirmation => nil)
      assert_response :success
    end

    assert_select "div[id=error_explanation]", /Password confirmation is too short/, 'error message should be rendered'
  end

  test 'create requires email on signup' do
    assert_no_difference 'User.count' do
      post :create, :params => user_params(:email => nil)
      assert_response :success
    end

    assert_select "div[id=error_explanation]", /Email is too short/, 'error message should be rendered'
  end

  test 'show requires login' do
    logout
    get :show, :params => {:id => 42}
    assert_redirected_to login_url
  end

  test 'show other as admin' do
    other = create_user('other')

    login_as admin
    get :show, :params => {:id => other.id}
    assert_response :success

    assert_select "p", /#{other.login}/, 'other user should be rendered'
  end

  test 'show other as non admin' do
    other = create_user('other')

    login_as user
    get :show, :params => {:id => other.id}
    assert_response :success

    assert_select "p", /#{user.login}/, 'user should be rendered'
    assert_select "p", {:count => 0, :text => /#{other.login}/}, 'other user should NOT be rendered'
  end

  test 'edit requires login' do
    logout
    get :edit
    assert_redirected_to login_url
  end

  test 'edit as user' do
    login_as user
    get :edit
    assert_response :success

    assert_select "form[action='#{user_path(user)}'][method=post]", 2, 'edit form and close account button should be rendered'
  end

  test 'edit other as admin' do
    other = create_user('other')

    login_as admin
    get :edit, :params => {:id => other.id}
    assert_response :success

    assert_select "form[action='#{user_path(other)}'][method=post]", 2, 'edit form and close account button should be rendered'
  end

  test 'edit other as user' do
    other = create_user('other')

    login_as user
    get :edit, :params => {:id => other.id}
    assert_response :success

    assert_select "form[action='#{user_path(user)}'][method=post]",  2, 'edit form and close account button should be rendered'
    assert_select "form[action='#{user_path(other)}'][method=post]", 0, 'edit form should NOT be rendered'
  end

  test 'update requires login' do
    logout
    get :update
    assert_redirected_to login_url
  end

  test 'update fails on GET' do
    login_as user
    get :update, :params => {:id => user.id}
    assert_response :success

    assert_select "form[action='#{user_path(user)}']"
  end

  test 'update as other non admin' do
    login_as user
    get :update, :params => {:id => create_user('other').id}
    assert_response :success

    assert_select "input[id='user_login'][value='#{user.login}']"
  end

  test 'update as user prevents role assignment' do
    login_as user
    get :update, :params => {:id => user.id, :user => {:role => 'admin'}}
    assert_response :success

    assert_equal 'user', user.reload.role
  end

  test 'update as admin' do
    other = create_user('other')

    login_as admin
    patch :update, :params => {:id => other.id, :user => {:role => 'admin foo'}}
    assert_redirected_to home_url

    assert_equal 'admin foo', other.reload.role
  end

  test 'update' do
    login_as user
    patch :update, :params => {:user => {:email => 'new@example.com'}}
    assert_redirected_to home_url

    assert_equal 'new@example.com', user.reload.email
  end

  test 'update password' do
    login_as user
    patch :update, :params => {:user => {:password => 'foo bar baz', :password_confirmation => 'foo bar baz'}}
    assert_redirected_to home_url

    assert user.reload.valid_password?('foo bar baz'), 'password should change'
  end

  test 'update failure' do
    login_as user
    patch :update, :params => {:user => {:password => 'a', :password_confirmation => 'b'}}
    assert_response :success

    assert_select "div[id=error_explanation]"
  end

  test 'destroy requires login' do
    logout
    delete :destroy
    assert_redirected_to login_url
  end

  test 'destroy fails on GET' do
    login_as user
    assert_no_difference 'User.count' do
      get :destroy
      assert_redirected_to logout_url
    end
  end

  test 'destroy other as non admin should destroy self' do
    other = create_user('other')

    login_as user
    assert_difference 'User.count', -1 do
      delete :destroy, :params => {:id => other.id}
      assert_redirected_to logout_url
    end

    assert !User.exists?(user.id),  'user should be deleted'
    assert  User.exists?(other.id), 'other should NOT be deleted'
  end

  test 'close account' do
    login_as user
    assert_difference 'User.count', -1 do
      delete :destroy
      assert_redirected_to logout_url
    end
  end

  test 'destroy other as admin' do
    other = create_user('deletable')

    login_as admin
    assert_difference 'User.count', -1 do
      delete :destroy, :params => {:id => other.id}
      assert_redirected_to users_url
    end
  end

  test 'cannot destroy admin' do
    login_as admin
    assert_no_difference 'User.count' do
      delete :destroy, :params => {:id => admin.id}
      assert_redirected_to users_url
    end

    assert_match 'cannot delete', flash[:error]
  end

  test 'home logged out' do
    get :home
    assert_redirected_to login_url
  end

  test 'home logged in' do
    login_as user
    get :home
    assert_response :success

    assert_match '/users/home', session[:return_to]
  end

  # Issue 11
  test 'user with null ui_version renders default view' do
    login_as user
    get :home
    assert_response :success

    assert_select 'div[id=doc3]', {:message => 'a/v/layouts/application.html.erb should be rendered'}
  end

  # Issue 11
  test 'user with ui_version renders versioned view' do
    login_as user(:ui_version => 2)
    get :home
    assert_response :success

    assert_select 'header', {:message => 'a/v/v2/layouts/application.html.erb should be rendered'}
  end

private

  def user_params(options={})
    { :user => {
        :login                 => 'quire',
        :email                 => 'quire@example.com',
        :password              => 'my password',
        :password_confirmation => 'my password'
      }.merge!(options)
    }
  end

end
