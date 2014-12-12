class UserPromotion < ActiveRecord::Base

  belongs_to :user
  belongs_to :reservation
  belongs_to :promotion
end
