class ReservationError < ActiveRecord::Base
  include Archiving

  enum status: [ :amount_wrong, :not_absent, :bad_service, :other ]

  belongs_to :user
  belongs_to :reservation
  belongs_to :restaurant
end
