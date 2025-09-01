class ReservationsController < ApplicationController
  before_action :set_schedule, only: [:new]
  before_action :authenticate_user!
  before_action :set_reservation, only: %i[edit update destroy]
  before_action :set_reservation_info, only: %i[edit update]

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

  def edit; end

  def update
    if @reservation.update(reservation_params)
      flash[:notice] = '予約情報を更新しました'
      redirect_to user_path(current_user) # ユーザーの予約一覧へリダイレクト
    else
      flash.now[:alert] = @reservation.errors.full_messages.join(', ')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @reservation.destroy
    flash[:notice] = '予約をキャンセルしました'
    redirect_to user_path(current_user) # ユーザーの予約一覧へリダイレクト
  end

  private

  def set_schedule
    @movie = Movie.find_by(id: params[:movie_id])
    handle_missing_schedule_data if params[:schedule_id].nil? || params[:date].blank?
    @schedule = Schedule.find_by(id: params[:schedule_id])
    handle_invalid_schedule if @schedule.nil?
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
    redirect_to movies_path, alert: '不正なアクセスです' unless @reservation.user == current_user
  end

  def set_reservation_info
    set_movie
    set_schedules_for_movie
    set_sheets_for_schedule
    set_available_sheets
  end

  # 映画情報の取得
  def set_movie
    @movies = Movie.where(is_showing: true)
    @selected_movie = @reservation.schedule.movie
  end

  # 選択された映画のスケジュールを取得
  def set_schedules_for_movie
    @schedules = @selected_movie.schedules
  end

  # 座席情報の取得
  def set_sheets_for_schedule
    @sheets = @reservation.schedule.screen.sheets
  end

  # 予約可能な座席の取得（現在の予約座席も選択可能）
  def set_available_sheets
    @available_sheets = @sheets.reject do |sheet|
      sheet.reservations.where(schedule: @reservation.schedule, date: @reservation.date)
           .where.not(user_id: current_user).any?
    end
  end

  def handle_successful_reservation
    ReservationMailer.reservation_confirmation(@reservation).deliver_now
    flash[:success] = '予約が完了しました。確認メールを送信しました。'
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
