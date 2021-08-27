require 'rails_helper'

RSpec.describe Contest, type: :model do
  before do
    @contest = build(:contest)
    @other_contest = build(:other_contest)
    @japanese_contest = build(:japanese_contest)
  end

  it '全ての欄が正しいとき有効' do
    expect(@contest.valid?).to eq true
  end

  describe 'nameカラムに関して' do
    it '名前が空欄のとき無効' do
      expect(build(:contest, name: nil).valid?).to eq false
      expect(build(:contest, name: '').valid?).to eq false
      expect(build(:contest, name: '  ').valid?).to eq false
      expect(build(:contest, name: '　　').valid?).to eq false
    end

    it '名前が256文字以上のとき無効' do
      @contest.name = 'a' * 255
      expect(@contest.valid?).to eq true
      @contest.name = 'a' * 256
      expect(@contest.valid?).to eq false
    end

    it '名前が日本語でも有効で、日本語も正常に保存される' do
      expect(@japanese_contest.valid?).to eq true

      japanese_name = @japanese_contest.name
      @japanese_contest.save!
      expect(@japanese_contest.name).to eq japanese_name
    end

    it '先頭の空白は取り除かれて保存される' do
      @contest.name = '  contestname'
      @contest.save!
      expect(@contest.name).to eq 'contestname'

      @contest.name = '　　contestname'
      @contest.save!
      expect(@contest.name).to eq 'contestname'
    end

    it '文字中の空白は取り除かれずに保存される' do
      @contest.name = 'contest name'
      @contest.save!
      expect(@contest.name).to eq 'contest name'

      @contest.name = 'contest　name'
      @contest.save!
      expect(@contest.name).to eq 'contest　name'
    end
  end

  describe "user_idに関して" do
    it "user_idが空欄のとき無効" do
      expect(build(:contest, user_id: nil).valid?).to eq false
      expect(build(:contest, user_id: '').valid?).to eq false
      expect(build(:contest, user_id: '  ').valid?).to eq false
      expect(build(:contest, user_id: '　　').valid?).to eq false
    end

    it "userが存在しないとき無効" do
      user_id = 1000
      expect(User.where(id: user_id).exists?).to eq false
      expect(build(:contest, user_id: user_id).valid?).to eq false
    end

  end


  context '既にcontestがDBに登録されている場合' do
    before do
      @contest.save
    end

    describe 'other_contestの新規登録について' do
      it "全ての入力が正しければ有効" do
        expect(@other_contest.valid?).to eq true
      end

      it 'nameが同じでも有効' do
        @other_contest.name = @contest.name
        expect(@other_contest.valid?).to eq true
      end
    end
  end
end
