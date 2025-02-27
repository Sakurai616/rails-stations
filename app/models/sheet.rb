class Sheet < ApplicationRecord
  has_many :reservations, dependent: :destroy
  belongs_to :screen

  def name
    "#{row}#{column}"
  end
end
