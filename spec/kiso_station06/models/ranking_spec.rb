require 'rails_helper'

RSpec.describe Ranking, type: :model do
  let(:movie) { FactoryBot.create(:movie) }
  let(:ranking) { FactoryBot.build(:ranking, movie: movie) }

  describe 'バリデーション' do
    context 'movie_id' do
      it 'movie_idがない場合は無効であること' do
        ranking.movie_id = nil
        expect(ranking).to_not be_valid
        expect(ranking.errors[:movie_id]).to include('を入力してください')
      end
    end

    context 'reservation_count' do
      it 'reservation_countがない場合は無効であること' do
        ranking.reservation_count = nil
        expect(ranking).to_not be_valid
        expect(ranking.errors[:reservation_count]).to include('を入力してください')
      end

      it 'reservation_countが整数でない場合は無効であること' do
        ranking.reservation_count = 1.5
        expect(ranking).to_not be_valid
        expect(ranking.errors[:reservation_count]).to include('は整数で入力してください')
      end

      it 'reservation_countが負の数の場合は無効であること' do
        ranking.reservation_count = -1
        expect(ranking).to_not be_valid
        expect(ranking.errors[:reservation_count]).to include('は0以上の値にしてください')
      end

      it 'reservation_countが0以上で整数の場合は有効であること' do
        ranking.reservation_count = 0
        expect(ranking).to be_valid

        ranking.reservation_count = 10
        expect(ranking).to be_valid
      end
    end

    context 'date' do
      it 'dateがない場合は無効であること' do
        ranking.date = nil
        expect(ranking).to_not be_valid
        expect(ranking.errors[:date]).to include('を入力してください')
      end

      it 'dateが重複している場合は無効であること' do
        FactoryBot.create(:ranking, movie: movie, date: Date.today)
        ranking.date = Date.today
        expect(ranking).to_not be_valid
        expect(ranking.errors[:date]).to include('はすでに存在します')
      end

      it 'dateが一意であれば有効であること' do
        ranking.date = Date.tomorrow
        expect(ranking).to be_valid
      end
    end
  end
end
