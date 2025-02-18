class UsersController < ApplicationController
  # Only require authentication for the profile action
  before_action :require_authentication, only: [:profile]

  def profile
    @user = current_user
    @borrowed_books = @user.borrowings.where(returned_at: nil).includes(:book)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "User created successfully!"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :username, :password)
  end
end
