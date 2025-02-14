class Book < ApplicationRecord
    validates :title, :author, :isbn, presence: true
    validates :isbn, uniqueness: true

    has_many :borrowings
    has_many :users, through: :borrowings
end
