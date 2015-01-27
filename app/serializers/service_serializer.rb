class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :last_booking_time, :discount

  def attributes
    data = super
    data[:discount] = get_highest_discount_available
    data
  end
end
