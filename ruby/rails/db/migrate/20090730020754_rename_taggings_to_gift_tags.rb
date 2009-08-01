class RenameTaggingsToGiftTags < ActiveRecord::Migration
  def self.up
    rename_table :taggings, :gifts_tags
    rename_column :gifts_tags, :taggable_id, :gift_id
    remove_column :gifts_tags, :taggable_type
  end

  def self.down
    rename_table  :gifts_tags, :taggings
    rename_column :taggings, :gift_id, :taggable_id
    add_column    :taggings, :taggable_type, :string, :default=>'Gift'
  end
end
