class ReservationsController < ApplicationController
    before_action :set_schedule, only: [:new]
    before_action :authenticate_user!

    def new
      @sheets = Sheet.all
      @sheet = Sheet.find_by(id: params[:sheet_id])
      @reservation = Reservation.new
  
      if @sheet.nil?
        flash[:alert] = "座席がありません"
        redirect_to movie_path(@movie)
      end
    end


    def create
        # リクエストパラメータを使って予約を作成
        @reservation = Reservation.new(reservation_params)
    
        # 保存処理
        if @reservation.save
          flash[:success] = "予約が完了しました。"
          redirect_to movies_path
        else
          # 保存失敗時のエラーメッセージを表示
          flash[:alert] = @reservation.errors.full_messages.join(", ")
          redirect_to reservation_movie_path(
            @reservation.schedule.movie,
            schedule_id: @reservation.schedule_id,
            date: @reservation.date.strftime("%Y-%m-%d")
          )
        end
    end

    # スケジュールの設定
    def set_schedule
      @movie = Movie.find_by(id: params[:movie_id])
        if params[:schedule_id].nil? || params[:date].blank?
          flash[:alert] = "スケジュールと日付が必要です"
          redirect_to movie_path(@movie)
        else
          @schedule = Schedule.find_by(id: params[:schedule_id])
          if @schedule.nil?
            flash[:alert] = "スケジュールが見つかりません"
            redirect_to movie_path(@movie)
          end
        end
    end
      
    def reservation_params
      params.require(:reservation).permit(:schedule_id, :sheet_id, :email, :name, :date)
    end
  
end