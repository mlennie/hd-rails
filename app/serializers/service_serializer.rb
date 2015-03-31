class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :last_booking_time, :current_discount, :status
end
