class RelationshipsController < ApplicationController
  #ユーザーモデルに記載したメソッドを使って記述していく
  
  #フォローするとき
  def create
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end 
  
  #フォロー外すとき
  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end 
  
  #フォロー一覧
  def followings
    user = User.find(params[:user_id])
    @user = user.followings
  end
  
  
  #フォロワー一覧
  def followers
    user = User.find(params[:user_id])
    @user = user.followers
  end
  
end
