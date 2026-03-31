class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_post, only: :show
  before_action :set_owned_post, only: %i[ edit update destroy ]

  def index
    @current_tag = normalize_tag_param(params[:tag])

    @posts = filtered_scope(Post.published.with_rich_text_body.includes(:tags)).recent_first

    if user_signed_in?
      @draft_posts = filtered_scope(current_user.posts.unpublished.with_rich_text_body.includes(:tags)).recent_first
    end
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params.except(:tag_list))
    @post.tag_list = post_params[:tag_list]

    if @post.save
      @post.update_tags_from_list(post_params[:tag_list])
      redirect_to @post, notice: @post.published? ? "Post published." : "Draft saved."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    @post.tag_list = post_params[:tag_list]

    if @post.update(post_params.except(:tag_list))
      @post.update_tags_from_list(post_params[:tag_list])
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
    scope = Post.with_rich_text_body_and_embeds.includes(:tags)
    scope = if user_signed_in?
      scope.where("posts.published = ? OR posts.user_id = ?", true, current_user.id)
    else
      scope.published
    end

    @post = scope.find_by!(slug: params[:id])
  end

  def set_owned_post
    @post = current_user.posts.with_rich_text_body_and_embeds.includes(:tags).find_by!(slug: params[:id])
  end

  def post_params
    params.expect(post: [ :title, :body, :published, :tag_list ])
  end

  def filtered_scope(scope)
    return scope if @current_tag.blank?

    scope.joins(:tags).where(tags: { name: @current_tag }).distinct
  end

  def normalize_tag_param(raw_tag)
    raw_tag.to_s.strip.downcase.presence
  end
end
