class CreateLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true

      t.index [:user_id, :movie_id], unique: true, name: 'index_likes_on_user_and_movie'
      t.timestamps
    end
  end
end
