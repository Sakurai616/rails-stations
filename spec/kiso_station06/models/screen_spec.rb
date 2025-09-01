require 'rails_helper'

RSpec.describe Screen, type: :model do
  let(:theater) { create(:theater) }

  describe 'バリデーション' do
    it '有効なデータで作成できること' do
      screen = build(:screen, theater: theater, number: 1)
      expect(screen).to be_valid
    end

    it 'スクリーン番号がないと無効であること' do
      screen = build(:screen, theater: theater, number: nil)
      expect(screen).to be_invalid
      expect(screen.errors[:number]).to include('を入力してください')
    end

    it 'スクリーン番号が整数でない場合は無効であること' do
      screen = build(:screen, theater: theater, number: 1.5)
      expect(screen).to be_invalid
      expect(screen.errors[:number]).to include('は整数で入力してください')
    end

    it 'スクリーン番号が0以下の場合は無効であること' do
      screen = build(:screen, theater: theater, number: 0)
      expect(screen).to be_invalid
      expect(screen.errors[:number]).to include('は0より大きい値にしてください')
    end

    it '同じ劇場内でスクリーン番号が重複すると無効であること' do
      create(:screen, theater: theater, number: 1)
      duplicate_screen = build(:screen, theater: theater, number: 1)
      expect(duplicate_screen).to be_invalid
      expect(duplicate_screen.errors[:number]).to include('はすでに存在します')
    end

    it '異なる劇場なら同じスクリーン番号でも有効であること' do
      other_theater = create(:theater)
      create(:screen, theater: theater, number: 1)
      screen = build(:screen, theater: other_theater, number: 1)
      expect(screen).to be_valid
    end

    it '劇場IDがない場合は無効であること' do
      screen = build(:screen, theater: nil)
      expect(screen).to be_invalid
      expect(screen.errors[:theater_id]).to include('を入力してください')
    end
  end
end
