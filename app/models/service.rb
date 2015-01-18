class Service < ActiveRecord::Base

  include Archiving

  has_many :reservations
  belongs_to :restaurant

  just_define_datetime_picker :start_time
  just_define_datetime_picker :last_booking_time
end
