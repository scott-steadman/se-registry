require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test 'index requires login' do
    get :index
    assert_redirected_to login_url
  end

  test 'index' do
    create_user
    get :index
    assert_response :success
    assert_equal 1, assigns['users'].size
  end

  test 'new' do
    assert_no_difference 'User.count' do
      get :new
      assert_response :success
      assert_not_nil assigns['user']
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
    end
    assert assigns(:user).errors[:login]
    assert_response :success
  end

  test 'create requires password on signup' do
    assert_no_difference 'User.count' do
      post :create, :params => user_params(:password => nil)
    end
    assert assigns(:user).errors[:password]
    assert_response :success
  end

  test 'create requires password confirmation on signup' do
    assert_no_difference 'User.count' do
      post :create, :params => user_params(:password_confirmation => nil)
    end
    assert assigns(:user).errors[:password_confirmation]
    assert_response :success
  end

  test 'create requires email on signup' do
    assert_no_difference 'User.count' do
      post :create, :params => user_params(:email => nil)
    end
    assert assigns(:user).errors[:email]
    assert_response :success
  end

  test 'show requires login' do
    get :show, :params => {:id => 42}
    assert_redirected_to login_url
  end

  test 'show other as admin' do
    create_user(:login => 'admin', :role => 'admin')
    other = create_user('other')
    login_as 'admin'
    get :show, :params => {:id => other.id}
    assert_equal 'other', assigns['user'].login
  end

  test 'show other as non admin' do
    login_as 'user'
    other = create_user('other')
    get :show, :params => {:id => other.id}
    assert_equal 'user', assigns['user'].login
  end

  test 'edit requires login' do
    get :edit
    assert_redirected_to login_url
  end

  test 'edit as user' do
    login_as 'user'
    get :edit
    assert_response :success
    assert_select "form>input"
  end

  test 'edit other as admin' do
    other = create_user('other')
    login_as admin = create_user(:login => 'admin', :role => 'admin')
    get :edit, :params => {:id => other.id}
    assert_response :success
    assert_equal other, assigns['user']
  end

  test 'edit other as user' do
    other = create_user('other')
    login_as user = create_user('user')
    get :edit, :params => {:id => other.id}
    assert_response :success
    assert_equal user, assigns['user']
  end

  test 'update requires login' do
    get :update
    assert_redirected_to login_url
  end

  test 'update fails on GET' do
    login_as user = create_user('user')
    get :update, :params => {:id => user.id}
    assert_template :edit
  end

  test 'update as other non admin' do
    login_as 'user'
    get :update, :params => {:id => create_user('other').id}
    assert_response :success
    assert_select "input[id='user_login'][value='user']"
  end

  test 'update as other prevents role assignment' do
    login_as user = create_user('user')
    get :update, :params => {:id => user.id, :user => {:role => 'admin'}}
    assert_response :success
    assert_equal 'user', user.reload.role
  end

  test 'update as admin' do
    login_as create_user(:login => 'user', :role => 'admin')
    other = create_user('other')
    patch :update, :params => {:id => other.id, :user => {:role => 'admin foo'}}
    assert_redirected_to home_url
    assert_equal other, assigns['user']
    assert_equal 'admin foo', other.reload.role
  end

  test 'update' do
    user = create_user('user')
    login_as 'user'
    patch :update, :params => {:user => {:email => 'new@example.com'}}
    assert_redirected_to home_url
    assert_equal 'new@example.com', user.reload.email
  end

  test 'update password' do
    user = create_user('user')
    login_as 'user'
    patch :update, :params => {:user => {:password => 'foo bar baz', :password_confirmation => 'foo bar baz'}}
    assert_redirected_to home_url
    assert user.reload.valid_password?('foo bar baz'), 'password should change'
  end

  test 'update failure' do
    login_as 'user'
    patch :update, :params => {:user => {:password => 'a', :password_confirmation => 'b'}}
    assert_response :success
    assert_select "div[id=errorExplanation]"
  end

  test 'destroy requires login' do
    delete :destroy
    assert_redirected_to login_url
  end

  test 'destroy fails on GET' do
    login_as 'user'
    assert_no_difference 'User.count' do
      get :destroy
    end
  end

  test 'destroy other as non admin' do
    user  = create_user('user')
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
    login_as user = create_user('user')
    assert_difference 'User.count', -1 do
      delete :destroy
      assert_redirected_to logout_url
    end
  end

  test 'destroy as admin' do
    user  = create_user(:login => 'user',:role => 'admin')
    other = create_user('deletable')
    login_as user
    assert_difference 'User.count', -1 do
      delete :destroy, :params => {:id => other.id}
      assert_redirected_to users_url
    end
  end

  test 'cannot destroy admin' do
    user = create_user(:login => 'user',:role => 'admin')
    login_as user
    assert_no_difference 'User.count' do
      delete :destroy, :params => {:id => user.id}
      assert_redirected_to users_url
      assert_match 'cannot delete', flash[:error]
    end
  end

  test 'home logged out' do
    get :home
    assert_redirected_to login_url
  end

  test 'home logged in' do
    login_as user = create_user(:login => 'user')
    get :home
    assert_response :success
    assert_match '/users/home', session[:return_to]
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
