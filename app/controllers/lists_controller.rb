class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, except: %i[index]
  before_action :set_list, only: %i[show update destroy]
  before_action :verify_list_owner, only: %i[update destroy]

  def index
    if current_user.admin?
      render json: { lists: List.all }, status: :ok
    else
      render json: { lists: current_user.user_lists }, status: :ok
    end
  end

  def show
    render  json: { list: @list, list_cards: @list.cards }
  end

  def create
    @list = List.new(list_params)
    @list.user = current_user
    if @list.save
      render json: { list: @list }, status: :created
    else
      render json: {
        errors: @list.errors.full_messages
      }, status: :bad_request
    end
  end

  def update
    if @list.update(list_params)
      render json: { list: @list }, status: :ok
    else
      render json: {
        errors: @list.errors.full_messages
      }, status: :bad_request
    end
  end

  def destroy
    @list.destroy
    render nothing: true, status: :no_content
  end

  private

  def set_list
    @list = List.find_by(id: params[:id])
  end

  def list_params
    params.require(:list).permit(:title)
  end

  def verify_list_owner
    return if current_user.lists.include? @list
    render json: {
      error: I18n.t('permissions.access_denied')
    }, status: :bad_request
  end

  def authenticate_admin
    return if current_user.admin?
    render json: {
      error: I18n.t('permissions.member_limition')
    }, status: :bad_request
  end
end
