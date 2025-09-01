class Sheet < ApplicationRecord
  has_many :reservations, dependent: :destroy
  belongs_to :screen

  validates :column, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :row, presence: true, format: { with: /\A[A-Z]+\z/ }
  validates :screen_id, presence: true, uniqueness: { scope: %i[row column] }

  def name
    "#{row}#{column}"
  end
end
