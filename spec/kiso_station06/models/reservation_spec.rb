require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:user) { create(:user, name: 'test', email: 'test@example.com') }
  let(:schedule) { create(:schedule) }
  let(:sheet) { create(:sheet) }
  let(:reservation) { build(:reservation, user: user, schedule: schedule, sheet: sheet, date: Date.today) }

  describe 'バリデーション' do
    context 'ユーザー情報がある場合' do
      it 'ユーザーの名前とメールアドレスがセットされること' do
        reservation.valid?
        expect(reservation.name).to eq(user.name)
        expect(reservation.email).to eq(user.email)
      end
    end

    context 'メールアドレス' do
      # it '無効なメールアドレスの場合、無効であること' do
      #   reservation.email = 'invalid_email'
      #   reservation.valid?
      #   expect(reservation.errors[:email]).to include("は不正な値です")
      # end

      it '有効なメールアドレスの場合、正しいこと' do
        reservation.email = 'valid@example.com'
        expect(reservation).to be_valid
      end
    end

    context '予約情報' do
      it '予約日がない場合、無効であること' do
        reservation.date = nil
        reservation.valid?
        expect(reservation.errors[:date]).to include('を入力してください')
      end

      it '座席が指定されていない場合、無効であること' do
        reservation.sheet_id = nil
        reservation.valid?
        expect(reservation.errors[:sheet_id]).to include('を入力してください')
      end

      it 'スケジュールが指定されていない場合、無効であること' do
        reservation.schedule_id = nil
        reservation.valid?
        expect(reservation.errors[:schedule_id]).to include('を入力してください')
      end
    end

    context '座席の重複予約' do
      it '同じ座席・同じ日時に予約が重複している場合、エラーが発生すること' do
        create(:reservation, schedule: schedule, sheet: sheet, date: Date.today)
        reservation = build(:reservation, schedule: schedule, sheet: sheet, date: Date.today)
        reservation.valid?
        expect(reservation.errors[:base]).to include('その座席はすでに予約済みです。')
      end

      it '同じ座席・異なる日時なら重複しないこと' do
        create(:reservation, schedule: schedule, sheet: sheet, date: Date.today)
        reservation.date = Date.today + 1.day
        expect(reservation).to be_valid
      end
    end
  end

  describe 'コールバック' do
    it 'ユーザー情報がある場合、名前とメールアドレスがセットされること' do
      reservation = build(:reservation, user: user, schedule: schedule, sheet: sheet)
      reservation.valid?
      expect(reservation.name).to eq(user.name)
      expect(reservation.email).to eq(user.email)
    end
  end
end
