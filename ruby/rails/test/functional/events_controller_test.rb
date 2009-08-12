require File.dirname(__FILE__) + '/../test_helper'

class EventsControllerTest < ActionController::TestCase

  def setup
    @user = create_user('user')
    @occasion = create_occasion(:user=>@user)
    @reminder = create_reminder(:user=>@user)
    @event = create_event(:user=>@user)
    login_as('user')
  end

  test 'index with no path' do
    get :index
    assert_response :success
    assert_equal %w[Event Occasion Reminder], assigns(:events).map{|ii| ii.event_type}.sort
  end

  test 'index with occasions' do
    @request.stubs(:path).returns('/occasions/')
    get :index
    assert_response :success
    assert_equal %w[Occasion], assigns(:events).map{|ii| ii.event_type}.sort
  end

  test 'index with reminders' do
    @request.stubs(:path).returns('/reminders/')
    get :index
    assert_response :success
    assert_equal %w[Reminder], assigns(:events).map{|ii| ii.event_type}.sort
  end

  test 'new' do
    get :new
    assert_response :success
  end

  test 'create' do
    assert_difference('Event.count') do
      post :create, :event => {:event_date => Date.today}
    end
    assert_redirected_to user_events_path(@user)
  end

  test 'show' do
    get :show, :id => @event
    assert_response :success
    assert_equal @event, assigns(:event)
  end

  test 'edit' do
    get :edit, :id => @event
    assert_response :success
    assert_equal @event, assigns(:event)
  end

  test 'update' do
    put :update, :id => @event, :event => {:description => 'foo'}
    assert_redirected_to user_events_path(@user)
    assert_equal 'foo', Event.find(@event.id).description
  end

  test 'destroy' do
    assert_difference('Event.count', -1) do
      delete :destroy, :id => @event
    end

    assert_redirected_to user_events_path(@user)
  end
end
