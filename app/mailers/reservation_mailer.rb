class ReservationMailer < ApplicationMailer
  default from: 'no-reply@example.com' # 送信元のメールアドレス

  def reservation_confirmation(reservation)
    @reservation = reservation
    @user = reservation.user
    @movie = reservation.schedule.movie
    @schedule = reservation.schedule
    @theater = reservation.schedule.screen.theater

    mail(
      to: @user.email,
      subject: '予約完了のお知らせ'
    )
  end

  def reminder_email(reservation)
    @reservation = reservation
    @user = reservation.user
    @movie = reservation.schedule.movie
    @schedule = reservation.schedule
    @theater = reservation.schedule.screen.theater

    mail(
      to: @user.email,
      subject: '【リマインド】明日の映画予約について'
    )
  end
end
