require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = build(:user)
    @other_user = build(:other_user)
    @japanese_user = build(:japanese_user)
  end

  it '全ての欄が正しいとき有効' do
    @user = build(:user)
    expect(@user.valid?).to eq true
  end

  describe 'nameカラムに関して' do
    it '名前が空欄のとき無効' do
      expect(build(:user, name: nil).valid?).to eq false
      expect(build(:user, name: '').valid?).to eq false
      expect(build(:user, name: '  ').valid?).to eq false
      expect(build(:user, name: '　　').valid?).to eq false
    end

    it '名前が51文字以上のとき無効' do
      @user.name = 'a' * 50
      expect(@user.valid?).to eq true
      @user.name = 'a' * 51
      expect(@user.valid?).to eq false
    end

    it '名前が日本語でも有効' do
      expect(@japanese_user.valid?).to eq true

      japanese_name = @japanese_user.name
      @japanese_user.save!
      @japanese_user = User.find(@japanese_user.id)
      expect(@japanese_user.name).to eq japanese_name
    end

    it '先頭の空白は取り除かれて保存される' do
      @user.name = '  username'
      @user.save!
      expect(@user.name).to eq 'username'

      @user.name = '　　username'
      @user.save!
      expect(@user.name).to eq 'username'
    end

    it '文字中の空白は取り除かれずに保存される' do
      @user.name = 'user name'
      @user.save!
      expect(@user.name).to eq 'user name'

      @user.name = 'user　name'
      @user.save!
      expect(@user.name).to eq 'user　name'
    end
  end

  describe 'emailカラムに関して' do
    it 'emailが空欄のとき無効' do
      expect(build(:user, email: nil).valid?).to eq false
      expect(build(:user, email: '').valid?).to eq false
      expect(build(:user, email: '  ').valid?).to eq false
      expect(build(:user, email: '　　').valid?).to eq false
    end

    it 'emailが256文字以上のとき無効' do
      @user.email = "#{'a' * 243}@example.com"
      expect(@user.valid?).to eq true
      @user.email = "#{'a' * 244}@example.com"
      expect(@user.valid?).to eq false
    end

    it 'emailがフォーマットに従っていないとき無効' do
      expect(build(:user, email: 'user@example,com').valid?).to eq false
      expect(build(:user, email: 'user_at_foo.org').valid?).to eq false
      expect(build(:user, email: 'user.name@example.').valid?).to eq false
      expect(build(:user, email: 'foo@bar_baz.com').valid?).to eq false
      expect(build(:user, email: 'foo@bar+baz.com').valid?).to eq false
      expect(build(:user, email: ' @bar+baz.com').valid?).to eq false
      expect(build(:user, email: 'ユーザ@example.com').valid?).to eq false
    end

    it 'emailが小文字に変換されて保存される' do
      @user.email = "UsEr@eXamPLE.com"
      expect(!!@user.save!).to eq true
      @user = User.find(@user.id)
      expect(@user.email).to eq "user@example.com"
    end
  end

  describe 'passwordカラムに関して' do
    it 'passwordが空欄のとき無効' do
      expect(build(:user, password: nil).valid?).to eq false
      expect(build(:user, password: '').valid?).to eq false
      expect(build(:user, password: '  ').valid?).to eq false
      expect(build(:user, password: '　　').valid?).to eq false
    end

    it 'passwordとpassword_confirmationが両方空欄のとき無効' do
      expect(build(:user, password: nil, password_confirmation: nil).valid?).to eq false
      expect(build(:user, password: '', password_confirmation: '').valid?).to eq false
      expect(build(:user, password: '  ', password_confirmation: '  ').valid?).to eq false
      expect(build(:user, password: '　　', password_confirmation: '　　').valid?).to eq false
    end

    it 'passwordが5文字以下のとき無効' do
      @user.password = @user.password_confirmation = 'a' * 6
      expect(@user.valid?).to eq true
      @user.password = @user.password_confirmation = 'a' * 5
      expect(@user.valid?).to eq false
    end

    it 'passwordが空白のとき無効' do
      @user.password = @user.password_confirmation = ' ' * 6
      expect(@user.valid?).to eq false
      @user.password = @user.password_confirmation = '　' * 6
      expect(@user.valid?).to eq false
    end

    it 'passwordとpassword_confirmationで値が異なるとき無効' do
      @user.password = 'a' * 6
      @user.password_confirmation = 'b' * 6
      expect(@user.valid?).to eq false
    end
  end

  context '既にuserがDBに登録されている場合' do
    before do
      @user.save
    end

    describe 'other_userの新規登録について' do
      it "全ての入力が正しければ有効" do
        expect(@other_user.valid?).to eq true
      end

      it 'nameが同じでも有効' do
        @other_user.name = @user.name
        expect(@other_user.valid?).to eq true
      end

      it 'emailが同じであれば無効' do
        @other_user.email = @user.email
        expect(@other_user.valid?).to eq false
      end

      it 'eamilは大文字と小文字を区別せす，同じアルファベットの場合無効' do
        @other_user.email = @user.email.upcase
        expect(@other_user.valid?).to eq false
      end
    end
  end
end
