module GiftsHelper

  def description_of(gift)
    gift.url.blank? ? h(gift.description) : link_to(h(gift.description), gift.url, :target=>'_new')
  end

  def intent(gift)
    return if gift.givings.empty?
    h(gift.givings.map {|user| user.display_name}.sort.join(', ') << ' Will')
  end

  def gift_actions(gift)
    links = []

    if gift.givable_by?(current_user)
      links << link_to('will', will_user_gift_path(page_user, gift), :method=>:post)
    end

    if gift.given_by?(current_user) ||
      (current_user.admin? && page_user != current_user && gift.given?)
      links << link_to("won't", wont_user_gift_path(page_user, gift), :method=>:delete)
    end

    if gift.editable_by?(current_user)
      links << link_to('edit', edit_user_gift_path(page_user, gift))
      links << link_to('remove', user_gift_path(page_user, gift), :confirm=>'Are you sure?', :method=>:delete)
    end

    links.join('|')
  end

end
