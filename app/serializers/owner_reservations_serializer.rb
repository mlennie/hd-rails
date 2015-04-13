class OwnerReservationsSerializer < ActiveModel::Serializer
  attributes :id, :time, :restaurant_id, :status, :nb_people,
  					 :booking_name, :earnings

end
