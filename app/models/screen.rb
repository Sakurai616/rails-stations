class Screen < ApplicationRecord
  has_many :sheets, dependent: :destroy
  belongs_to :theater
  has_many :schedules
end
