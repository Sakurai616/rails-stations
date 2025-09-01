class Like < ApplicationRecord
    belongs_to :user
    belongs_to :movie

    validates :user_id, uniqueness: { scope: :movie_id, message: 'はすでにこの映画をお気に入りにしています' }
    validates :movie_id, presence: true

    # ユーザーが映画をお気に入りにしているかどうかを確認するメソッド
    def self.liked_by_user?(user, movie)
      exists?(user_id: user.id, movie_id: movie.id)
    end
end
