class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :book_id, uniqueness: { scope: :returned_at, message: "can't be borrowed multiple times" }
end
