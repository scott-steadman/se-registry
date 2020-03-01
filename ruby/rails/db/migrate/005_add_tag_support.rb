class AddTagSupport < ActiveRecord::Migration[6.0]

  def change
    create_table :tags do |t|
      t.string  :name,            :null => false
      t.integer :taggings_count,  :default => 0

      t.index  :name, :unique => true
    end

    create_table :taggings do |t|
      t.belongs_to :tag,      :foreign_key => true
      t.references :taggable, :polymorphic => true
      t.references :tagger,   :polymorphic => true, :index => false
      t.string     :context

      t.index     [:taggable_id, :taggable_type, :context]
    end
  end

end
