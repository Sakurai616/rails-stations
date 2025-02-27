module Admin
  class TheatersController < ApplicationController
    # 選択した劇場に紐づいたスクリーン一覧を取得
    def screens
      theater = Theater.find(params[:id])
      render json: theater.screens.select(:id, :number)
    end
  end
end
