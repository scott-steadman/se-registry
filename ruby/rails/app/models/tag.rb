# == Schema Information
# Schema version: 10
#
# Table name: tags
#
#  id   :integer(4)      not null, primary key
#  name :string(32)
#
class Tag < ActiveRecord::Base
  delimiter = ' '
end
