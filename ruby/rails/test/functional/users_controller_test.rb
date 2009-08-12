require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase

  def test_index_requires_login
    get :index
    assert_redirected_to login_url
  end

  def test_index
    create_user
    get :index
    assert_response :success
    assert_equal 1, assigns['users'].size
  end

  def test_new
    get :new
    assert_not_nil assigns['user']
  end

  def test_create_should_allow_signup
    assert_difference 'User.count', 1 do
      post :create, user_params
      assert_redirected_to home_path
    end
  end

  def test_create_should_require_login_on_signup
    assert_no_difference 'User.count', 1 do
      post :create, user_params(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_response :success
    end
  end

  def test_create_should_require_password_on_signup
    assert_no_difference 'User.count', 1 do
      post :create, user_params(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_response :success
    end
  end

  def test_create_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count', 1 do
      post :create, user_params(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_create_should_require_email_on_signup
    assert_no_difference 'User.count', 1 do
      post :create, user_params(:email => nil)
      assert assigns(:user).errors.on(:email)
      assert_response :success
    end
  end

  def test_show_redirects_to_login_if_not_logged_in
    get :show
    assert_redirected_to login_url
  end

  def test_show_shows_self
    login_as 'user'
    get :show
    assert_equal 'user', assigns['user'].login
  end

  def test_show_shows_other_if_admin
    create_user(:login=>'admin', :role=>'admin')
    other = create_user('other')
    login_as 'admin'
    get :show, :id=>other.id
    assert_equal 'other', assigns['user'].login
  end

  def test_show_denies_other_unless_admin
    other = create_user('other')
    login_as 'user'
    get :show, :id=>other.id
    assert_equal 'user', assigns['user'].login
  end


  def test_update_should_return_user_form
    login_as 'user'
    get :update, :id=>1
    assert_response :success
  end

  def test_non_admin_should_not_return_another_user_form
    other = create_user('other')
    login_as 'user'
    get :update, :id=>other.id
    assert_response :success
    assert_select "input[id='user_login'][value='user']"
  end

  def test_admin_should_return_other_user_form
    other = create_user('other')
    create_user(:login=>'user', :role=>'admin')
    login_as 'user'
    put :update, :id=>other.id
    assert_redirected_to home_url
    assert_equal other, assigns['user']
  end

  def test_put_should_update_user
    user = create_user('user')
    login_as 'user'
    put :update, :user=>{:email=>'new@example.com'}
    assert_redirected_to home_url
    assert_equal 'new@example.com', user.reload.email
  end

  def test_edit_html
    login_as 'user'
    get :edit, :id=>1
    assert_response :success
    assert_select "form>div>input"
  end

  def test_update_failure
    login_as 'user'
    put :update, :user=>{:password=>'a', :password_confirmation=>'b'}
    assert_response :success
    assert_select "div[id=errorExplanation]"
  end

  def test_destroy_success
    create_user(:login=>'user',:role=>'admin')
    dd = create_user('deletable')
    login_as 'user'
    assert_difference 'User.count', -1 do
      delete :destroy, :id=>dd.id
      assert_redirected_to users_url
    end
  end

  def test_destroy_fails_on_GET
    create_user(:login=>'user',:role=>'admin')
    login_as 'user'
    assert_no_difference 'User.count' do
      get :destroy, :id=>2
      assert_redirected_to users_url
    end

  end

  def test_destroy_fails_if_not_admin
    login_as 'user'
    assert_no_difference 'User.count' do
      delete :destroy, :id=>2
      assert_redirected_to logout_url
    end
  end

private

  def user_params(options={})
    { :user => {
        :login                 => 'quire',
        :email                 => 'quire@example.com',
        :password              => 'quire',
        :password_confirmation => 'quire'
      }.merge!(options)
    }
  end

end
