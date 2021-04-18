module GiftsHelper

  def intent(gift)
    gift = gift.becomes(Gift::ForGiving)
    return if gift.givings.empty?
    gift.givings.map {|user| user.display_name}.sort.join(', ') << ' Will'
  end

  def tag_or_link(tag)
    if tag != params[:tag]
      link_to(tag, url_for(:tag => tag))
    else
      h(tag)
    end
  end

  def admin_can_remove?(gift)
    current_user.admin? and page_user != current_user and gift.given?
  end
end
