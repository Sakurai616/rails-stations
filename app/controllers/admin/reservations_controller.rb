module Admin
  class ReservationsController < ApplicationController
    before_action :set_reservation, only: %i[show update destroy]

    # 予約一覧
    def index
      @reservations = Reservation.all
    end

    # 新規予約フォーム
    def new
      @reservation = Reservation.new
    end

    # 予約作成
    def create
      @reservation = Reservation.new(reservation_params)
      if @reservation.save
        flash[:success] = '予約を作成しました。'
        redirect_to admin_reservations_path
      else
        flash[:error] = @reservation.errors.full_messages.join(', ')
        render :new, status: :bad_request
      end
    end

    # 編集フォーム
    def show; end

    # 予約更新
    def update
      if @reservation.update(reservation_update_params)
        flash[:success] = '予約を更新しました。'
        redirect_to admin_reservations_path, status: :found # 302 を明示的に指定
      else
        flash.now[:error] = @reservation.errors.full_messages.join(', ')
        render :show, status: :bad_request # 400
      end
    end

    # 予約削除
    def destroy
      @reservation.destroy
      flash[:success] = '予約を削除しました。'
      redirect_to admin_reservations_path
    end

    private

    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def reservation_params
      params.require(:reservation).permit(:schedule_id, :sheet_id, :date, :name, :email, :user_id)
    end

    def reservation_update_params
      params.require(:reservation).permit(:schedule_id, :sheet_id, :name, :email, :user_id)
    end
  end
end
