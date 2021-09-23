require 'rails_helper'

RSpec.describe "Users", type: :system do

  before do
    @user = build(:user)
  end

  describe "ユーザ新規登録について" do
    context "有効なユーザ新規登録のとき" do

    end

    it '新規登録からの登録' do
      visit signup_path

      fill_in 'Name', with: @user.name
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Confirmation', with: @user.password_confirmation
      attach_file 'Image', Rails.root.join('spec/fixtures/images/food_pizza.png')
      expect { click_button 'Create my account' }.to change(User, :count).by(1)

      expect(current_path).to eq user_path(User.find_by(email: @user.email))
      expect(page.title).to eq "#{@user.name} | Ruby on Rails Tutorial Sample App"
      expect(page).to have_content @user.name
      expect(page).to have_selector("img[src$='food_pizza.png']")
    end

    it '無効なサインアップ → フォームへ戻る' do
      visit signup_path

      fill_in 'Name', with: ''
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Confirmation', with: @user.password_confirmation
      attach_file 'Image', Rails.root.join('spec/fixtures/images/food_pizza.png')
      expect { click_button 'Create my account' }.to change(User, :count).by(0)

      expect(current_path).to eq signup_path
      expect(find("input#user_name").value).to eq ''
      expect(find("input#user_email").value).to eq @user.email
      expect(find("input#user_password").value).to eq nil
      expect(find("input#user_password_confirmation").value).to eq nil
      expect(page).to have_content "Name can't be blank"
    end
  end

  describe "ログインについて" do
    context "ユーザが登録されている場合" do
      before do
        @user.save
      end

      it "ログインに失敗 → ログイン画面へリダイレクト" do
        visit login_path

        fill_in 'Email', with: 'aaaa@example.com'
        fill_in 'Password', with: @user.password
        expect { click_button 'Log in' }.to_not change{current_path}

        expect(find("input#session_email").value).to eq nil
        expect(find("input#session_password").value).to eq nil
        expect(page).to have_content 'Invalid email/password combination'
      end

      it "フラッシュメッセージの残留テスト" do
        #ログイン画面
        visit login_path
        fill_in 'Email', with: 'aaaa@example.com'
        fill_in 'Password', with: @user.password
        expect { click_button 'Log in' }.to_not change{current_path}

        #ログイン失敗画面
        expect(find("input#session_email").value).to eq nil
        expect(find("input#session_password").value).to eq nil
        expect(page).to have_content 'Invalid email/password combination'

        #ルートパスに遷移
        visit root_path
        expect(page).to_not have_content 'Invalid email/password combination'
      end

      it "ログインからログアウトを通した表示テスト" do
        visit root_path
        expect(page).to have_content 'Log in'
        expect(page).to_not have_content 'Log out'
        expect(page).to_not have_content 'Profile'

        click_link 'Log in'
        fill_in 'Email', with: @user.email
        fill_in 'Password', with: @user.password
        expect { click_button 'Log in' }.to change{current_path}.from(login_path).to(user_path(@user))
        expect(page).to have_content @user.name
        expect(page).to_not have_content 'Log in'
        expect(page).to have_content 'Log out'
        expect(page).to have_content 'Profile'

        click_link 'Log out'
        expect(page).to have_content 'Log in'
        expect(page).to_not have_content 'Log out'
        expect(page).to_not have_content 'Profile'
      end
    end

    context "ユーザが登録されていない場合" do
      ###
    end
  end
end
