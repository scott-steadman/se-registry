# Load the rails application
require File.expand_path('../application', __FILE__)

# add back methods removed in Rails 3.2
# These methods are used by acts_as_taggable
class Class

  def write_inheritable_attribute(name, value=nil)
    class_attribute name
    send("#{name}=", value)
  end

  def class_inheritable_reader(*names)
    class_attribute *names
  end
end

# Initialize the rails application
Registry::Application.initialize!
