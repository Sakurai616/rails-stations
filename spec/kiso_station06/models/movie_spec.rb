# spec/models/movie_spec.rb
require 'rails_helper'

RSpec.describe Movie, type: :model do
  let(:movie) { FactoryBot.build(:movie) }

  describe 'バリデーション' do
    it '有効な属性であれば有効であること' do
      expect(movie).to be_valid
    end

    it '名前がない場合無効であること' do
      movie.name = nil
      expect(movie).to_not be_valid
      expect(movie.errors[:name]).to include('を入力してください')
    end

    it '年がない場合無効であること' do
      movie.year = nil
      expect(movie).to_not be_valid
      expect(movie.errors[:year]).to include('を入力してください')
    end

    it '年が45文字を超える場合無効であること' do
      movie.year = '2025' * 20
      expect(movie).to_not be_valid
      expect(movie.errors[:year]).to include('は45文字以内で入力してください')
    end

    it '説明がない場合無効であること' do
      movie.description = nil
      expect(movie).to_not be_valid
      expect(movie.errors[:description]).to include('を入力してください')
    end

    it '画像URLがない場合無効であること' do
      movie.image_url = nil
      expect(movie).to_not be_valid
      expect(movie.errors[:image_url]).to include('を入力してください')
    end

    it '無効な形式の画像URLの場合無効であること' do
      movie.image_url = 'invalid_url'
      expect(movie).to_not be_valid
      expect(movie.errors[:image_url]).to include('有効なURLを入力してください。')
    end

    it 'is_showingがtrueかfalseでない場合無効であること' do
      movie.is_showing = nil
      expect(movie).to_not be_valid
      expect(movie.errors[:is_showing]).to include('上映中かどうかを選択してください。')
    end
  end
end
