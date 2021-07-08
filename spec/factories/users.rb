FactoryBot.define do
  factory :user do
    name {'testuser01'}
    email {'testuser01@docomo.ne.jp'}
    password {'password'}
    admin {false}
  end
  factory :user2 ,class: User do
    name {'admin01'}
    email {'admin01@docomo.ne.jp'}
    password {'password'}
    admin {true}
  end

end 