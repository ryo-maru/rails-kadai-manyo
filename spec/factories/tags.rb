FactoryBot.define do
  factory :tag_1 ,class: Tag do
    name { "学習" }
  end

  factory :tag_2 ,class: Tag do
    name { "仕事" }
  end

  factory :tag_3, class: Tag do
    name { "買物" }
  end
end
