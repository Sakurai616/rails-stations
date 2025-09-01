namespace :reminder do
  desc 'Send reminder emails to users with reservations for the next day'
  task send: :environment do
    tomorrow = Date.tomorrow
    reservations = Reservation.where(date: tomorrow)

    reservations.each do |reservation|
      ReservationMailer.reminder_email(reservation).deliver_now
      puts "Reminder email sent to #{reservation.user.email} for reservation ID: #{reservation.id}"
    end
  end
end
