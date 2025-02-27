class ReservationsController < ApplicationController
  before_action :set_schedule, only: [:new]
  before_action :authenticate_user!

  def new
    @sheet = Sheet.find_by(id: params[:sheet_id])
    @reservation = Reservation.new

    handle_missing_sheet if @sheet.nil?
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.user = current_user # ユーザーを設定

    if @reservation.save
      handle_successful_reservation
    else
      handle_failed_reservation
    end
  end

  private

  def set_schedule
    @movie = Movie.find_by(id: params[:movie_id])
    handle_missing_schedule_data if params[:schedule_id].nil? || params[:date].blank?
    @schedule = Schedule.find_by(id: params[:schedule_id])
    handle_invalid_schedule if @schedule.nil?
  end

  def handle_successful_reservation
    flash[:success] = '予約が完了しました。'
    redirect_to movies_path
  end

  def handle_failed_reservation
    flash[:alert] = @reservation.errors.full_messages.join(', ')
    redirect_to reservation_movie_path(
      @reservation.schedule.movie,
      schedule_id: @reservation.schedule_id,
      date: @reservation.date.strftime('%Y-%m-%d')
    )
  end

  def handle_missing_sheet
    flash[:alert] = '座席がありません'
    redirect_to movie_path(@movie)
  end

  def handle_missing_schedule_data
    flash[:alert] = 'スケジュールと日付が必要です'
    redirect_to movie_path(@movie)
  end

  def handle_invalid_schedule
    flash[:alert] = 'スケジュールが見つかりません'
    redirect_to movie_path(@movie)
  end

  def reservation_params
    params.require(:reservation).permit(:schedule_id, :sheet_id, :email, :name, :date)
  end
end
