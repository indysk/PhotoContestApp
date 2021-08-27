require 'rails_helper'

RSpec.describe Photo, type: :model do
  before do
    @photo = build(:photo)
    @other_photo = build(:other_photo)
    @japanese_photo = build(:japanese_photo)
  end

  it '全ての欄が正しいとき有効' do
    expect(@photo.valid?).to eq true
  end

  describe 'nameカラムに関して' do
    it '名前が空欄のとき無効' do
      expect(build(:photo, name: nil).valid?).to eq false
      expect(build(:photo, name: '').valid?).to eq false
      expect(build(:photo, name: '  ').valid?).to eq false
      expect(build(:photo, name: '　　').valid?).to eq false
    end

    it '名前が256文字以上のとき無効' do
      @photo.name = 'a' * 255
      expect(@photo.valid?).to eq true
      @photo.name = 'a' * 256
      expect(@photo.valid?).to eq false
    end

    it '名前が日本語でも有効' do
      expect(@japanese_photo.valid?).to eq true

      japanese_name = @japanese_photo.name
      @japanese_photo.save!
      expect(@japanese_photo.name).to eq japanese_name
    end

    it '先頭の空白は取り除かれて保存される' do
      @photo.name = '  photoname'
      @photo.save!
      expect(@photo.name).to eq 'photoname'

      @photo.name = '　　photoname'
      @photo.save!
      expect(@photo.name).to eq 'photoname'
    end

    it '文字中の空白は取り除かれずに保存される' do
      @photo.name = 'photo name'
      @photo.save!
      expect(@photo.name).to eq 'photo name'

      @photo.name = 'photo　name'
      @photo.save!
      expect(@photo.name).to eq 'photo　name'
    end
  end

  context '既にphotoがDBに登録されている場合' do
    before do
      @photo.save
    end

    describe 'other_photoの新規登録について' do
      it "全ての入力が正しければ有効" do
        expect(@other_photo.valid?).to eq true
      end

      it 'nameが同じでも有効' do
        @other_photo.name = @photo.name
        expect(@other_photo.valid?).to eq true
      end

    end
  end
end
