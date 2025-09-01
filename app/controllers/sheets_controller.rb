class SheetsController < ApplicationController
  def index
    @sheets = Sheet.all.group_by(&:row)
  end

  def available
    schedule = Schedule.find(params[:schedule_id])
    # スケジュールに基づく座席情報を取得
    reserved_sheet_ids = schedule.reservations.where.not(user_id: current_user.id).pluck(:sheet_id) # 他のユーザーの予約済み座席を取得
    available_sheets = schedule.screen.sheets.where.not(id: reserved_sheet_ids) # 利用可能な座席を取得
    render json: { sheets: available_sheets }
  end
end
