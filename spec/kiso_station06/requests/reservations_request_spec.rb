require 'rails_helper'

RSpec.describe 'Reservations', type: :request do
  let!(:user) do
    User.create(name: 'Test User', email: 'test@example.com', password: 'password', password_confirmation: 'password')
  end
  let!(:movie) do
    Movie.create!(
      name: 'インセプション',
      year: 2010,
      description: '夢の中に潜入するスリラー映画。',
      image_url: 'https://example.com/inception.jpg',
      is_showing: true
    )
  end
  let!(:theater) { Theater.create!(name: 'TOHOシネマズ新宿') }
  let!(:screen) { Screen.create!(theater: theater, number: 1) }
  let!(:schedule) { Schedule.create!(movie: movie, screen: screen, start_time: '10:00', end_time: '12:30') }
  let!(:sheet) { Sheet.create!(screen: screen, row: 'A', column: 1) }
  let!(:reservation) { Reservation.create(user: user, schedule: schedule, sheet: sheet, date: Date.today) }

  before do
    sign_in user
  end

  context '予約の更新' do
    let!(:new_schedule) { Schedule.create!(movie: movie, screen: screen, start_time: '14:00', end_time: '16:30') }
    let!(:new_sheet) { Sheet.create!(screen: screen, row: 'B', column: 2) }

    it '予約情報が正常に更新される' do
      patch reservation_path(reservation),
            params: { reservation: { schedule_id: new_schedule.id, sheet_id: new_sheet.id, date: Date.tomorrow } }

      reservation.reload
      expect(reservation.schedule_id).to eq(new_schedule.id)
      expect(reservation.sheet_id).to eq(new_sheet.id)
      expect(reservation.date).to eq(Date.tomorrow)
      expect(flash[:notice]).to eq('予約情報を更新しました')
      expect(response).to redirect_to(user_path(user))
    end

    it '予約情報が無効な場合、バリデーションエラーが発生する' do
      patch reservation_path(reservation), params: { reservation: { schedule_id: nil, sheet_id: nil, date: nil } }

      expect(response).to render_template(:edit)
    end
  end

  context '予約の削除' do
    it '予約が正常に削除される' do
      expect do
        delete reservation_path(reservation)
      end.to change(Reservation, :count).by(-1)

      expect(flash[:notice]).to eq('予約をキャンセルしました')
      expect(response).to redirect_to(user_path(user))
    end

    it '不正なアクセスで予約が削除できない' do
      other_user = User.create(name: 'Other User', email: 'other@example.com', password: 'password',
                               password_confirmation: 'password')
      sign_in other_user

      delete reservation_path(reservation)

      expect(response).to redirect_to(movies_path)
      expect(flash[:alert]).to eq('不正なアクセスです')
    end
  end
end
