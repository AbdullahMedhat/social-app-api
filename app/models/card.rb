class Card < ActiveRecord::Base
  # -----------Relations---------------
  belongs_to :list
  belongs_to :user
  has_many   :comments, dependent: :destroy

  # -----------SCOPES------------------
  scope :comments_order, lambda {
    order('comments_count DESC')
  }

  # -------------Validations-----------
  validates_presence_of :title, :description, :list_id
end
