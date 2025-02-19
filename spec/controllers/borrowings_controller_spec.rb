require 'rails_helper'

RSpec.describe BorrowingsController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  let!(:book) { FactoryBot.create(:book, available: true) }
  # Create a borrowed book (unavailable) and a borrowing record for the current user.
  let!(:borrowed_book) { FactoryBot.create(:book, available: false) }
  let!(:borrowing) { FactoryBot.create(:borrowing, user: user, book: borrowed_book, returned_at: nil) }

  before do
    # Bypass authentication so the actions run
    allow(controller).to receive(:require_authentication).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "POST #create" do
    context "when the book is available" do
      it "creates a borrowing record and marks the book as unavailable" do
        post :create, params: { book_id: book.id }
        expect(response).to redirect_to(profile_path)
        expect(flash[:notice]).to include("You have successfully borrowed")
        expect(book.reload.available).to be_falsey
      end
    end

    context "when the book is unavailable" do
      it "redirects to books path with an alert" do
        book.update(available: false)
        post :create, params: { book_id: book.id }
        expect(response).to redirect_to(books_path)
        expect(flash[:alert]).to include("This book is currently unavailable")
      end
    end
  end

  describe "PATCH #return_book" do
    context "when a borrowing record exists" do
      it "marks the borrowing as returned and the book as available" do
        patch :return_book, params: { book_id: borrowed_book.id }
        expect(response).to redirect_to(profile_path)
        expect(flash[:notice]).to include("You have successfully returned")
        expect(borrowing.reload.returned_at).not_to be_nil
        expect(borrowed_book.reload.available).to be_truthy
      end
    end

    context "when no borrowing record exists for the user" do
      it "redirects to profile with an alert" do
        # Use a book that has not been borrowed by the current user.
        another_book = FactoryBot.create(:book, available: true)
        patch :return_book, params: { book_id: another_book.id }
        expect(response).to redirect_to(profile_path)
        expect(flash[:alert]).to include("You haven't borrowed this book")
      end
    end
  end
end
