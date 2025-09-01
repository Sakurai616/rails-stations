class Screen < ApplicationRecord
  has_many :sheets, dependent: :destroy
  belongs_to :theater
  has_many :schedules

  validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 },
                     uniqueness: { scope: :theater_id }
  validates :theater_id, presence: true
end
