class BooksController < ApplicationController
  before_action :require_authentication

  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def borrow
    book = Book.find(params[:id])

    if book.borrowings.where(returned_at: nil).exists?
      redirect_to book_path(book), alert: "This book is already borrowed."
    else
      borrowing = book.borrowings.create(user: current_user, due_date: 2.weeks.from_now)
      redirect_to profile_path, notice: "You have successfully borrowed #{book.title}. Due date: #{borrowing.due_date.strftime('%B %d, %Y')}."
    end
  end

  def return_book
    borrowing = current_user.borrowings.find_by(book_id: params[:id], returned_at: nil)

    if borrowing
      borrowing.update(returned_at: Time.current)
      redirect_to profile_path, notice: "You have successfully returned #{borrowing.book.title}!"
    else
      redirect_to profile_path, alert: "You haven't borrowed this book or it was already returned."
    end
  end
end
