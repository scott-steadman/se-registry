class ActsAsTaggableOnMigration < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.references :tag

      # You should make sure that the column created is
      # long enough to store the required class names.
      t.references :taggable, :polymorphic => true
      t.references :tagger, :polymorphic => true

      # Limit is created to prevent MySQL error on index
      # length for MyISAM table type: http://bit.ly/vgW2Ql
      t.string :context, :limit => 128

      t.datetime :created_at
    end

    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type, :context]

    migrate_data
  end

  def self.down
    drop_table :taggings
  end

  def self.migrate_data
    execute %{
      INSERT INTO taggings (tag_id, taggable_id, taggable_type, tagger_id, tagger_type)

      SELECT tag_id           tag_id,
             gift_id          taggable_id,
             'Gift'           taggable_type,
             gifts.user_id    tagger_id,
             'User'           tagger_type

        FROM gifts_tags

      LEFT JOIN gifts on gifts.id = gift_id;
    }
  end
end
