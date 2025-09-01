require 'rails_helper'

RSpec.describe Schedule, type: :model do
  let(:movie) { create(:movie, name: 'Test Movie') }
  let(:screen) { create(:screen) }

  describe 'バリデーション' do
    it '開始時間がない場合、無効であること' do
      schedule = build(:schedule, movie: movie, screen: screen, start_time: nil, end_time: Time.current + 2.hours)
      schedule.valid?
      expect(schedule.errors[:start_time]).to include('を入力してください')
    end

    it '終了時間がない場合、無効であること' do
      schedule = build(:schedule, movie: movie, screen: screen, start_time: Time.current, end_time: nil)
      schedule.valid?
      expect(schedule.errors[:end_time]).to include('を入力してください')
    end
  end

  describe '上映時間の重複チェック' do
    let!(:existing_schedule) do
      create(:schedule, movie: movie, screen: screen, start_time: Time.current, end_time: Time.current + 2.hours)
    end

    it '同じスクリーンで上映時間が重複するとエラーになること' do
      overlapping_schedule = build(:schedule, movie: movie, screen: screen, start_time: Time.current + 1.hour,
                                              end_time: Time.current + 3.hours)
      overlapping_schedule.valid?
      expect(overlapping_schedule.errors[:base]).to include('入力された上映時間中に他の作品が上映されています')
    end

    it '異なるスクリーンなら上映時間が重複してもエラーにならないこと' do
      other_screen = create(:screen)
      overlapping_schedule = build(:schedule, movie: movie, screen: other_screen, start_time: Time.current + 1.hour,
                                              end_time: Time.current + 3.hours)
      expect(overlapping_schedule).to be_valid
    end

    it '上映時間が完全に前後で被らなければ予約可能なこと' do
      non_overlapping_schedule = build(:schedule, movie: movie, screen: screen, start_time: Time.current + 2.hours,
                                                  end_time: Time.current + 4.hours)
      expect(non_overlapping_schedule).to be_valid
    end
  end

  describe '#name' do
    it '正しいフォーマットで上映スケジュールの名前を返すこと' do
      schedule = build(:schedule, movie: movie, screen: screen, start_time: Time.parse('14:00'),
                                  end_time: Time.parse('16:00'))
      expect(schedule.name).to eq('Test Movie (14:00 - 16:00)')
    end
  end

  describe '#public_attributes' do
    let(:schedule) do
      create(:schedule, movie: movie, screen: screen, start_time: Time.current, end_time: Time.current + 2.hours)
    end

    it 'screen_id を除いた属性を返すこと' do
      public_attrs = schedule.public_attributes

      expect(public_attrs.keys).not_to include('screen_id') # screen_idが含まれていないこと
      expect(public_attrs.keys).to include('id', 'movie_id', 'start_time', 'end_time', 'created_at', 'updated_at')
    end

    it 'screen_id 以外の値が正しいこと' do
      public_attrs = schedule.public_attributes

      expect(public_attrs['id']).to eq(schedule.id)
      expect(public_attrs['movie_id']).to eq(schedule.movie_id)
      expect(public_attrs['start_time']).to eq(schedule.start_time)
      expect(public_attrs['end_time']).to eq(schedule.end_time)
    end
  end
end
