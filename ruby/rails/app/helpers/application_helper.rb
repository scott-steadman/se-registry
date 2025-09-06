module ApplicationHelper

  def stylesheet_link_tag(*sources)
    opts = sources.extract_options!

    base_dir = Rails.root.join('app', 'assets', 'stylesheets')
    case sources.first
      when :v1
        sources = Dir.glob(base_dir.join('v1', '*.css')).map { |f| "v1/#{File.basename(f, '.css')}" }
      when :v2
        sources = Dir.glob(base_dir.join('v2', '*.css')).map { |f| "v2/#{File.basename(f, '.css')}" }
    end

    super(*sources, opts)
  end

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

  def post_link_to(url, options={})
    text = options.delete(:text) || 'Post'
    link_to text, url, options.merge(:rel => 'nofollow', :data => {:turbo_method => :post})
  end

  def delete_link_to(url, options={})
    text = options.delete(:text)       || 'Delete'
    confirm = options.delete(:confirm) || 'Are you sure you want to delete this?'
    link_to text, url, options.merge(:rel => 'nofollow', :data => {:turbo_method => :delete, :turbo_confirm => confirm})
  end

  def external_link_to(url)
    # we don't want www. or .com
    domain = URI.parse(url).host.split('.')[-2]
    link_to domain, url, :rel => 'nofollow noopener', :target => '_new'
  end

end
