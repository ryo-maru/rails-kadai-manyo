require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  before do
    # あらかじめタスク一覧のテストで使用するためのタスクを二つ作成する
    @task = FactoryBot.create(:task,title: 'task_title')
    @task = FactoryBot.create(:second_task)
  end

  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
      # 1. new_task_pathに遷移する（新規作成ページに遷移する）
      visit new_task_path
      # ここにnew_task_pathにvisitする処理を書く
      # 2. 新規登録内容を入力する
      fill_in 'Title', with: 'task_title'
      fill_in 'Content', with: 'task_content'
      #「タスク名」というラベル名の入力欄と、「タスク詳細」というラベル名の入力欄にタスクのタイトルと内容をそれぞれ入力する
      # ここに「タスク名」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
      # ここに「タスク詳細」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
      # 3. 「登録する」というvalue（表記文字）のあるボタンをクリックする
      click_button 'Create Task'
      # ここに「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）する処理を書く
      # 4. clickで登録されたはずの情報が、タスク詳細ページに表示されているかを確認する
      visit tasks_path
      # （タスクが登録されたらタスク詳細画面に遷移されるという前提）


      expect(page).to have_content 'task_content'
      # ここにタスク詳細ページに、テストコードで作成したデータがタスク詳細画面にhave_contentされているか（含まれているか）を確認（期待）するコードを書く
      end
    end
  end
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
        it '作成済みのタスク一覧が表示される' do
        # テストで使用するためのタスクを作成
        task = FactoryBot.create(:task, title: 'task')
        # タスク一覧ページに遷移
        visit tasks_path
        # visitした（遷移した）page（タスク一覧ページ）に「task」という文字列が
        # have_contentされているか（含まれているか）ということをexpectする（確認・期待する）
        expect(page).to have_content 'task'
        # expectの結果が true ならテスト成功、false なら失敗として結果が出力される

        end
    end
  end
  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it '該当タスクの内容が表示される' do
          @task = FactoryBot.create(:task,title: 'task1',content: 'content1')


         visit task_path(@task)

        expect(page).to have_content 'task1'
        expect(page).to have_content 'content1'

       end
     end
  end

  describe 'タスクを作成日時の降順に変更する機能' do
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
     task1 =  FactoryBot.create(:task, title: 'task1')
     task2 =  FactoryBot.create(:task, title: 'task2')
     visit tasks_path
     task_list = all('.task_row')
     expect(page).to have_content 'task2'
     expect(page).to have_content 'task1'
     end
    end
  end
end
