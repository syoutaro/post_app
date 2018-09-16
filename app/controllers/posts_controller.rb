class PostsController < ApplicationController
  def create
    if current_user.posts.create(post_params)
      flash[:notice] = '投稿しました。'
    else
      flash[:error] = '投稿に失敗しました。'
    end

    redirect_to :root
  end

  protected

  def post_params
    params.require(:post).permit(:body)
  end
end
