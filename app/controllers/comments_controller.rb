class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attributes, only: %i[index create show update destroy]
  before_action :verify_list_owner, only: %i[create update remove]
  before_action :verify_actions_permissions, only: %i[update destroy]

  # return all comments for card OR for comment
  def index
    if params[:comment_id].nil?
      render json: {
        comments: @card.comments.paginate(page: params[:page], per_page: 3)
      }, statues: :ok
    else
      @comment = Comment.find(params[:comment_id])
      render json: {
        comment: @comment,
        replaies: @comment.replaies.paginate(page: params[:page], per_page: 3)
      }, statues: :ok
    end
  end
  
  # return a comment with replaies
  def show
    render json: { comment: @comment, replaies: @comment.replaies }, status: :ok
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    if params[:comment_id].nil?
      @comment.card_id = @card.id
    else
      @comment.replay_id = params[:comment_id]
    end

    if @comment.save
      render json: { comment: @comment }, status: :created
    else
      render json: { errors: @comment.errors.full_messages },
             status: :bad_request
    end
  end

  def update
    if @comment.update(comment_params)
      render json: { comment: @comment }, status: :ok
    else
      render json: {
        errors: @comment.errors.full_messages
      }, status: :bad_request
    end
  end

  def destroy
    if @comment
      @comment.destroy
      render nothing: true, status: :no_content
    else
      render json: {
        error: I18n.t('not_found')
      }, status: :not_found
    end
  end

  private

  def set_attributes
    @comment = Comment.find_by(id: params[:id]) unless params[:id].nil?
    @card = Card.find_by(id: params[:card_id])
    @list = List.find_by(id: params[:list_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :comment_id)
  end

  def verify_actions_permissions
    return if
      !current_user.admin? && @comment && @comment.user_id == current_user.id
    return if current_user.lists.include? @list
    render json: {
      error: I18n.t('permissions.access_denied')
    }, status: :bad_request
  end

  def verify_list_owner
    return if current_user.lists.include? @list
    return if current_user.user_lists.include? @list
    render json: {
      error: I18n.t('permissions.access_denied')
    }, status: :bad_request
  end
end
