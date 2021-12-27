class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @users = User.all
    @user = current_user
    @book = Book.new
  end

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user #もし、ユーザー詳細画面とログインしているユーザーが同じだったら、編集画面を開く
      render :edit
    else
      redirect_to user_path(id: current_user)
    end

  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render :edit
    end

  end

  private

  def user_params
    params.require(:user).permit(:name, :introducrion, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user #編集画面のユーザーとログインしているユーザーが同じでなかったら
      redirect_to user_path(current_user) #ログインしているユーザーの詳細ページ（マイページ）に遷移する
    end
  end

end
