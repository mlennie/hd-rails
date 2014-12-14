class Service < ActiveRecord::Base

  include Archiving

  has_many :reservations
  belongs_to :restaurant
end
