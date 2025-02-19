FactoryBot.define do
    factory :book do
      title { "Test Book" }
      author { "John Doe" }
      sequence(:isbn) { |n| "978-3-16-14841#{n}" }
      available { true }
    end
  end
  