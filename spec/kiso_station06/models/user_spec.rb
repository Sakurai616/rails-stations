require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it 'name が存在すれば有効であること' do
      user = build(:user, name: 'テストユーザー', email: 'test@example.com', password: 'password',
                          password_confirmation: 'password')
      expect(user).to be_valid
    end

    it 'name がないと無効であること' do
      user = build(:user, name: nil, email: 'test@example.com', password: 'password', password_confirmation: 'password')
      expect(user).to be_invalid
      expect(user.errors[:name]).to include('を入力してください')
    end

    it 'email が正しい形式なら有効であること' do
      user = build(:user, name: 'テストユーザー', email: 'valid@example.com', password: 'password',
                          password_confirmation: 'password')
      expect(user).to be_valid
    end

    it 'email が不正な形式だと無効であること' do
      user = build(:user, name: 'テストユーザー', email: 'invalid_email', password: 'password',
                          password_confirmation: 'password')
      expect(user).to be_invalid
      expect(user.errors[:email]).to include('は不正な値です')
    end

    it 'password がなければ無効であること' do
      user = build(:user, name: 'テストユーザー', email: 'test@example.com', password: nil, password_confirmation: nil)
      expect(user).to be_invalid
      expect(user.errors[:password]).to include('を入力してください')
    end

    it 'password_confirmation がなければ無効であること' do
      user = build(:user, name: 'テストユーザー', email: 'test@example.com', password: 'password', password_confirmation: nil)
      expect(user).to be_invalid
      expect(user.errors[:password_confirmation]).to include('を入力してください')
    end
  end
end
