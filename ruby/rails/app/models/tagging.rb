# == Schema Information
#
# Table name: taggings
#
#  id            :bigint           not null, primary key
#  tag_id        :bigint
#  taggable_type :string
#  taggable_id   :bigint
#  tagger_type   :string
#  tagger_id     :bigint
#  context       :string
#
class Tagging < ApplicationRecord
end
