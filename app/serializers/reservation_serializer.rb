class ReservationSerializer < ActiveModel::Serializer
  attributes :id, :time, :restaurant_id, :restaurant_name, 
  					 :status, :date, :earnings

  def restaurant_name
  	Restaurant.find(self.restaurant_id).name
  end

  def date
  	self.time.strftime("%d/%m/%Y")
  end

end
