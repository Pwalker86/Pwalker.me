class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_post, only: :show
  before_action :set_owned_post, only: %i[ edit update destroy ]

  def index
    @posts = Post.published.with_rich_text_body.recent_first
    @draft_posts = current_user.posts.unpublished.with_rich_text_body.recent_first if user_signed_in?
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: @post.published? ? "Post published." : "Draft saved."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: @post.published? ? "Post updated." : "Draft updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @post.destroy

    redirect_to posts_path, notice: "Post deleted."
  end

  private

  def set_post
    scope = Post.with_rich_text_body_and_embeds
    scope = if user_signed_in?
      scope.where("posts.published = ? OR posts.user_id = ?", true, current_user.id)
    else
      scope.published
    end

    @post = scope.find_by!(slug: params[:id])
  end

  def set_owned_post
    @post = current_user.posts.with_rich_text_body_and_embeds.find_by!(slug: params[:id])
  end

  def post_params
    params.expect(post: [ :title, :body, :published ])
  end
end
