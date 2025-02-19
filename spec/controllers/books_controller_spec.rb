require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  let!(:book) { FactoryBot.create(:book, available: true) }
  let!(:borrowed_book) { FactoryBot.create(:book, available: false) }
  let!(:borrowing) { FactoryBot.create(:borrowing, user: user, book: borrowed_book, returned_at: nil) }

  before do
    allow(controller).to receive(:require_authentication).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'assigns all books to @books' do
      get :index
      expect(assigns(:books)).to include(book, borrowed_book)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested book to @book' do
      get :show, params: { id: book.id }
      expect(assigns(:book)).to eq(book)
    end
  end

  describe 'POST #borrow' do
    context 'when the book is available' do
      it 'allows the user to borrow the book' do
        post :borrow, params: { id: book.id }
        expect(flash[:notice]).to include("You have successfully borrowed")
        expect(book.reload.available).to be_falsey
      end
    end

    context 'when the book is already borrowed by someone else' do
      let!(:other_user) { FactoryBot.create(:user, username: "otheruser", email_address: "other@example.com") }
      let!(:other_borrowed_book) { FactoryBot.create(:book, available: false) }
      let!(:other_borrowing) { FactoryBot.create(:borrowing, user: other_user, book: other_borrowed_book, returned_at: nil) }
      
      it 'prevents borrowing' do
        post :borrow, params: { id: other_borrowed_book.id }
        expect(flash[:alert]).to include("This book is already borrowed")
      end
    end

    context 'when the user has already borrowed the same book' do
      it 'prevents double borrowing by the same user' do
        FactoryBot.create(:borrowing, user: user, book: book, returned_at: nil)
        post :borrow, params: { id: book.id }
        expect(flash[:alert]).to include("You have already borrowed this book")
      end
    end
  end

  describe 'PATCH #return_book' do
    it 'allows the user to return a borrowed book' do
      patch :return_book, params: { id: borrowed_book.id }
      expect(flash[:notice]).to include("You have successfully returned")
      expect(borrowing.reload.returned_at).not_to be_nil
      expect(borrowed_book.reload.available).to be_truthy
    end
  end
end
