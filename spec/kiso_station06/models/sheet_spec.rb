require 'rails_helper'

RSpec.describe Sheet, type: :model do
  let(:screen) { create(:screen) }

  describe 'バリデーション' do
    it '有効なデータで作成できること' do
      sheet = build(:sheet, screen: screen, row: 'A', column: 1)
      expect(sheet).to be_valid
    end

    it 'column がないと無効であること' do
      sheet = build(:sheet, screen: screen, row: 'A', column: nil)
      expect(sheet).to be_invalid
      expect(sheet.errors[:column]).to include('を入力してください')
    end

    it 'column が整数でない場合は無効であること' do
      sheet = build(:sheet, screen: screen, row: 'A', column: 1.5)
      expect(sheet).to be_invalid
      expect(sheet.errors[:column]).to include('は整数で入力してください')
    end

    it 'column が 0 以下の場合は無効であること' do
      sheet = build(:sheet, screen: screen, row: 'A', column: 0)
      expect(sheet).to be_invalid
      expect(sheet.errors[:column]).to include('は0より大きい値にしてください')
    end

    it 'row がないと無効であること' do
      sheet = build(:sheet, screen: screen, row: nil, column: 1)
      expect(sheet).to be_invalid
      expect(sheet.errors[:row]).to include('を入力してください')
    end

    it 'row がアルファベット以外を含むと無効であること' do
      sheet = build(:sheet, screen: screen, row: 'A1', column: 1)
      expect(sheet).to be_invalid
      expect(sheet.errors[:row]).to include('は不正な値です')
    end

    it 'screen_id がないと無効であること' do
      sheet = build(:sheet, screen: nil, row: 'A', column: 1)
      expect(sheet).to be_invalid
      expect(sheet.errors[:screen_id]).to include('を入力してください')
    end

    it '同じ screen_id 内で row と column の組み合わせが重複すると無効であること' do
      create(:sheet, screen: screen, row: 'A', column: 1)
      duplicate_sheet = build(:sheet, screen: screen, row: 'A', column: 1)
      expect(duplicate_sheet).to be_invalid
      expect(duplicate_sheet.errors[:screen_id]).to include('はすでに存在します')
    end

    it '異なる screen_id なら同じ row と column の組み合わせでも有効であること' do
      other_screen = create(:screen)
      create(:sheet, screen: screen, row: 'A', column: 1)
      sheet = build(:sheet, screen: other_screen, row: 'A', column: 1)
      expect(sheet).to be_valid
    end
  end

  describe 'インスタンスメソッド' do
    it 'name メソッドが row + column の形式で出力されること' do
      sheet = build(:sheet, row: 'B', column: 3)
      expect(sheet.name).to eq('B3')
    end
  end
end
