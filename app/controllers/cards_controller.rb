class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attrinutes, only: %i[create show update destroy]
  before_action :verify_list_owner, only: %i[create update remove]
  before_action :verify_actions_permissions, only: %i[update destroy]

  def index
    @list = List.find(params[:list_id])
    render json: { cards: @list.cards.comments_order }, status: :ok
  end

  def show
    render json: { card: @card, card_comments: @card.comments.first_three }
  end

  def create
    @card = @list.cards.new(card_params)
    @card.user = current_user
    if @card.save
      render json: { card: @card }, status: :created
    else
      render json: {
        errors: @card.errors.full_messages
      }, status: :bad_request
    end
  end

  def update
    if @card.update(card_params)
      render json: { card: @card }, status: :ok
    else
      render json: {
        errors: @card.errors.full_messages
      }, status: :bad_request
    end
  end

  def destroy
    if @card
      @card.destroy
      render nothing: true, status: :no_content
    else
      render json: {
        errors:  I18n.t('not_found')
      }, status: :not_found
    end
  end

  private

  def set_attrinutes
    @list = List.find_by(id: params[:list_id])
    @card = @list.cards.find_by(id: params[:id])
  end

  def card_params
    params.require(:card).permit(:title, :description)
  end

  def verify_actions_permissions
    return if !current_user.admin? && @card && @card.user_id == current_user.id
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
