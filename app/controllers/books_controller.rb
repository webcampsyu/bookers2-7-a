class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @books = Book.new
    @user = @book.user
    @book_comment = BookComment.new
  end

  def index
    @book = Book.new
    
    #いいね数を多い順に表示するための記述
    to = Time.current.at_end_of_day #Time.currentはapplication.rbに設定してあるタイムゾーンを元に現在日時を取得
    from = (to - 6.day).at_beginning_of_day 
    @books = Book.includes(:favorited_users). #Book.allで全ての投稿データを取得していたが、毎回「誰が投稿したか」という情報をユーザテーブルに取りに行っている
                                              #includesで関連するテーブルをまとめて取得する
                                              #モデル.includes(引数)
     sort_by {|x| #sort_byメソッドでいいね数の少ない順に取り出す
                  #|x|を定義しないと2よりも10,11ノほうが小さいと判定されてしまう
      x.favorited_users.includes(:favorites).where(created_at: from...to).size
     }.reverse #sort_byメソッドで少ない順に取り出しているため、reverseで多い順に入れ替える
    @user = User.find(current_user.id)
    
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    unless @book.user.id == current_user.id
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
  
end
