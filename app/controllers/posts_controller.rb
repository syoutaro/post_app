class PostsController < ApplicationController
  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      flash[:notice] = '投稿しました'
    else
      flash[:alert] = '投稿に失敗しました'
    end
    redirect_to :root
  end

  protected

  def post_params
    params.require(:post).permit(:body)
  end
end
