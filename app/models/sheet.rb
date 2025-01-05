class Sheet < ApplicationRecord
  has_many :reservations, dependent: :destroy

  def name
    "#{row}#{column}"
  end
end
