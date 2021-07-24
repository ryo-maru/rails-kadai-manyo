FactoryBot.define do


  factory :task do
    title { 'Factoryで作ったデフォルトのタイトル１' }
    content { 'Factoryで作ったデフォルトのコンテント１' }
    deadline { DateTime.now }
    status {'未着手'}
    priority { '中' }
    
    #user.name {'太郎'}
    association :user
  end
  # 作成するテストデータの名前を「second_task」とします
  # （存在しないクラス名の名前をつける場合、オプションで「このクラスのテストデータにしてください」と指定します）
  factory :second_task, class: Task do
    title { 'Factoryで作ったデフォルトのタイトル２' }
    content { 'Factoryで作ったデフォルトのコンテント２' }
    deadline { DateTime.now }
    status {'完了'}
    priority { '中' }
    #user.name {'太郎'}
  # association :second_user
  end
end
