module ApplicationHelper

  def possessivize(name)
    "#{name}'#{'s' if 's' != name[-1,1]}"
  end

  def sortable_column_header(title, column)
    dir = ("#{column} ASC" == order) ? 'DESC' : 'ASC'
    link_to title, url_for(:order => "#{column} #{dir}")
  end

  def link_to_function(text, function, html_options={})
    function += ';return false;' unless function =~ /return false/
    link_to(text, '#', html_options.merge(:onClick => function))
  end

  def delete_link_to(text='Delete', url, options)
    options ||= {}
    link_to text, url, options.merge(:method => :delete, :rel => 'nofollow', :data => {:confirm => 'Are you sure?'})
  end

  def external_link_to(url)
    # we don't want www. or .com
    domain = URI.parse(url).host.split('.')[-2]
    link_to domain, url, :rel => 'nofollow', :target => '_new'
  end

end
