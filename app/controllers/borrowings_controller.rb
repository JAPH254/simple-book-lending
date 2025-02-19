class BorrowingsController < ApplicationController
    before_action :require_authentication
  
    def create
      @book = Book.find(params[:book_id])
      @user = current_user
    
      if @book.available?
        @book.update(available: false)
        @borrowing = Borrowing.create(user: @user, book: @book, due_date: 2.weeks.from_now)
    
        redirect_to profile_path, notice: "You have successfully borrowed '#{@book.title}'. Due date: #{@borrowing.due_date.strftime('%B %d, %Y')}."
      else
        redirect_to books_path, alert: "This book is currently unavailable."
      end
    end
    
  
    def return_book
      @book = Book.find(params[:book_id])
      @user = current_user
      @borrowing = Borrowing.find_by(user: @user, book: @book, returned_at: nil)
  
      if @borrowing
        @borrowing.update(returned_at: Time.current)
        @book.update(available: true) 
        redirect_to profile_path, notice: "You have successfully returned '#{@book.title}'."
      else
        redirect_to profile_path, alert: "You haven't borrowed this book or it's already returned."
      end
    end
  end
  