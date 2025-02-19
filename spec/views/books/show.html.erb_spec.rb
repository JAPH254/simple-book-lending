require 'rails_helper'

RSpec.describe "books/show.html.erb", type: :view do
  let(:book) do
    FactoryBot.create(
      :book,
      title: "Sample Book",
      author: "John Doe",
      isbn: "1234567890123",
      available: true
    )
  end

  before do
    assign(:book, book)
  end

  context "when the book is available" do
    before do
      allow(book.borrowings).to receive_message_chain(:where, :exists?).and_return(false)
    end

    it "renders the book details and displays the Borrow button" do
      render

      expect(rendered).to include("Books")
      expect(rendered).to include("Profile")
      expect(rendered).to include("Logout")

      expect(rendered).to include("Sample Book")
      expect(rendered).to include("John Doe")
      expect(rendered).to include("1234567890123")

      expect(rendered).to include("Borrow")
      expect(rendered).not_to include("This book is already borrowed")
    end
  end

  context "when the book is already borrowed" do
    before do
      # Stub borrowings.where(...).exists? to return true
      allow(book.borrowings).to receive_message_chain(:where, :exists?).and_return(true)
    end

    it "renders the book details and shows a message that the book is already borrowed" do
      render

      # Check book details
      expect(rendered).to include("Sample Book")
      expect(rendered).to include("John Doe")
      expect(rendered).to include("1234567890123")

      # Should display the already borrowed message and not the Borrow button
      expect(rendered).to include("This book is already borrowed")
      expect(rendered).not_to include("Borrow")
    end
  end

  it "displays navigation links for Books, Profile, and a Logout button" do
    render
    expect(rendered).to include("Books")
    expect(rendered).to include("Profile")
    expect(rendered).to include("Logout")
  end
end
