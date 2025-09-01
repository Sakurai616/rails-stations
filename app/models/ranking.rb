class Ranking < ApplicationRecord
  belongs_to :movie

  validates :movie_id, :reservation_count, :date, presence: true
  validates :date, uniqueness: { scope: :movie_id }
  validates :reservation_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
