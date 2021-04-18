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

  def delete_link_to(text='Delete', url)
    link_to text, url, :method => :delete, :data => {:confirm => 'Are you sure?'}
  end

end
