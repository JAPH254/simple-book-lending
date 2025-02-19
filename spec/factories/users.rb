FactoryBot.define do
    factory :user do
      username { "Test User" }
      email_address { "test@example.com" }
      password { "password" }
    end
  end
  