class FriendsController < ApplicationController
  include ActionView::Helpers::NumberHelper

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
    unless request.post?
      redirect_to user_friends_path(page_user)
      return
    end

    if current_user == friend
      flash[:notice] = "You can't befriend yourself."
      redirect_to users_path
      return
    end

    if friends.include?(friend)
      flash[:notice] = "#{you_or_user} already friends with #{friend.login}."
      redirect_to users_path
      return
    end

    page_user.befriend(friend)

    respond_to do |format|
      flash[:notice] = "#{you_or_user} now friends with #{friend.login}."
      format.html { redirect_to user_friends_path(current_user) }
      format.xml  { render :xml=>friend, :status=>:created, :location=>friend }
    end
  end

  # DELETE /friends/1
  # DELETE /friends/1.xml
  def destroy
    redirect_to user_friends_path(page_user) and return unless request.delete?

    friends.delete(friend)

    respond_to do |format|
      format.html { redirect_to user_friends_path(current_user) }
      format.xml  { head :ok }
    end
  end

  # GET /friends/1/export
  def export
    require 'csv'
    data = ''
    CSV::Writer.generate(data, ',', "\r\n") do |writer|
      writer << ['Friend/Tags','Description','Multiples','Price', 'Giver']
      current_user.friends.each do |friend|
        writer << [friend.display_name]
        friend.gifts.each do |gift|
          writer << [
            gift.tag_names,
            gift.description,
            gift.multi,
            number_to_currency(gift.price),
            gift.givings.map {|ii| ii.display_name}.join(' & ')
          ]
        end
      end
    end
    send_data(data, {:filename => 'gifts.csv', :type => 'text/csv', :disposition => 'inline'})
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
