class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.boolean :published, null: false, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :posts, :slug, unique: true
    add_index :posts, [ :published, :created_at ]
  end
end
