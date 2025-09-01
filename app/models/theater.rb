class Theater < ApplicationRecord
  has_many :screens, dependent: :destroy

  validates :name, presence: true
end
