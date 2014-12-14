FactoryGirl.define do
  factory :user do
    first_name "Test"
    last_name "User"
    sequence(:email) { |n| "foo#{n}@test.com" }
    password "secretpassword"
    phone "555-5555"
    confirmed_at Time.now

    trait :superadmin do
      first_name 'super'
      last_name 'admin'
      after(:create) do |superuser|
        super_role = create(:role)
        superuser.roles << super_role
      end
    end
  end

  factory :role do
    name "superadmin"
  end
end