class ReservationSerializer < ActiveModel::Serializer
  attributes :id, :time, :restaurant_id, :restaurant_name, :status

  def restaurant_name
  	Restaurant.find(self.restaurant_id).name
  end
end
