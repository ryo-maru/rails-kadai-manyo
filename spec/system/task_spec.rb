require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do

  before do
    visit new_user_path
    fill_in 'user_name', with: 'suzuki_test121'
    fill_in 'user_email', with: 'suzuki_test121@example.com'
    fill_in 'user_password', with: 'suzuki'
    fill_in 'user_password_confirmation', with: 'suzuki'
    click_on 'Create my account'
    visit tasks_path
  end

  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in 'Title', with: 'task_title'
        fill_in 'Content', with: 'task_content'
        fill_in 'Deadline', with: '2021/07/30'
        select '未着手', from: 'task_status'
        select '中', from: 'task_priority'
        click_button 'Create Task'
        visit tasks_path
        expect(page).to have_content '未着手'
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        visit tasks_path
        expect(page).to have_content '未着手'
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
          second_user = FactoryBot.create(:second_user)
          @task = FactoryBot.create(:second_task,title: 'task1',content: 'content1', deadline: '2021/07/30', status: '未着手', priority: '中',user_id: second_user.id )
          visit task_path(@task)
          expect(page).to have_content 'task1'
          expect(page).to have_content 'content1'

      end
    end
  end

  describe 'タスクを作成日時の降順に変更する機能' do
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        visit new_task_path
        fill_in 'Title', with: 'task1'
        fill_in 'Content', with: 'content1'
        fill_in 'Deadline', with: '002021/07/30'
        select '未着手', from: 'task_status'
        select '中', from: 'task_priority'
        click_button 'Create Task'
        visit new_task_path
        fill_in 'Title', with: 'task2'
        fill_in 'Content', with: 'content2'
        fill_in 'Deadline', with: '002021/07/30'
        select '未着手', from: 'task_status'
        select '高', from: 'task_priority'
        click_button 'Create Task'
        visit tasks_path

        expect(page).to have_content 'task2'
        expect(page).to have_content 'task1'
      end
    end
  end

  describe '検索機能' do
    before do
      visit new_task_path
      fill_in 'Title', with: 'task1'
      fill_in 'Content', with: 'content1'
      fill_in 'Deadline', with: '002021/07/30'
      select '未着手', from: 'task_status'
      select '中', from: 'task_priority'
      click_button 'Create Task'
      visit new_task_path
      fill_in 'Title', with: 'test2'
      fill_in 'Content', with: 'content2'
      fill_in 'Deadline', with: '002021/07/30'
      select '未着手', from: 'task_status'
      select '高', from: 'task_priority'
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
        second_user = FactoryBot.create(:second_user)
        @task = FactoryBot.create(:second_task,title: 'task1',content: 'content1', deadline: '2021/07/30', status: '未着手', priority: '中',user_id: second_user.id )

        visit tasks_path
        fill_in 'task_title', with: 'task1'
        select "未着手", from: "task_status"
        click_on '検索'
        expect(page).to have_content 'task1'
        expect(page).to have_content '未着手'
      end
    end
  end

  describe '優先順位での並び変え' do
    context '優先順位でソートするボタンを押した場合' do
      it '優先順位の昇順で表示される' do
        #user = FactoryBot.create(:user)
        #second_user = FactoryBot.create(:second_user)
        #@task = FactoryBot.create(:second_task,title: 'task1',content: 'content1', deadline: '2021/07/30', status: '未着手', priority: '中', user_id: user.id )
        #@second_task = FactoryBot.create(:second_task,title: 'task2',content: 'content2', deadline: '2021/07/30', status: '未着手', priority: '高', user_id: second_user.id)
        visit new_task_path
        fill_in 'Title', with: 'task1'
        fill_in 'Content', with: 'content1'
        fill_in 'Deadline', with: '002021/07/30'
        select '未着手', from: 'task_status'
        select '中', from: 'task_priority'
        click_button 'Create Task'
        visit new_task_path
        fill_in 'Title', with: 'task2'
        fill_in 'Content', with: 'content2'
        fill_in 'Deadline', with: '002021/07/30'
        select '未着手', from: 'task_status'
        select '高', from: 'task_priority'
        click_button 'Create Task'

        visit tasks_path
        click_on '優先順位でソートする'
        sleep 1
        task_list = all('.sort_priority')
        expect(task_list[0]).to have_content '高'
        expect(task_list[1]).to have_content '中'
      end
    end
  end
end
