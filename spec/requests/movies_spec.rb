require 'rails_helper'

RSpec.describe 'Movies', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/movies/index'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get '/movies/show'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /reservation' do
    it 'returns http success' do
      get '/movies/reservation'
      expect(response).to have_http_status(:success)
    end
  end
end
