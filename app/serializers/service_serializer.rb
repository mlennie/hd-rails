class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :availabilities, :start_time, :last_booking_time, :nb_10, :nb_15, :nb_20, :nb_25

  def attributes
    data = super
    data[:discount] = get_highest_discount_available
    data
  end
end
