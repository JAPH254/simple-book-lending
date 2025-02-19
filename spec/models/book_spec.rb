require 'rails_helper'

RSpec.describe Book, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to validate_presence_of(:isbn) }
    it { is_expected.to validate_uniqueness_of(:isbn) }
  end

  describe "associations" do
    it { is_expected.to have_many(:borrowings) }
    it { is_expected.to have_many(:users).through(:borrowings) }
  end

  describe "default availability" do
    it "sets available to true if not provided" do
      book = Book.new(title: "Test Book", author: "Test Author", isbn: "1234567890123", available: nil)
      # Trigger validations which will call after_initialize if needed
      book.valid?
      expect(book.available).to eq(true)
    end
  end

  describe ".available scope" do
    before do
      @available_book = Book.create!(title: "Available Book", author: "Author A", isbn: "1111111111111", available: true)
      @unavailable_book = Book.create!(title: "Unavailable Book", author: "Author B", isbn: "2222222222222", available: false)
    end

    it "returns only books that are available" do
      expect(Book.available).to include(@available_book)
      expect(Book.available).not_to include(@unavailable_book)
    end
  end

  describe "#available?" do
    it "returns the available attribute" do
      book = Book.create!(title: "Sample Book", author: "Author", isbn: "3333333333333", available: false)
      expect(book.available?).to eq(false)
      book.update(available: true)
      expect(book.available?).to eq(true)
    end
  end
end
