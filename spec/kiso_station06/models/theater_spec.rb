require 'rails_helper'

RSpec.describe Theater, type: :model do
  describe 'バリデーション' do
    it 'name が存在すれば有効であること' do
      theater = build(:theater, name: 'シアターX')
      expect(theater).to be_valid
    end

    it 'name がないと無効であること' do
      theater = build(:theater, name: nil)
      expect(theater).to be_invalid
      expect(theater.errors[:name]).to include('を入力してください')
    end
  end
end
