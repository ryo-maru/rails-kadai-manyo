FactoryBot.define do
  factory :user do
    name { 'test01' }
    email { 'test@example.com' }
    password { 'password' }
    admin { false }
  end
  factory :second_user, class: User do
    name { 'test02' }
    email { 'test02@example.com' }
    password { 'password' }
    admin { true }

  end
  factory :admin_user,class: User do
    name { "admin" }
    email { "admin@test.com" }
    password { "password" }
    admin { true }
  end
end
