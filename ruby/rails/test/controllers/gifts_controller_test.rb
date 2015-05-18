require 'test_helper'

class GiftsControllerTest < ActionController::TestCase

  test 'index requires login' do
    get :index
    assert_redirected_to login_url
  end

  test 'index' do
    login_as user = create_user
    create_gift(:user=>user)
    create_gift(:user=>user)
    get :index
    assert_response :success
    assert_equal 2, assigns['gifts'].size
  end

  test 'index with per_page param' do
    login_as user = create_user
    create_gift(:user=>user)
    create_gift(:user=>user)
    get :index, :per_page => 1
    assert_response :success
    assert_equal 1, assigns['gifts'].size
  end

  test 'index with tag param' do
    login_as user = create_user
    create_gift(:user=>user, :tag_names => 'foo')
    create_gift(:user=>user, :tag_names => 'bar')
    get :index, :tag => 'foo'
    assert_response :success
    assert_equal 1, assigns['gifts'].size
  end

  test 'index with csv format' do
    user = create_user('user')
    gift = create_gift(:user => user, :description => 'one', :price => 1.00, :multi => false)
    giver = create_user('giver')
    giver.give(gift)
    login_as user
    get :index, :format => 'csv'
    assert_response :success
    assert_equal 2, @response.body.split(/\r\n/m).size, 'header, gift lines should be returned'
  end

  test 'new requires login' do
    get :new
    assert_redirected_to login_url
  end

  test 'new' do
    login_as create_user
    get :new
    assert_response :success
    assert_not_nil assigns['gift']
  end

  # Issue 85
  test 'new gift for other' do
    other = create_user('other')
    login_as create_user
    get :new, :user_id => other
    assert_response :success
    assert assigns['gift'].hidden?,                      'gifts created for others should be hidden'
    assert assigns['gift'].tag_names.include?('secret'), 'gifts created for others should tagged secret'
  end

  test 'create requires login' do
    get :create
    assert_redirected_to login_url
  end

  test 'create fails on GET' do
    login_as user = create_user
    assert_no_difference 'Gift.count' do
      get :create, gift_params
    end
    assert_template :new
  end

  test 'create' do
    login_as user = create_user
    assert_difference 'Gift.count', 1 do
      post :create, gift_params
    end
    assert_redirected_to user_gifts_path(user)
  end

  test 'create gift for other' do
    other = create_user('other')
    user  = create_user
    login_as user
    post :create, {:user_id => other}.merge!(gift_params(:hidden => true))
    assert_redirected_to user_gifts_path(other)

    gift = other.gifts.first
    assert gift.hidden?,         'gifts created for others should be hidden'
    assert gift.given_by?(user), 'gifts created for others should be given by creator'
  end

  test 'create with error' do
    login_as user = create_user
    post :create
    assert_template :new
    assert_select "form>div[class='errorExplanation']"
  end

  test 'edit requires login' do
    get :edit
    assert_redirected_to login_url
  end

  test 'edit' do
    login_as user = create_user
    gift = create_gift(:user=>user)
    get :edit, :id=>gift.id
    assert_response :success
    assert_not_nil assigns['gift']
  end

  test 'update requires login' do
    get :update
    assert_redirected_to login_url
  end

  test 'update fails on GET' do
    login_as user = create_user
    gift = create_gift(:user=>user)
    get :update, :id=>gift.id, :gift=>gift.attributes
    assert_response :success
    assert_template :edit
  end

  test 'update' do
    login_as user = create_user
    gift = create_gift(:user=>user)
    put :update, :id=>gift.id, :gift=>{:url=>'new url'}
    assert_redirected_to user_gifts_path(user)
    assert_equal 'new url', gift.reload.url
  end

  test 'update fails with bad data' do
    login_as user = create_user
    gift = create_gift(:user => user)
    put :update, :id => gift.id, :gift => {:description => ''}
    assert_response :success
    assert_template :edit
  end

  test 'destroy requires login' do
    delete :destroy
    assert_redirected_to login_url
  end

  test 'destroy fails on GET' do
    login_as user = create_user
    gift = create_gift(:user=>user)
    assert_no_difference 'Gift.count' do
      get :destroy, :id=>gift.id
    end
    assert_redirected_to user_gifts_path(user)
  end

  test 'destroy' do
    user = create_user
    gift = create_gift(:user => user)
    login_as user
    assert_difference 'Gift.count', -1 do
      delete :destroy, :id => gift.id
    end
    assert_redirected_to user_gifts_path(user)
  end

  test 'will requires login' do
    post :will
    assert_redirected_to login_url
  end

  test 'will fails on GET' do
    login_as user = create_user
    user.befriend(friend = create_user('friend'))
    gift = create_gift(:user=>friend)
    assert_no_difference 'Giving.count' do
      get :will, :user_id=>friend.id, :id=>gift.id
    end
    assert_redirected_to user_gifts_path(friend)
  end

  test 'will' do
    login_as user = create_user
    user.befriend(friend = create_user('friend'))
    gift = create_gift(:user=>friend)
    assert_difference 'Giving.count', 1 do
      post :will, :user_id=>friend.id, :id=>gift.id
    end
    assert_redirected_to user_gifts_path(friend)
  end

  test 'wont requires login' do
    delete :wont
    assert_redirected_to login_url
  end

  test 'wont fails on GET' do
    login_as user = create_user
    user.befriend(friend = create_user('friend'))
    gift = create_gift(:user=>friend)
    user.give(gift)
    assert_no_difference 'Giving.count' do
      get :wont, :user_id=>friend.id, :id=>gift.id
    end
    assert_redirected_to user_gifts_path(friend)
  end

  test 'wont' do
    login_as user = create_user
    user.befriend(friend = create_user('friend'))
    gift = create_gift(:user=>friend)
    user.give(gift)
    assert_difference 'Giving.count', -1 do
      delete :wont, :user_id=>friend.id, :id=>gift.id
    end
    assert_redirected_to user_gifts_path(friend)
  end

  test 'admin can remove others givings' do
    login_as create_user(:role=>'admin')
    other = create_user('other')
    other.befriend(friend = create_user('friend'))
    gift = create_gift(:user=>other)
    friend.give(gift)

    assert_difference 'Giving.count', -1 do
      delete :wont, :user_id=>other.id, :id=>gift.id
    end
    assert_redirected_to user_gifts_path(other)
  end

  test 'non-admin cannot remove others givings' do
    login_as create_user
    other = create_user('other')
    other.befriend(friend = create_user('friend'))
    gift = create_gift(:user=>other)
    friend.give(gift)

    assert_no_difference 'Giving.count' do
      delete :wont, :user_id=>other.id, :id=>gift.id
    end
    assert_redirected_to user_gifts_path(other)
  end

  # Issue 95
  test 'no spaces in tags' do
    login_as user = create_user
    gift = create_gift(:user => user)
    put :update, :id => gift.id, :gift => {:tag_names => 'one two'}
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
