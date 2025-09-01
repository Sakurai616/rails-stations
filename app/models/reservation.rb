class Reservation < ApplicationRecord
  belongs_to :schedule
  belongs_to :sheet
  belongs_to :user

  before_validation :set_user_info, if: -> { user.present? }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, { presence: true, format: { with: VALID_EMAIL_REGEX } }
  validates :date, presence: true
  validates :schedule_id, presence: true
  validates :sheet_id, presence: true
  validates :name, presence: true
  validate :unique_reservation

  private

  def unique_reservation
    return unless Reservation.where(schedule_id: schedule_id, sheet_id: sheet_id, date: date).where.not(id: id).exists?

    errors.add(:base, 'その座席はすでに予約済みです。')
  end

  # ユーザ情報があれば予約情報にセット
  def set_user_info
    self.name = user.name
    self.email = user.email
  end
end
