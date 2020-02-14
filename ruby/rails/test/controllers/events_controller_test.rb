require 'test_helper'

class EventsControllerTest < ActionController::TestCase

  def setup
    @user = create_user('user')
    @occasion = create_occasion(:user => @user, :description => 'Occasion')
    @reminder = create_reminder(:user => @user, :description => 'Reminder')
    @event = create_event(:user => @user, :description => 'Event')
  end

  test 'index requires login' do
    logout
    get :index
    assert_redirected_to login_path
  end

  test 'index with no path' do
    get :index
    assert_response :success
    assert_equal %w[Event Occasion Reminder], assigns(:events).map{|ii| ii.event_type}.sort
  end

  test 'index with occasions' do
    ActionController::TestRequest.any_instance.stubs(:path => '/occasions/')
    get :index
    assert_response :success
    assert_equal %w[Occasion], assigns(:events).map{|ii| ii.event_type}.sort
  end

  test 'index with reminders' do
    ActionController::TestRequest.any_instance.stubs(:path => '/reminders/')
    get :index
    assert_response :success
    assert_equal %w[Reminder], assigns(:events).map{|ii| ii.event_type}.sort
  end

  test 'show requires login' do
    logout
    get :show, :params => {:id => @event}
    assert_redirected_to login_path
  end

  test 'show' do
    get :show, :params => {:id => @event}
    assert_response :success
    assert_equal @event, assigns(:event)
  end

  test 'new requires login' do
    logout
    get :new
    assert_redirected_to login_path
  end

  test 'new' do
    get :new
    assert_response :success
    assert_not_nil assigns['event']
  end

  test 'create requires login' do
    logout
    get :create
    assert_redirected_to login_path
  end

  test 'create fails on GET' do
    assert_no_difference 'Event.count' do
      get :create, :params => {:event => {:event_date => Date.today}}
    end
    assert_redirected_to user_events_path(@user)
  end

  test 'create' do
    assert_difference 'Event.count', 1 do
      post :create, :params => {:event => {:event_date => Date.today, :description => 'Today'}}
    end
    assert_redirected_to user_events_path(@user)
  end

  test 'create fails' do
    assert_no_difference 'Event.count' do
      post :create
      assert_response :success
      assert_match escape('value is empty'), @response.body
    end
  end

  test 'edit requires login' do
    logout
    get :edit, :params => {:id => 42}
    assert_redirected_to login_path
  end

  test 'edit' do
    get :edit, :params => {:id => @event}
    assert_response :success
    assert_equal @event, assigns(:event)
  end

  test 'update requires login' do
    logout
    get :update, :params => {:id => 42}
    assert_redirected_to login_path
  end

  test 'update fails on GET' do
    get :update, :params => {:id => @event, :event => {:description => 'foo'}}
    assert_redirected_to user_events_path(@user)
    assert_equal 'Event', Event.find(@event.id).description
  end

  test 'update' do
    put :update, :params => {:id => @event, :event => {:description => 'foo'}}
    assert_redirected_to user_events_path(@user)
    assert_equal 'foo', Event.find(@event.id).description
  end

  test 'update fails' do
    put :update, :params => {:id => @event, :event => {:description => nil}}
    assert_response :success
    assert_match escape("can't be blank"), @response.body
  end


  test 'destroy requires login' do
    logout
    get :destroy, :params => {:id => 42}
    assert_redirected_to login_path
  end

  test 'destroy fails on GET' do
    assert_no_difference 'Event.count' do
      get :destroy, :params => {:id => @event}
    end
    assert_redirected_to user_events_path(@user)
  end

  test 'destroy' do
    assert_difference 'Event.count', -1 do
      delete :destroy, :params => {:id => @event}
    end
    assert_redirected_to user_events_path(@user)
  end

end
