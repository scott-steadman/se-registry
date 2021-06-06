class FriendsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_action :require_user

  # GET /friends
  # GET /friends.xml
  def index
    @friends = friends.includes(:gifts).order(order).paginate :page => page, :per_page => per_page
  end

  # POST /friends
  # POST /friends.xml
  def create
    redirect_to user_friends_path(page_user) and return unless request.post?

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

    flash[:notice] = "#{you_or_user} now friends with #{friend.login}."
    redirect_to user_friends_path(current_user)
  end

  # DELETE /friends/1
  # DELETE /friends/1.xml
  def destroy
    redirect_to user_friends_path(page_user) and return unless request.delete?

    friends.delete(friend)

    redirect_to user_friends_path(current_user)
  end

  # GET /friends/1/export
  def export
    require 'csv'
    data = CSV.generate(:row_sep => "\r\n") do |csv|
      csv << ['Friend/Tags','Description','Multiples','Price', 'Giver']
      current_user.friends.each do |friend|
        csv << [friend.display_name]
        friend.gifts.each do |gift|
          csv << [
            gift.tag_names,
            gift.description,
            gift.multi,
            number_to_currency(gift.price),
            gift.givings.map {|ii| ii.display_name}.join(' & ')
          ]
        end
      end
    end
    send_data(data, {:filename => 'friends and gifts.csv', :type => 'text/csv', :disposition => 'inline'})
  end

private

  def friends
    page_user.friends
  end

  def friend_id
    @friend_id ||= params[:friend_id] || params[:id]
  end

  def friend_login
    @friend_login ||= params[:friend_login]
  end

  def friend
    @friend ||= if friend_login
                  User.where("login = ?", friend_login).first
                else
                  User.find(friend_id)
                end
  end

  def order
    'login'
  end

  def you_or_user
    page_user == current_user ? 'You are' : "#{page_user.login} is"
  end

end
