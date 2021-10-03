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

  describe 'descriptionカラムに関して' do
    it 'descriptionが空欄のとき有効である' do
      expect(build(:contest, description: '').valid?).to eq true
      expect(build(:contest, description: '  ').valid?).to eq true
      expect(build(:contest, description: '　　').valid?).to eq true
    end

    it 'descriptionがnilのとき空欄で保存される' do
      @contest.description = nil
      expect(@contest.valid?).to eq true
      @contest.save!
      expect(@contest.description).to eq ''
    end

    it 'descriptionが10000文字より大きいとき無効' do
      @contest.description = 'a' * 10000
      expect(@contest.valid?).to eq true
      @contest.save!
      expect(@contest.description).to eq 'a' * 10000
      @contest.description = 'あ' * 10000
      expect(@contest.valid?).to eq true
      @contest.save!
      expect(@contest.description).to eq 'あ' * 10000


      @contest.description = 'a' * 10001
      expect(@contest.valid?).to eq false
      @contest.description = 'あ' * 10001
      expect(@contest.valid?).to eq false
    end

    it 'descriptionが日本語でも有効で、日本語も正常に保存される' do
      expect(@japanese_contest.valid?).to eq true

      japanese_description = @japanese_contest.description
      @japanese_contest.save!
      expect(@japanese_contest.description).to eq japanese_description
    end

    it '先頭の空白は取り除かれず保存される' do
      @contest.description = '  contestdescription'
      @contest.save!
      expect(@contest.description).to eq '  contestdescription'

      @contest.description = '　　contestdescription'
      @contest.save!
      expect(@contest.description).to eq '　　contestdescription'
    end

    it '文字中の空白は取り除かれずに保存される' do
      @contest.description = 'contest description'
      @contest.save!
      expect(@contest.description).to eq 'contest description'

      @contest.description = 'contest　description'
      @contest.save!
      expect(@contest.description).to eq 'contest　description'
    end
  end

  describe 'entry_start_atカラムに関して' do
    it '空欄のとき無効である' do
      expect(build(:contest, entry_start_at: nil).valid?).to eq false
      expect(build(:contest, entry_start_at: '').valid?).to eq false
      expect(build(:contest, entry_start_at: '  ').valid?).to eq false
      expect(build(:contest, entry_start_at: '　　').valid?).to eq false
    end

    it 'datetime型でないとき無効' do
      time = Time.current
      expect(build(:contest, entry_start_at: 'abc').valid?).to eq false
      expect(build(:contest, entry_start_at: 'あいう').valid?).to eq false
      expect(build(:contest, entry_start_at: " #{time}").valid?).to eq false
      expect(build(:contest, entry_start_at: "　#{time}").valid?).to eq false
      expect(build(:contest, entry_start_at: "#{time} ").valid?).to eq false
    end

    it '作成日時より前の時間のとき無効' do
      @contest.entry_start_at = Time.current + 3.day
      @contest.entry_end_at = Time.current + 6.day
      @contest.vote_start_at = Time.current + 9.day
      @contest.vote_end_at = Time.current + 12.day

      @contest.entry_start_at = Time.current + 1.day
      expect(@contest.valid?).to eq true
      @contest.entry_start_at = Time.current + 1.second
      expect(@contest.valid?).to eq true
      @contest.entry_start_at = Time.current - 1.second
      expect(@contest.valid?).to eq false
      @contest.entry_start_at = Time.current - 1.day
      expect(@contest.valid?).to eq false
    end
  end

  describe 'entry_end_atカラムに関して' do
    it '空欄のとき無効である' do
      expect(build(:contest, entry_end_at: nil).valid?).to eq false
      expect(build(:contest, entry_end_at: '').valid?).to eq false
      expect(build(:contest, entry_end_at: '  ').valid?).to eq false
      expect(build(:contest, entry_end_at: '　　').valid?).to eq false
    end

    it 'datetime型でないとき無効' do
      time = Time.current
      expect(build(:contest, entry_end_at: 'abc').valid?).to eq false
      expect(build(:contest, entry_end_at: 'あいう').valid?).to eq false
      expect(build(:contest, entry_end_at: " #{time}").valid?).to eq false
      expect(build(:contest, entry_end_at: "　#{time}").valid?).to eq false
      expect(build(:contest, entry_end_at: "#{time} ").valid?).to eq false
    end

    it 'entry_start_atより前の時間のとき無効' do
      @contest.entry_start_at = Time.current + 12.day
      @contest.entry_end_at = Time.current + 15.day
      @contest.vote_start_at = Time.current + 18.day
      @contest.vote_end_at = Time.current + 21.day

      @contest.entry_end_at = @contest.entry_start_at + 1.day
      expect(@contest.valid?).to eq true
      @contest.entry_end_at = @contest.entry_start_at + 1.second
      expect(@contest.valid?).to eq true
      @contest.entry_end_at = @contest.entry_start_at - 1.second
      expect(@contest.valid?).to eq false
      @contest.entry_end_at = @contest.entry_start_at - 1.day
      expect(@contest.valid?).to eq false
    end
  end

  describe 'vote_start_atカラムに関して' do
    it '空欄のとき無効である' do
      expect(build(:contest, vote_start_at: nil).valid?).to eq false
      expect(build(:contest, vote_start_at: '').valid?).to eq false
      expect(build(:contest, vote_start_at: '  ').valid?).to eq false
      expect(build(:contest, vote_start_at: '　　').valid?).to eq false
    end

    it 'datetime型でないとき無効' do
      time = Time.current
      expect(build(:contest, vote_start_at: 'abc').valid?).to eq false
      expect(build(:contest, vote_start_at: 'あいう').valid?).to eq false
      expect(build(:contest, vote_start_at: " #{time}").valid?).to eq false
      expect(build(:contest, vote_start_at: "　#{time}").valid?).to eq false
      expect(build(:contest, vote_start_at: "#{time} ").valid?).to eq false
    end

    it 'entry_end_atより前の時間のとき無効' do
      @contest.entry_start_at = Time.current + 3.day
      @contest.entry_end_at = Time.current + 15.day
      @contest.vote_start_at = Time.current + 18.day
      @contest.vote_end_at = Time.current + 21.day

      @contest.vote_start_at = @contest.entry_end_at + 1.day
      expect(@contest.valid?).to eq true
      @contest.vote_start_at = @contest.entry_end_at + 1.second
      expect(@contest.valid?).to eq true
      @contest.vote_start_at = @contest.entry_end_at - 1.second
      expect(@contest.valid?).to eq false
      @contest.vote_start_at = @contest.entry_end_at - 1.day
      expect(@contest.valid?).to eq false
    end
  end

  describe 'vote_end_atカラムに関して' do
    it '空欄のとき無効である' do
      expect(build(:contest, vote_end_at: nil).valid?).to eq false
      expect(build(:contest, vote_end_at: '').valid?).to eq false
      expect(build(:contest, vote_end_at: '  ').valid?).to eq false
      expect(build(:contest, vote_end_at: '　　').valid?).to eq false
    end

    it 'datetime型でないとき無効' do
      time = Time.current
      expect(build(:contest, vote_end_at: 'abc').valid?).to eq false
      expect(build(:contest, vote_end_at: 'あいう').valid?).to eq false
      expect(build(:contest, vote_end_at: " #{time}").valid?).to eq false
      expect(build(:contest, vote_end_at: "　#{time}").valid?).to eq false
      expect(build(:contest, vote_end_at: "#{time} ").valid?).to eq false
    end

    it 'vote_start_atより前の時間のとき無効' do
      @contest.entry_start_at = Time.current + 3.day
      @contest.entry_end_at = Time.current + 6.day
      @contest.vote_start_at = Time.current + 18.day
      @contest.vote_end_at = Time.current + 21.day

      @contest.vote_end_at = @contest.vote_start_at + 1.day
      expect(@contest.valid?).to eq true
      @contest.vote_end_at = @contest.vote_start_at + 1.second
      expect(@contest.valid?).to eq true
      @contest.vote_end_at = @contest.vote_start_at - 1.second
      expect(@contest.valid?).to eq false
      @contest.vote_end_at = @contest.vote_start_at - 1.day
      expect(@contest.valid?).to eq false
    end
  end

  describe 'visible_range_entryカラムに関して' do
    it '空欄のとき無効' do
      expect(build(:contest, visible_range_entry: nil).valid?).to eq false
      expect(build(:contest, visible_range_entry: '').valid?).to eq false
      expect(build(:contest, visible_range_entry: '  ').valid?).to eq false
      expect(build(:contest, visible_range_entry: '　　').valid?).to eq false
    end

    it '選択肢の番号のとき有効' do
      @contest.visible_range_entry = 0
      expect(@contest.visible_range_entry).to eq 0
      expect(@contest.valid?).to eq true

      @contest.visible_range_entry = 1
      expect(@contest.visible_range_entry).to eq 1
      expect(@contest.valid?).to eq true

      @contest.visible_range_entry = " 1"
      expect(@contest.visible_range_entry).to eq 1
      expect(@contest.valid?).to eq true
    end

    it "選択肢以外の整数のとき無効" do
      expect(build(:contest, visible_range_entry: 9).valid?).to eq false
      expect(build(:contest, visible_range_entry: 12).valid?).to eq false
      expect(build(:contest, visible_range_entry: 999999999999999999999999).valid?).to eq false
    end

    it '選択肢の番号以外の文字のとき0に変換される' do
      @contest.visible_range_entry = 'a'
      expect(@contest.visible_range_entry).to eq 0
      @contest.visible_range_entry = 'あ'
      expect(@contest.visible_range_entry).to eq 0
      @contest.visible_range_entry = "　2"
      expect(@contest.visible_range_entry).to eq 0
      @contest.visible_range_entry = '２'
      expect(@contest.visible_range_entry).to eq 0
    end
  end

  describe 'visible_range_voteカラムに関して' do
    it '空欄のとき無効' do
      expect(build(:contest, visible_range_vote: nil).valid?).to eq false
      expect(build(:contest, visible_range_vote: '').valid?).to eq false
      expect(build(:contest, visible_range_vote: '  ').valid?).to eq false
      expect(build(:contest, visible_range_vote: '　　').valid?).to eq false
    end

    it '選択肢の番号のとき有効' do
      @contest.visible_range_vote = 0
      expect(@contest.visible_range_vote).to eq 0
      expect(@contest.valid?).to eq true

      @contest.visible_range_vote = 1
      expect(@contest.visible_range_vote).to eq 1
      expect(@contest.valid?).to eq true

      @contest.visible_range_vote = " 1"
      expect(@contest.visible_range_vote).to eq 1
      expect(@contest.valid?).to eq true
    end

    it "選択肢以外の整数のとき無効" do
      expect(build(:contest, visible_range_vote: 9).valid?).to eq false
      expect(build(:contest, visible_range_vote: 12).valid?).to eq false
      expect(build(:contest, visible_range_vote: 999999999999999999999999).valid?).to eq false
    end

    it '選択肢の番号以外の文字のとき0に変換される' do
      @contest.visible_range_vote = 'a'
      expect(@contest.visible_range_vote).to eq 0
      @contest.visible_range_vote = 'あ'
      expect(@contest.visible_range_vote).to eq 0
      @contest.visible_range_vote = "　2"
      expect(@contest.visible_range_vote).to eq 0
      @contest.visible_range_vote = '２'
      expect(@contest.visible_range_vote).to eq 0
    end
  end

  describe 'visible_range_showカラムに関して' do
    it '空欄のとき無効' do
      expect(build(:contest, visible_range_show: nil).valid?).to eq false
      expect(build(:contest, visible_range_show: '').valid?).to eq false
      expect(build(:contest, visible_range_show: '  ').valid?).to eq false
      expect(build(:contest, visible_range_show: '　　').valid?).to eq false
    end

    it '選択肢の番号のとき有効' do
      @contest.visible_range_show = 0
      expect(@contest.visible_range_show).to eq 0
      expect(@contest.valid?).to eq true

      @contest.visible_range_show = 1
      expect(@contest.visible_range_show).to eq 1
      expect(@contest.valid?).to eq true

      @contest.visible_range_show = " 1"
      expect(@contest.visible_range_show).to eq 1
      expect(@contest.valid?).to eq true
    end

    it "選択肢以外の整数のとき無効" do
      expect(build(:contest, visible_range_show: 9).valid?).to eq false
      expect(build(:contest, visible_range_show: 12).valid?).to eq false
      expect(build(:contest, visible_range_show: 999999999999999999999999).valid?).to eq false
    end

    it '選択肢の番号以外の文字のとき0に変換される' do
      @contest.visible_range_show = 'a'
      expect(@contest.visible_range_show).to eq 0
      @contest.visible_range_show = 'あ'
      expect(@contest.visible_range_show).to eq 0
      @contest.visible_range_show = "　2"
      expect(@contest.visible_range_show).to eq 0
      @contest.visible_range_show = '２'
      expect(@contest.visible_range_show).to eq 0
    end
  end

  describe 'visible_range_resultカラムに関して' do
    it '空欄のとき無効' do
      expect(build(:contest, visible_range_result: nil).valid?).to eq false
      expect(build(:contest, visible_range_result: '').valid?).to eq false
      expect(build(:contest, visible_range_result: '  ').valid?).to eq false
      expect(build(:contest, visible_range_result: '　　').valid?).to eq false
    end

    it '選択肢の番号のとき有効' do
      @contest.visible_range_result = 0
      expect(@contest.visible_range_result).to eq 0
      expect(@contest.valid?).to eq true

      @contest.visible_range_result = 1
      expect(@contest.visible_range_result).to eq 1
      expect(@contest.valid?).to eq true

      @contest.visible_range_result = " 1"
      expect(@contest.visible_range_result).to eq 1
      expect(@contest.valid?).to eq true
    end

    it "選択肢以外の整数のとき無効" do
      expect(build(:contest, visible_range_result: 9).valid?).to eq false
      expect(build(:contest, visible_range_result: 12).valid?).to eq false
      expect(build(:contest, visible_range_result: 999999999999999999999999).valid?).to eq false
    end

    it '選択肢の番号以外の文字のとき0に変換される' do
      @contest.visible_range_result = 'a'
      expect(@contest.visible_range_result).to eq 0
      @contest.visible_range_result = 'あ'
      expect(@contest.visible_range_result).to eq 0
      @contest.visible_range_result = "　2"
      expect(@contest.visible_range_result).to eq 0
      @contest.visible_range_result = '２'
      expect(@contest.visible_range_result).to eq 0
    end
  end

  describe 'voting_pointsカラムに関して' do
    it '空欄のとき無効' do
      expect(build(:contest, voting_points: nil).valid?).to eq false
      expect(build(:contest, voting_points: '').valid?).to eq false
      expect(build(:contest, voting_points: '  ').valid?).to eq false
      expect(build(:contest, voting_points: '　　').valid?).to eq false
    end

    it '範囲内の整数のとき有効' do
      @contest.voting_points = 1
      expect(@contest.voting_points).to eq 1
      expect(@contest.valid?).to eq true

      @contest.voting_points = 23
      expect(@contest.voting_points).to eq 23
      expect(@contest.valid?).to eq true

      @contest.voting_points = 99
      expect(@contest.voting_points).to eq 99
      expect(@contest.valid?).to eq true
    end

    it "選択肢以外の整数のとき無効" do
      expect(build(:contest, voting_points: 100).valid?).to eq false
      expect(build(:contest, voting_points: 1234).valid?).to eq false
      expect(build(:contest, voting_points: 999999999999999999999999).valid?).to eq false
      expect(build(:contest, voting_points: -1).valid?).to eq false
    end

    it '選択肢の番号以外の文字のとき0に変換され無効' do
      @contest.voting_points = 'a'
      expect(@contest.voting_points).to eq 0
      expect(@contest.valid?).to eq false

      @contest.voting_points = 'あ'
      expect(@contest.voting_points).to eq 0
      expect(@contest.valid?).to eq false

      @contest.voting_points = "　2"
      expect(@contest.voting_points).to eq 0
      expect(@contest.valid?).to eq false

      @contest.voting_points = '２'
      expect(@contest.voting_points).to eq 0
      expect(@contest.valid?).to eq false
    end
  end

  describe 'num_of_views_in_resultカラムに関して' do
    it '空欄のとき無効' do
      expect(build(:contest, num_of_views_in_result: nil).valid?).to eq false
      expect(build(:contest, num_of_views_in_result: '').valid?).to eq false
      expect(build(:contest, num_of_views_in_result: '  ').valid?).to eq false
      expect(build(:contest, num_of_views_in_result: '　　').valid?).to eq false
    end

    it '範囲内の整数のとき有効' do
      @contest.num_of_views_in_result = 1
      expect(@contest.num_of_views_in_result).to eq 1
      expect(@contest.valid?).to eq true

      @contest.num_of_views_in_result = 23
      expect(@contest.num_of_views_in_result).to eq 23
      expect(@contest.valid?).to eq true

      @contest.num_of_views_in_result = 99
      expect(@contest.num_of_views_in_result).to eq 99
      expect(@contest.valid?).to eq true
    end

    it "選択肢以外の整数のとき無効" do
      expect(build(:contest, num_of_views_in_result: 100).valid?).to eq false
      expect(build(:contest, num_of_views_in_result: 1234).valid?).to eq false
      expect(build(:contest, num_of_views_in_result: 999999999999999999999999).valid?).to eq false
      expect(build(:contest, num_of_views_in_result: -1).valid?).to eq false
    end

    it '選択肢の番号以外の文字のとき0に変換され無効' do
      @contest.num_of_views_in_result = 'a'
      expect(@contest.num_of_views_in_result).to eq 0
      expect(@contest.valid?).to eq false

      @contest.num_of_views_in_result = 'あ'
      expect(@contest.num_of_views_in_result).to eq 0
      expect(@contest.valid?).to eq false

      @contest.num_of_views_in_result = "　2"
      expect(@contest.num_of_views_in_result).to eq 0
      expect(@contest.valid?).to eq false

      @contest.num_of_views_in_result = '２'
      expect(@contest.num_of_views_in_result).to eq 0
      expect(@contest.valid?).to eq false
    end
  end

  describe 'num_of_submit_limitカラムに関して' do
    it '空欄のとき無効' do
      expect(build(:contest, num_of_submit_limit: nil).valid?).to eq false
      expect(build(:contest, num_of_submit_limit: '').valid?).to eq false
      expect(build(:contest, num_of_submit_limit: '  ').valid?).to eq false
      expect(build(:contest, num_of_submit_limit: '　　').valid?).to eq false
    end

    it '範囲内の整数のとき有効' do
      @contest.num_of_submit_limit = 1
      expect(@contest.num_of_submit_limit).to eq 1
      expect(@contest.valid?).to eq true

      @contest.num_of_submit_limit = 23
      expect(@contest.num_of_submit_limit).to eq 23
      expect(@contest.valid?).to eq true

      @contest.num_of_submit_limit = 99
      expect(@contest.num_of_submit_limit).to eq 99
      expect(@contest.valid?).to eq true
    end

    it "選択肢以外の整数のとき無効" do
      expect(build(:contest, num_of_submit_limit: 100).valid?).to eq false
      expect(build(:contest, num_of_submit_limit: 1234).valid?).to eq false
      expect(build(:contest, num_of_submit_limit: 999999999999999999999999).valid?).to eq false
      expect(build(:contest, num_of_submit_limit: -1).valid?).to eq false
    end

    it '選択肢の番号以外の文字のとき0に変換され無効' do
      @contest.num_of_submit_limit = 'a'
      expect(@contest.num_of_submit_limit).to eq 0
      expect(@contest.valid?).to eq false

      @contest.num_of_submit_limit = 'あ'
      expect(@contest.num_of_submit_limit).to eq 0
      expect(@contest.valid?).to eq false

      @contest.num_of_submit_limit = "　2"
      expect(@contest.num_of_submit_limit).to eq 0
      expect(@contest.valid?).to eq false

      @contest.num_of_submit_limit = '２'
      expect(@contest.num_of_submit_limit).to eq 0
      expect(@contest.valid?).to eq false
    end
  end

  describe 'visible_setting_for_user_nameカラムに関して' do
    it '空欄のとき無効' do
      expect(build(:contest, visible_setting_for_user_name: nil).valid?).to eq false
      expect(build(:contest, visible_setting_for_user_name: '').valid?).to eq false
      expect(build(:contest, visible_setting_for_user_name: '  ').valid?).to eq false
      expect(build(:contest, visible_setting_for_user_name: '　　').valid?).to eq false
    end

    it '選択肢の番号のとき有効' do
      @contest.visible_setting_for_user_name = 0
      expect(@contest.visible_setting_for_user_name).to eq 0
      expect(@contest.valid?).to eq true

      @contest.visible_setting_for_user_name = 1
      expect(@contest.visible_setting_for_user_name).to eq 1
      expect(@contest.valid?).to eq true

      @contest.visible_setting_for_user_name = 2
      expect(@contest.visible_setting_for_user_name).to eq 2
      expect(@contest.valid?).to eq true

      @contest.visible_setting_for_user_name = " 2"
      expect(@contest.visible_setting_for_user_name).to eq 2
      expect(@contest.valid?).to eq true
    end

    it "選択肢以外の整数のとき無効" do
      expect(build(:contest, visible_setting_for_user_name: 9).valid?).to eq false
      expect(build(:contest, visible_setting_for_user_name: 12).valid?).to eq false
      expect(build(:contest, visible_setting_for_user_name: 999999999999999999999999).valid?).to eq false
    end

    it '選択肢の番号以外の文字のとき0に変換される' do
      @contest.visible_setting_for_user_name = 'a'
      expect(@contest.visible_setting_for_user_name).to eq 0
      @contest.visible_setting_for_user_name = 'あ'
      expect(@contest.visible_setting_for_user_name).to eq 0
      @contest.visible_setting_for_user_name = "　2"
      expect(@contest.visible_setting_for_user_name).to eq 0
      @contest.visible_setting_for_user_name = '２'
      expect(@contest.visible_setting_for_user_name).to eq 0
    end
  end

  describe 'limited_url_entryカラムに関して' do
    it '空欄のとき無効' do
      expect(build(:contest, limited_url_entry: nil).valid?).to eq false
      expect(build(:contest, limited_url_entry: '').valid?).to eq false
      expect(build(:contest, limited_url_entry: '  ').valid?).to eq false
      expect(build(:contest, limited_url_entry: '　　').valid?).to eq false
    end

    it '16文字以外のとき無効' do
      @contest.limited_url_entry = 'a' * 15
      expect(@contest.valid?).to eq false
      @contest.limited_url_entry = 'a' * 16
      expect(@contest.valid?).to eq true
      @contest.limited_url_entry = 'a' * 17
      expect(@contest.valid?).to eq false
    end
  end

  describe 'limited_url_voteカラムに関して' do
    it '空欄のとき無効' do
      expect(build(:contest, limited_url_vote: nil).valid?).to eq false
      expect(build(:contest, limited_url_vote: '').valid?).to eq false
      expect(build(:contest, limited_url_vote: '  ').valid?).to eq false
      expect(build(:contest, limited_url_vote: '　　').valid?).to eq false
    end

    it '16文字以外のとき無効' do
      @contest.limited_url_vote = 'a' * 15
      expect(@contest.valid?).to eq false
      @contest.limited_url_vote = 'a' * 16
      expect(@contest.valid?).to eq true
      @contest.limited_url_vote = 'a' * 17
      expect(@contest.valid?).to eq false
    end
  end

  describe 'limited_url_showカラムに関して' do
    it '空欄のとき無効' do
      expect(build(:contest, limited_url_show: nil).valid?).to eq false
      expect(build(:contest, limited_url_show: '').valid?).to eq false
      expect(build(:contest, limited_url_show: '  ').valid?).to eq false
      expect(build(:contest, limited_url_show: '　　').valid?).to eq false
    end

    it '16文字以外のとき無効' do
      @contest.limited_url_show = 'a' * 15
      expect(@contest.valid?).to eq false
      @contest.limited_url_show = 'a' * 16
      expect(@contest.valid?).to eq true
      @contest.limited_url_show = 'a' * 17
      expect(@contest.valid?).to eq false
    end
  end


  describe 'limited_url_resultカラムに関して' do
    it '空欄のとき無効' do
      expect(build(:contest, limited_url_result: nil).valid?).to eq false
      expect(build(:contest, limited_url_result: '').valid?).to eq false
      expect(build(:contest, limited_url_result: '  ').valid?).to eq false
      expect(build(:contest, limited_url_result: '　　').valid?).to eq false
    end

    it '16文字以外のとき無効' do
      @contest.limited_url_result = 'a' * 15
      expect(@contest.valid?).to eq false
      @contest.limited_url_result = 'a' * 16
      expect(@contest.valid?).to eq true
      @contest.limited_url_result = 'a' * 17
      expect(@contest.valid?).to eq false
    end
  end
end
