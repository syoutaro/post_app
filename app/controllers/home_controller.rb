class HomeController < ApplicationController
  def index
    @user = current_user
    @posts = Post.page(params[:page]).per(8).order('updated_at DESC')
  end
end
