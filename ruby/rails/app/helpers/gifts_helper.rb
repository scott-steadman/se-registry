module GiftsHelper

  def links_for(gift)
    return if gift.urls.empty?

    ['(',
      gift.urls.map {|url| link_to('link', url, :target => '_new')}.join(', '),
     ')'
    ].join.html_safe
  end

  def intent(gift)
    return if gift.givings.empty?
    gift.givings.map {|user| user.display_name}.sort.join(', ') << ' Will'
  end

  def tags_for(gift)
    gift.tag_names.map {|tag| tag_or_link(tag)}.join(' ').html_safe
  end

  def tag_or_link(tag)
    if tag != params[:tag]
      link_to(tag, url_for(:tag => tag))
    else
      h(tag)
    end
  end

  def gift_list_actions
    actions  = []

    actions << link_to('New', new_user_gift_path(page_user))
    actions << link_to('View All', user_gifts_path(page_user, :per_page=>@gifts.total_entries)) if @gifts.total_pages > 1
    actions << link_to('Export', user_gifts_path(page_user, :format=>'csv'))

    actions.join(' | ').html_safe
  end

  def gift_actions(gift)
    links = []

    if gift.givable_by?(current_user)
      links << link_to('will', will_user_gift_path(page_user, gift), :method=>:post)
    end

    if gift.given_by?(current_user) or admin_can_remove?(gift)
      links << link_to("won't", wont_user_gift_path(page_user, gift), :data => {:confirm => 'Are you sure?'}, :method=>:delete)
    end

    if gift.editable_by?(current_user)
      links << link_to('edit', edit_user_gift_path(page_user, gift))
      links << link_to('remove', user_gift_path(page_user, gift), :data => {:confirm=>'Are you sure?'}, :method=>:delete)
    end

    links.join('|').html_safe
  end

  def admin_can_remove?(gift)
    current_user.admin? and page_user != current_user and gift.given?
  end
end
