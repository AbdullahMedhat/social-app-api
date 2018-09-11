class List < ActiveRecord::Base
  # -----------Relations---------------
  belongs_to :user
  has_many   :cards, dependent: :destroy

  has_many :list_users
  has_many :users, through: :list_users

  # -------------Validations-----------
  validates_presence_of :title, :user_id
end
