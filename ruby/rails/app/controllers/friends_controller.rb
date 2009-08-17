class FriendsController < ApplicationController

  before_filter :require_user

  # GET /friends
  # GET /friends.xml
  def index
    @friends = friends.paginate :page=>page, :per_page=>per_page, :order=>order

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml=>@friends }
    end
  end

  # POST /friends
  # POST /friends.xml
  def create
    if friends.include?(friend)
      flash[:notice] = "#{you_or_user} already friends with #{friend.login}."
      redirect_to users_path
      return
    end

    friends << friend

    respond_to do |format|
      flash[:notice] = "#{you_or_user} now friends with #{friend.login}."
      format.html { redirect_to user_friends_path(current_user) }
      format.xml  { render :xml=>friend, :status=>:created, :location=>friend }
    end
  end

  # DELETE /friends/1
  # DELETE /friends/1.xml
  def destroy
    friends.delete(friend)

    respond_to do |format|
      format.html { redirect_to user_friends_path(current_user) }
      format.xml  { head :ok }
    end
  end

private

  def friends
    page_user.friends
  end

  def friend_id
    params[:friend_id] || params[:id]
  end

  def friend
    @friend ||= User.find(friend_id)
  end

  def order
    'login'
  end

  def you_or_user
    page_user == current_user ? 'You are' : "#{page_user.login} is"
  end

end
