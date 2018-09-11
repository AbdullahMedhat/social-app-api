class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :rememberable
  include DeviseTokenAuth::Concerns::User

  has_many :lists, dependent: :destroy

  has_many :list_users
  has_many :user_lists, source: :list, through: :list_users

  has_many :comments
end
