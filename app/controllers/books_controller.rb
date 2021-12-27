class BooksController < ApplicationController
  before_action :correct_user, only: [:edit, :update]

  def index
    @book = Book.new
    @books = Book.all
    @user = current_user
  end

  def show
    @book = Book.new
    @books = Book.find(params[:id])
    @user = @books.user #投稿したユーザーを@userに代入している
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id #この本は誰が投稿するのかを宣言しないといけない。関連付ける箇所は、本を作る時である。つまり、books_contorollerのcreateアクション内でに記載する必要がある。
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @books = Book.all #これを入れないとrenderしたときにエラーが起きる
      @user = current_user#上と同じくrenderしたときに定義されていないというエラーが起きる
      render :index
    end

  end

  def edit
    @book = Book.find(params[:id])
    if @book.user = current_user #もし、投稿したユーザーとログインしているユーザーが同じなら編集画面に行く
      render :edit
    else
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id), notice: "You have updated book successfully."
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def correct_user
    user = Book.find(params[:id])
    if current_user.id != user.id
      redirect_to books_path
    end
  end

  def book_params
    params.require(:book).permit(:title, :body)
  end

end
