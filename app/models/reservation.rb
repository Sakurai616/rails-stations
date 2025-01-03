class Reservation < ApplicationRecord   
  before_save :convert_date_to_local

  belongs_to :schedule
  belongs_to :sheet
  has_many :screens

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, {presence: true, format: { with: VALID_EMAIL_REGEX }}
    validates :date, presence: true
    validates :schedule_id, presence: true
    validates :sheet_id, presence: true
    validates :name, presence: true
    validate :unique_sheet_per_schedule

    private

    # 重複チェックのロジック
    def unique_sheet_per_schedule
      if Reservation.where(schedule_id: schedule_id, sheet_id: sheet_id, date: date).where.not(id: id).exists?
        errors.add(:base, "その座席はすでに予約済みです。")
      end
    end

  # UTCに変換されないようローカルタイムに変換して保存
  def convert_date_to_local
    self.date = Time.zone.parse(date.to_s) if date.present?
  end
end