class Promotion < ActiveRecord::Base

	include Archiving

  has_many :user_promotions
  has_many :users, through: :user_promotions
  has_many :reservations, through: :user_promotions
end
