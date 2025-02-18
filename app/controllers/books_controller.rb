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

    # Check if the current user has already borrowed this book and hasn't returned it
    existing_borrowing = book.borrowings.find_by(user: current_user, returned_at: nil)
    if existing_borrowing
      redirect_to book_path(book), alert: "You have already borrowed this book. Please return it before borrowing again."
      return
    end

    # Check if the book is already borrowed by someone else
    if book.borrowings.where(returned_at: nil).exists?
      redirect_to book_path(book), alert: "This book is already borrowed by someone else."
    else
      # Check if the book is available
      if book.available?
        # Create a new borrowing record for the current user
        borrowing = book.borrowings.create(user: current_user, due_date: 2.weeks.from_now)
        book.update(available: false)  # Mark the book as borrowed (not available)
        redirect_to profile_path, notice: "You have successfully borrowed #{book.title}. Due date: #{borrowing.due_date.strftime('%B %d, %Y')}."
      else
        redirect_to book_path(book), alert: "This book is currently unavailable."
      end
    end
  end

  def return_book
    borrowing = current_user.borrowings.find_by(book_id: params[:id], returned_at: nil)

    if borrowing
      # Mark the book as returned
      borrowing.update(returned_at: Time.current)

      # Update the book's availability
      borrowing.book.update(available: true)  # Book is now available to borrow again

      redirect_to profile_path, notice: "You have successfully returned #{borrowing.book.title}!"
    else
      redirect_to profile_path, alert: "You haven't borrowed this book or it was already returned."
    end
  end
end
