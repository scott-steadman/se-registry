# == Schema Information
#
# Table name: tags
#
#  id             :bigint           not null, primary key
#  name           :string           not null
#  taggings_count :integer          default(0)
#
class Tag < ApplicationRecord
  delimiter = ' '
end
