class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_user! unless :devise_controller
  protect_from_forgery with: :null_session
  respond_to :json
end
