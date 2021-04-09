require 'test_helper'

class EventsControllerTest < ActionController::TestCase

  def setup
    @occasion = create_occasion(:user => user, :description => 'Occasion Description')
    @reminder = create_reminder(:user => user, :description => 'Reminder Description')
    @event    = create_event(:user => user, :description => 'Event Description')
  end

  test 'index requires login' do
    logout
    get :index
    assert_redirected_to login_path
  end

  test 'index with no path shows all events' do
    login_as user
    get :index
    assert_response :success

    [@event, @occasion, @reminder].each do |event|
      assert_select "td", event.description, 'event should be rendered'
    end
  end

  test 'index with occasions' do
    ActionController::TestRequest.any_instance.stubs(:path => '/occasions/')

    login_as user
    get :index
    assert_response :success

    [@occasion].each do |event|
      assert_select "td", event.description, 'event should be rendered'
    end

    [@event, @reminder].each do |event|
      assert_select "td", {:count => 0, :text => event.description}, 'event should NOT be rendered'
    end
  end

  test 'index with reminders' do
    ActionController::TestRequest.any_instance.stubs(:path => '/reminders/')

    login_as user
    get :index
    assert_response :success

    [@reminder].each do |event|
      assert_select "td", event.description, 'event should be rendered'
    end

    [@event, @occasion].each do |event|
      assert_select "td", {:count => 0, :text => event.description}, 'event should NOT be rendered'
    end
  end

  test 'show requires login' do
    logout
    get :show, :params => {:id => @event}
    assert_redirected_to login_path
  end

  test 'show' do
    login_as user
    get :show, :params => {:id => @event}
    assert_response :success

    assert_select "a[href='#{edit_event_path(@event)}']", "Edit", 'edit link should be rendered'
  end

  test 'new requires login' do
    logout
    get :new
    assert_redirected_to login_path
  end

  test 'new' do
    login_as user
    get :new
    assert_response :success
  end

  test 'create requires login' do
    logout
    get :create
    assert_redirected_to login_path
  end

  test 'create fails on GET' do
    assert_no_difference 'Event.count' do
      login_as user
      get :create, :params => {:event => {:event_date => Date.today}}
      assert_redirected_to user_events_path(user)
    end
  end

  test 'create' do
    assert_difference 'Event.count', 1 do
      login_as user
      post :create, :params => {:event => {:event_date => Date.today, :description => 'Today'}}
      assert_redirected_to user_events_path(user)
    end
  end

  test 'create fails' do
    assert_no_difference 'Event.count' do
      login_as user
      post :create
      assert_response :success

      assert_select "div[id=errorExplanation]", /value is empty/, 'error message should be rendered'
    end
  end

  test 'edit requires login' do
    logout
    get :edit, :params => {:id => 42}
    assert_redirected_to login_path
  end

  test 'edit' do
    login_as user
    get :edit, :params => {:id => @event}
    assert_response :success

    assert_select "form[action='#{user_event_path(user, @event)}'][method=post]", 1, "edit form should be rendered"
  end

  test 'update requires login' do
    logout
    get :update, :params => {:id => 42}
    assert_redirected_to login_path
  end

  test 'update fails on GET' do
    login_as user
    get :update, :params => {:id => @event, :event => {:description => 'foo'}}
    assert_redirected_to user_events_path(user)

    assert_not_equal 'foo', @event.reload.description, 'event should NOT be updated'
  end

  test 'update' do
    login_as user
    put :update, :params => {:id => @event, :event => {:description => 'foo'}}
    assert_redirected_to user_events_path(user)

    assert_equal 'foo', @event.reload.description, 'event should be updated'
  end

  test 'update fails' do
    login_as user
    put :update, :params => {:id => @event, :event => {:description => nil}}
    assert_response :success

    assert_select 'div[id=errorExplanation]', /Description can't be blank/, 'error message should be rendered'
  end

  test 'destroy requires login' do
    logout
    get :destroy, :params => {:id => 42}
    assert_redirected_to login_path
  end

  test 'destroy fails on GET' do
    assert_no_difference 'Event.count' do
      login_as user
      get :destroy, :params => {:id => @event}
      assert_redirected_to user_events_path(user)
    end
  end

  test 'destroy' do
    assert_difference 'Event.count', -1 do
      login_as user
      delete :destroy, :params => {:id => @event}
      assert_redirected_to user_events_path(user)
    end
  end

end
