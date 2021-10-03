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

    it '名前が日本語でも有効で、日本語も正常に保存される' do
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

  describe "user_idに関して" do
    it "user_idが空欄のとき無効" do
      expect(build(:photo, user_id: nil).valid?).to eq false
      expect(build(:photo, user_id: '').valid?).to eq false
      expect(build(:photo, user_id: '  ').valid?).to eq false
      expect(build(:photo, user_id: '　　').valid?).to eq false
    end

    it "userが存在しないとき無効" do
      user_id = 1000
      expect(User.where(id: user_id).exists?).to eq false
      expect(build(:photo, user_id: user_id).valid?).to eq false
    end
  end

  describe "contest_idに関して" do
    it "contest_idが空欄のとき無効" do
      expect(build(:photo, contest_id: nil).valid?).to eq false
      expect(build(:photo, contest_id: '').valid?).to eq false
      expect(build(:photo, contest_id: '  ').valid?).to eq false
      expect(build(:photo, contest_id: '　　').valid?).to eq false
    end

    it "contestが存在しないとき無効" do
      contest_id = 1000
      expect(User.where(id: contest_id).exists?).to eq false
      expect(build(:photo, contest_id: contest_id).valid?).to eq false
    end
  end

  describe 'descriptionカラムに関して' do
    it 'descriptionが空欄のとき有効である' do
      expect(build(:photo, description: '').valid?).to eq true
      expect(build(:photo, description: '  ').valid?).to eq true
      expect(build(:photo, description: '　　').valid?).to eq true
    end

    it 'descriptionがnilのとき空欄で保存される' do
      @photo.description = nil
      expect(@photo.valid?).to eq true
      @photo.save!
      expect(@photo.description).to eq ''
    end

    it 'descriptionが10000文字より大きいとき無効' do
      @photo.description = 'a' * 10000
      expect(@photo.valid?).to eq true
      @photo.save!
      expect(@photo.description).to eq 'a' * 10000
      @photo.description = 'あ' * 10000
      expect(@photo.valid?).to eq true
      @photo.save!
      expect(@photo.description).to eq 'あ' * 10000


      @photo.description = 'a' * 10001
      expect(@photo.valid?).to eq false
      @photo.description = 'あ' * 10001
      expect(@photo.valid?).to eq false
    end

    it 'descriptionが日本語でも有効で、日本語も正常に保存される' do
      expect(@japanese_photo.valid?).to eq true

      japanese_description = @japanese_photo.description
      @japanese_photo.save!
      expect(@japanese_photo.description).to eq japanese_description
    end

    it '先頭の空白は取り除かれず保存される' do
      @photo.description = '  photodescription'
      @photo.save!
      expect(@photo.description).to eq '  photodescription'

      @photo.description = '　　photodescription'
      @photo.save!
      expect(@photo.description).to eq '　　photodescription'
    end

    it '文字中の空白は取り除かれずに保存される' do
      @photo.description = 'photo description'
      @photo.save!
      expect(@photo.description).to eq 'photo description'

      @photo.description = 'photo　description'
      @photo.save!
      expect(@photo.description).to eq 'photo　description'
    end
  end

  describe 'cameraカラムに関して' do
    it '名前が空欄のとき無効' do
      expect(build(:photo, camera: nil).valid?).to eq false
      expect(build(:photo, camera: '').valid?).to eq false
      expect(build(:photo, camera: '  ').valid?).to eq false
      expect(build(:photo, camera: '　　').valid?).to eq false
    end

    it '256文字以上のとき無効' do
      @photo.camera = 'a' * 255
      expect(@photo.valid?).to eq true
      @photo.camera = 'a' * 256
      expect(@photo.valid?).to eq false
    end

    it '先頭の空白は取り除かれず保存される' do
      @photo.camera = '  photocamera'
      @photo.save!
      expect(@photo.camera).to eq '  photocamera'

      @photo.camera = '　　photocamera'
      @photo.save!
      expect(@photo.camera).to eq '　　photocamera'
    end

    it '文字中の空白は取り除かれずに保存される' do
      @photo.camera = 'photo camera'
      @photo.save!
      expect(@photo.camera).to eq 'photo camera'

      @photo.camera = 'photo　camera'
      @photo.save!
      expect(@photo.camera).to eq 'photo　camera'
    end

    it '日本語でも有効' do
      @photo.camera = 'カメラ'
      @photo.save!
      expect(@photo.camera).to eq 'カメラ'
    end
  end

  describe 'lensカラムに関して' do
    it '名前が空欄のとき無効' do
      expect(build(:photo, lens: nil).valid?).to eq false
      expect(build(:photo, lens: '').valid?).to eq false
      expect(build(:photo, lens: '  ').valid?).to eq false
      expect(build(:photo, lens: '　　').valid?).to eq false
    end

    it '256文字以上のとき無効' do
      @photo.lens = 'a' * 255
      expect(@photo.valid?).to eq true
      @photo.lens = 'a' * 256
      expect(@photo.valid?).to eq false
    end

    it '先頭の空白は取り除かれず保存される' do
      @photo.lens = '  photolens'
      @photo.save!
      expect(@photo.lens).to eq '  photolens'

      @photo.lens = '　　photolens'
      @photo.save!
      expect(@photo.lens).to eq '　　photolens'
    end

    it '文字中の空白は取り除かれずに保存される' do
      @photo.lens = 'photo lens'
      @photo.save!
      expect(@photo.lens).to eq 'photo lens'

      @photo.lens = 'photo　lens'
      @photo.save!
      expect(@photo.lens).to eq 'photo　lens'
    end

    it '日本語でも有効' do
      @photo.lens = '５０単'
      @photo.save!
      expect(@photo.lens).to eq '５０単'
    end
  end

  describe 'isoカラムに関して' do
    it '名前が空欄のとき無効' do
      expect(build(:photo, iso: nil).valid?).to eq false
      expect(build(:photo, iso: '').valid?).to eq false
      expect(build(:photo, iso: '  ').valid?).to eq false
      expect(build(:photo, iso: '　　').valid?).to eq false
    end

    it '256文字以上のとき無効' do
      @photo.iso = 'a' * 255
      expect(@photo.valid?).to eq true
      @photo.iso = 'a' * 256
      expect(@photo.valid?).to eq false
    end

    it '先頭の空白は取り除かれず保存される' do
      @photo.iso = '  photoiso'
      @photo.save!
      expect(@photo.iso).to eq '  photoiso'

      @photo.iso = '　　photoiso'
      @photo.save!
      expect(@photo.iso).to eq '　　photoiso'
    end

    it '文字中の空白は取り除かれずに保存される' do
      @photo.iso = 'photo iso'
      @photo.save!
      expect(@photo.iso).to eq 'photo iso'

      @photo.iso = 'photo　iso'
      @photo.save!
      expect(@photo.iso).to eq 'photo　iso'
    end

    it '日本語でも有効' do
      @photo.iso = '１２８００'
      @photo.save!
      expect(@photo.iso).to eq '１２８００'
    end
  end

  describe 'apertureカラムに関して' do
    it '名前が空欄のとき無効' do
      expect(build(:photo, aperture: nil).valid?).to eq false
      expect(build(:photo, aperture: '').valid?).to eq false
      expect(build(:photo, aperture: '  ').valid?).to eq false
      expect(build(:photo, aperture: '　　').valid?).to eq false
    end

    it '256文字以上のとき無効' do
      @photo.aperture = 'a' * 255
      expect(@photo.valid?).to eq true
      @photo.aperture = 'a' * 256
      expect(@photo.valid?).to eq false
    end

    it '先頭の空白は取り除かれず保存される' do
      @photo.aperture = '  photoaperture'
      @photo.save!
      expect(@photo.aperture).to eq '  photoaperture'

      @photo.aperture = '　　photoaperture'
      @photo.save!
      expect(@photo.aperture).to eq '　　photoaperture'
    end

    it '文字中の空白は取り除かれずに保存される' do
      @photo.aperture = 'photo aperture'
      @photo.save!
      expect(@photo.aperture).to eq 'photo aperture'

      @photo.aperture = 'photo　aperture'
      @photo.save!
      expect(@photo.aperture).to eq 'photo　aperture'
    end

    it '日本語でも有効' do
      @photo.aperture = 'Ｆ１．８'
      @photo.save!
      expect(@photo.aperture).to eq 'Ｆ１．８'
    end
  end

  describe 'shutter_speedカラムに関して' do
    it '名前が空欄のとき無効' do
      expect(build(:photo, shutter_speed: nil).valid?).to eq false
      expect(build(:photo, shutter_speed: '').valid?).to eq false
      expect(build(:photo, shutter_speed: '  ').valid?).to eq false
      expect(build(:photo, shutter_speed: '　　').valid?).to eq false
    end

    it '256文字以上のとき無効' do
      @photo.shutter_speed = 'a' * 255
      expect(@photo.valid?).to eq true
      @photo.shutter_speed = 'a' * 256
      expect(@photo.valid?).to eq false
    end

    it '先頭の空白は取り除かれず保存される' do
      @photo.shutter_speed = '  photoshutter_speed'
      @photo.save!
      expect(@photo.shutter_speed).to eq '  photoshutter_speed'

      @photo.shutter_speed = '　　photoshutter_speed'
      @photo.save!
      expect(@photo.shutter_speed).to eq '　　photoshutter_speed'
    end

    it '文字中の空白は取り除かれずに保存される' do
      @photo.shutter_speed = 'photo shutter_speed'
      @photo.save!
      expect(@photo.shutter_speed).to eq 'photo shutter_speed'

      @photo.shutter_speed = 'photo　shutter_speed'
      @photo.save!
      expect(@photo.shutter_speed).to eq 'photo　shutter_speed'
    end

    it '日本語でも有効' do
      @photo.shutter_speed = 'シャッタースピード１／１６００'
      @photo.save!
      expect(@photo.shutter_speed).to eq 'シャッタースピード１／１６００'
    end
  end
end
