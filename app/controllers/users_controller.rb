class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin
  before_action :set_attributes,
                only: %i[assign_user_to_list unassign_user_to_list]

  def assign_user_to_list
    if @assign
      render json: I18n.t('users.exsist_assing'), status: :ok
    else
      ListUser.create(assign_params)
      render json: I18n.t('users.success_assing'), status: :bad_request
    end
  end

  def unassign_user_to_list
    if @assign
      @assign.destroy!
      render nothing: true, status: :ok
    else
      render nothing: true, status: :not_found
    end
  end

  private

  def set_attributes
    @assign = ListUser.find_by(assign_params)
  end

  def assign_params
    params.permit(:user_id, :list_id)
  end

  def authenticate_admin
    return if current_user.admin?
    render json: {
      error: I18n.t('permissions.member_limition')
    }, status: :bad_request
  end
end
