require 'test_helper'

class Events::RemindersControllerTest < ActionController::TestCase

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

  test 'index with no path only shows reminders' do
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

  test 'create fails on GET' do
    assert_no_difference 'Event.count' do
      login_as user
      get :create, :params => {:reminder => {:date => Date.today}}
      assert_redirected_to user_reminders_path(user)
    end
  end

  test 'create takes reminder parameter' do
    assert_difference 'Event.count', 1 do
      login_as user
      post :create, :params => {:reminder => {:date => Date.today, :description => 'Today'}}
      assert_redirected_to user_reminders_path(user)
    end
  end

  test 'update fails on GET' do
    login_as user
    get :update, :params => {:id => @reminder, :reminder => {:description => 'foo'}}
    assert_redirected_to user_reminders_path(user)

    assert_not_equal 'foo', @reminder.reload.description, 'reminder should NOT be updated'
  end

  test 'destroy fails on GET' do
    assert_no_difference 'Event.count' do
      login_as user
      get :destroy, :params => {:id => @reminder}
      assert_redirected_to user_reminders_path(user)
    end
  end

end # class Events::RemindersControllerTest
