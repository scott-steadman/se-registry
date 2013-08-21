module GiftsHelper

  def description_of(gift)
    if gift.url.blank?
      gift.description
    else
      link_to(gift.description, gift.url, :target => '_new')
    end
  end

  def intent(gift)
    return if gift.givings.empty?
    gift.givings.map {|user| user.display_name}.sort.join(', ') << ' Will'
  end

  def tags_for(gift)
    gift.tag_names.map {|tag| tag_or_link(tag)}.join(' ')
  end

  def tag_or_link(tag)
    if tag != params[:tag]
      link_to tag, url_for(:overwrite_params => {:tag => tag})
    else
      tag
    end
  end

  def gift_actions(gift)
    links = []

    if gift.givable_by?(current_user)
      links << link_to('will', will_user_gift_path(page_user, gift), :method=>:post)
    end

    if gift.given_by?(current_user) or admin_can_remove?
      links << link_to("won't", wont_user_gift_path(page_user, gift), :method=>:delete)
    end

    if gift.editable_by?(current_user)
      links << link_to('edit', edit_user_gift_path(page_user, gift))
      links << link_to('remove', user_gift_path(page_user, gift), :confirm=>'Are you sure?', :method=>:delete)
    end

    links.join('|')
  end

  def admin_can_remove?
    current_user.admin? and page_user != current_user and gift.given?
  end
end
