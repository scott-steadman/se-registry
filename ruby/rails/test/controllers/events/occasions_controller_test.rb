require 'test_helper'

class Events::OccasionsControllerTest < ActionController::TestCase

  test 'index requires login' do
    logout
    get :index
    assert_redirected_to login_path
  end

  test 'index v2 with no occasions' do
    login_as user(:ui_version => 2)
    get :index
    assert_response :success
  end

  test 'index with no path only shows occasions' do
    [occasion, event, reminder] # create events

    login_as user
    get :index
    assert_response :success

    [occasion].each do |ii|
      assert_select "td", ii.description, 'event should be rendered'
    end

    [event, reminder].each do |ii|
      assert_select "td", {:count => 0, :text => ii.description}, 'event should NOT be rendered'
    end
  end

  test 'create fails on GET' do
    assert_no_difference 'Event.count' do
      login_as user
      get :create, :params => {:occasion => {:date => Date.today}}
      assert_redirected_to user_occasions_path(user)
    end
  end

  test 'create takes occasion parameter' do
    assert_difference 'Event.count', 1 do
      login_as user
      post :create, :params => {:occasion => {:date => Date.today, :description => 'Today'}}
      assert_redirected_to user_occasions_path(user)
    end
  end

  test 'update fails on GET' do
    login_as user
    get :update, :params => {:id => occasion, :occasion => {:description => 'foo'}}
    assert_redirected_to user_occasions_path(user)

    assert_not_equal 'foo', occasion.reload.description, 'occasion should NOT be updated'
  end

  test 'destroy fails on GET' do
    occasion # create occasion

    assert_no_difference 'Event.count' do
      login_as user
      get :destroy, :params => {:id => occasion}
      assert_redirected_to user_occasions_path(user)
    end
  end

private

  def occasion
    @occasion ||= create_occasion(:user => user, :description => 'Occasion Description')
  end

  def reminder
    @reminder ||= create_reminder(:user => user, :description => 'Reminder Description')
  end

  def event
    @event ||= create_event(:user => user, :description => 'Event Description')
  end


end # class Events::OccasionsControllerTest
