class Book < ApplicationRecord
    validates :title, :author, :isbn, presence: true
    validates :isbn, uniqueness: true
  
    has_many :borrowings
    has_many :users, through: :borrowings
  
    scope :available, -> { where(available: true) }
  
    after_initialize :set_default_availability, if: :new_record?
  
    def available?
      available
    end
  
    private
  
    def set_default_availability
      self.available = true if available.nil?
    end
  end
  