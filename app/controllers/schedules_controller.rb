class SchedulesController < ApplicationController
  def index
    @schedules = Schedule.where(movie_id: params[:movie_id])
    render json: { schedules: @schedules }
  end
end
