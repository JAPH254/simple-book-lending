FactoryBot.define do
    factory :borrowing do
      association :user
      association :book
      due_date { 2.weeks.from_now }
      returned_at { nil }
    end
  end
  