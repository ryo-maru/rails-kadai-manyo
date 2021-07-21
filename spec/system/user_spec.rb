require 'rails_helper'
RSpec.describe 'ユーザ登録・ログイン・ログアウト機能・管理画面テスト', type: :system do

  before do
    @user = User.find_by(email: FactoryBot.create(:user).email) || FactoryBot.create(:user)
    @second_user = User.find_by(email: FactoryBot.create(:second_user).email) || FactoryBot.create(:second_user)
  #  if login = logout and visit root page
  end

  describe 'ユーザ登録のテスト' do
    context 'ユーザ新規登録' do
      it '自身の名が入ったページへアクセスできる' do
        visit new_user_path
        fill_in 'user_name', with: 'maruyama_test02'
        fill_in 'user_email', with: 'maruyama_test02@example.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_on 'Create my account'
        expect(page).to have_content 'maruyama_test02'
      end
    end

    context 'ログインなしでタスク一覧にアクセス' do
      it '​ログインしていない時はログイン画面に飛ぶテスト​' do
        visit tasks_path
        expect(current_path).to eq new_session_path
      end
    end
  end

  describe 'セッション機能テスト' do
    before do
    visit new_session_path
    fill_in 'session_email', with: @user.email
    fill_in 'session_password', with: FactoryBot.build(:user).password
    click_on 'Log in'
    visit tasks_path
    expect(page).to have_content 'タスク一覧'
    click_link "Logout"
    expect(page).to have_content "ログアウトしました"
    end

    context 'ログインした場合' do
      it '自分の詳細画面に飛べること' do
        visit new_session_path
        fill_in 'session_email',with: @user.email
        fill_in 'session_password',with: FactoryBot.build(:user).password
        click_on 'Log in'
        click_link "Profile"
        expect(page).to have_content "#{@user.name}のページ"
        click_link "Logout"
        expect(page).to have_content "ログアウトしました"
      end
    end

      it "他人の詳細画面に飛ぶとタスク一覧ページに遷移すること" do
        visit new_session_path
        fill_in 'session[email]',with: @user.email
        fill_in 'session[password]',with: FactoryBot.build(:user).password
        click_on 'Log in'


        visit user_path(@second_user.id)
        expect(page).to have_content 'タスク一覧'
        click_link "Logout"
        expect(page).to have_content "ログアウトしました"

      end


    context 'ログアウトした場合' do
      it "ログイン画面に戻る" do
        visit new_session_path
        fill_in 'session_email',with: @user.email
        fill_in 'session_password',with: FactoryBot.build(:user).password
        click_on 'Log in'

        visit tasks_path
        click_link "Logout"
        expect(page).to have_content "ログアウトしました"
      end
    end
  end

  describe "管理画面のテスト" do
      context "管理ユーザ作成" do
        it "管理者は管理画面にアクセスできること" do
          visit new_session_path
          fill_in 'session_email',with: @second_user.email
          fill_in 'session_password',with: FactoryBot.build(:second_user).password
          click_on 'Log in'
          visit admin_users_path
          expect(page).to have_content "Users"

          click_link "Logout"
          expect(page).to have_content "ログアウトしました"
        end
      end

      context "一般ユーザーがログインしている場合" do
        it "一般ユーザーは管理画面にはアクセスできない" do
          visit new_session_path
          fill_in 'session_email',with: @user.email
          fill_in 'session_password',with: FactoryBot.build(:user).password
          click_on 'Log in'
          visit admin_users_path
          expect(page).to have_content "管理者以外はアクセスできません。"
          click_link "Logout"
          expect(page).to have_content "ログアウトしました"
        end
      end

      context "管理者でログインしている場合" do
        before do
          visit new_session_path
          fill_in 'session_email',with: @second_user.email
          fill_in 'session_password',with: FactoryBot.build(:second_user).password
          click_on "Log in"
          visit admin_users_path
        end

        it "管理者はユーザ新規登録ができる" do

          click_link "新規ユーザー登録"
          fill_in "user_name", with: "Saburou Suzuki"
          fill_in "user_email", with: "suzuki33@example.com"
          fill_in "user_password", with: "suzuki"
          fill_in "user_password_confirmation", with: "suzuki"
          click_on "登録"
          expect(page).to have_content "Saburou Suzukiを登録しました。"
          click_link "Logout"
          expect(page).to have_content "ログアウトしました"
        end

        it "管理者はユーザの詳細画面へ行ける" do
          visit admin_user_path(@user)
          expect(page).to have_content "test01のページ"
          click_link "Logout"
          expect(page).to have_content "ログアウトしました"
        end

        it "管理者ユーザーの編集画面からユーザーの編集ができる" do
          visit edit_admin_user_path(@user)
          fill_in 'user_name', with: 'Saburou Suzuki43'
          fill_in 'user_email', with: 'suzuki43@example.com'
          check 'user_admin'
          fill_in 'user_password', with: 'suzuki'
          fill_in 'user_password_confirmation', with: 'suzuki'
          click_button '登録'
          expect(page).to have_content "Saburou Suzuki43のページ"
          click_link "Logout"
          expect(page).to have_content "ログアウトしました"
        end

        it "管理者はユーザーを削除できる" do
          visit admin_users_path
          click_link "削除", match: :first
        end
      end
  end
end
