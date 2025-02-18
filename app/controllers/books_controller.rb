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

    existing_borrowing = book.borrowings.find_by(user: current_user, returned_at: nil)
    if existing_borrowing
      redirect_to book_path(book), alert: "You have already borrowed this book. Please return it before borrowing again."
      return
    end

    if book.borrowings.where(returned_at: nil).exists?
      redirect_to book_path(book), alert: "This book is already borrowed by someone else."
    else
      if book.available?
        borrowing = book.borrowings.create(user: current_user, due_date: 2.weeks.from_now)
        book.update(available: false)  
        redirect_to profile_path, notice: "You have successfully borrowed #{book.title}. Due date: #{borrowing.due_date.strftime('%B %d, %Y')}."
      else
        redirect_to book_path(book), alert: "This book is currently unavailable."
      end
    end
  end

  def return_book
    borrowing = current_user.borrowings.find_by(book_id: params[:id], returned_at: nil)

    if borrowing
    
      borrowing.update(returned_at: Time.current)

      borrowing.book.update(available: true) 

      redirect_to profile_path, notice: "You have successfully returned #{borrowing.book.title}!"
    else
      redirect_to profile_path, alert: "You haven't borrowed this book or it was already returned."
    end
  end
end
