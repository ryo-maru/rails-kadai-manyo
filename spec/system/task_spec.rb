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
        fill_in 'Deadline', with: '2021/07/11'
        select '未着手', from: 'task_status'
        #「タスク名」というラベル名の入力欄と、「タスク詳細」というラベル名の入力欄にタスクのタイトルと内容をそれぞれ入力する
        # ここに「タスク名」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
        # ここに「タスク詳細」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
        # 3. 「登録する」というvalue（表記文字）のあるボタンをクリックする
        click_button 'Create Task'
        # ここに「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）する処理を書く
        # 4. clickで登録されたはずの情報が、タスク詳細ページに表示されているかを確認する
        visit tasks_path
        # （タスクが登録されたらタスク詳細画面に遷移されるという前提）


        expect(page).to have_content '未着手'
        # ここにタスク詳細ページに、テストコードで作成したデータがタスク詳細画面にhave_contentされているか（含まれているか）を確認（期待）するコードを書く
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        # テストで使用するためのタスクを作成
        task = FactoryBot.create(:task, title: 'task', deadline: '2021/07/11', status: '未着手')
        # タスク一覧ページに遷移
        visit tasks_path
        # visitした（遷移した）page（タスク一覧ページ）に「task」という文字列が
        # have_contentされているか（含まれているか）ということをexpectする（確認・期待する）
        expect(page).to have_content '未着手'
        # expectの結果が true ならテスト成功、false なら失敗として結果が出力される

      end
    end

    describe '詳細表示機能' do
      context '任意のタスク詳細画面に遷移した場合' do
        it '該当タスクの内容が表示される' do
          @task = FactoryBot.create(:task,title: 'task1',content: 'content1', deadline: '2021/07/11', status: '未着手')


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



      describe '検索機能' do
        before do
          visit new_task_path
          fill_in 'Title', with: 'task1'
          fill_in 'Content', with: 'content1'
          fill_in 'Deadline', with: '2021/07/11'
          select '未着手', from: 'task_status'
          click_button 'Create Task'
          visit new_task_path
          fill_in 'Title', with: 'test2'
          fill_in 'Content', with: 'content2'
          fill_in 'Deadline', with: '2021/07/12'
          select '未着手', from: 'task_status'
          click_button 'Create Task'
        end
        context 'タイトルであいまい検索をした場合' do
          it "検索キーワードを含むタスクで絞り込まれる" do
            visit tasks_path
            fill_in 'task_title', with: 'task'
            click_on '検索'
            expect(page).to have_content 'task'
          end
        end

        context 'ステータス検索をした場合' do
          it "ステータスに完全一致するタスクが絞り込まれる" do
            visit tasks_path
            select "未着手", from: "task_status"
            click_on '検索'
            expect(page).to have_content '未着手'
          end
        end



        context 'タイトルのあいまい検索とステータス検索をした場合' do
          it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
            visit new_task_path
         task = FactoryBot.create(:task, title: 'task', status: '未着手')
            visit tasks_path
            fill_in 'task_title', with: 'task'
            select "未着手", from: "task_status"
            click_on '検索'
            expect(page).to have_content 'task'
            expect(page).to have_content '未着手'
          end
        end


        describe '優先順位での並び変え' do
    context '優先順位でソートするボタンを押した場合' do
      it '優先順位の昇順で表示される' do
        visit tasks_path
        click_on '優先順位でソートする'
        sleep 0.5
        test_list = all('.sort_priority')
        expect(test_list[0]).to have_content '高'
      end
    end
  end
      end
    end
  end
end
