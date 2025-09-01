require 'rails_helper'
require 'base64'

RSpec.describe ReservationMailer, type: :mailer do
  describe 'reminder_email' do
    let(:user) do
      User.create!(name: 'John Doe', email: 'john.doe@example.com', password: 'password',
                   password_confirmation: 'password')
    end
    let(:movie) do
      Movie.create!(name: 'シン・エヴァンゲリオン劇場版:||', year: '2021', is_showing: true,
                    description: 'エヴァンゲリオン新劇場版、完結。',
                    image_url: 'https://dummyimage.com/200x300/000/fff&text=シン・エヴァンゲリオン劇場版:||')
    end
    let(:theater) { Theater.create!(name: 'シネマシティ') }
    let(:screen) { Screen.create!(theater: theater, number: 1) }
    let(:schedule) do
      Schedule.create!(movie: movie, screen: screen, start_time: '2025-03-13 10:00:00', end_time: '2025-03-13 12:00:00')
    end
    let(:sheet) { Sheet.create!(screen: screen, row: 'A', column: 1) }
    let(:reservation) do
      Reservation.create!(schedule: schedule, sheet: sheet, email: user.email, name: user.name, date: Date.today,
                          user: user)
    end

    it 'リマインドメールを送信する' do
      # メールを送信
      email = ReservationMailer.reminder_email(reservation).deliver_now

      expect(email.to).to eq([user.email]) # 送信先のメールアドレス
      expect(email.from).to eq(['no-reply@example.com']) # 送信元のメールアドレス

      # メールがマルチパート形式で送信されているため、正しいパート（プレーンテキストやHTML）を選択してデコードする
      # text/plain の部分を取得
      decoded_body = email.body.parts.find { |part| part.content_type.include?('text/plain') }.body.encoded
      # 予約に紐づく情報がメール本文に含まれていることを確認
      # テストが通過すれば文字化けしていないことも確認できる
      expect(decoded_body).to include(user.name) # ユーザー名
      expect(decoded_body).to include(movie.name) # 映画名
      expect(decoded_body).to include(schedule.start_time.strftime('%Y-%m-%d %H:%M')) # 上映開始時刻
      expect(decoded_body).to include(theater.name) # 劇場名
      expect(decoded_body).to include("#{sheet.row}-#{sheet.column}") # 座席
    end
  end
end
