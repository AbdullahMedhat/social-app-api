class Comment < ActiveRecord::Base
  # -----------Relations---------------
  belongs_to :card, counter_cache: true
  belongs_to :user
  has_many :replaies,
           dependent: :destroy,
           class_name: 'Comment',
           foreign_key: :replay_id

  # -----------SCOPES------------------
  scope :first_three, lambda {
    first(3)
  }

  # -------------Validations-----------
  validates_presence_of :content
end
