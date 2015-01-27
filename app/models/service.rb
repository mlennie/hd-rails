class Service < ActiveRecord::Base

  include Archiving

  has_many :reservations
  belongs_to :restaurant

  just_define_datetime_picker :start_time
  just_define_datetime_picker :last_booking_time

  def self.get_service_id params

  	#add service 
    #get restaurant
    restaurant = Restaurant.find(params[:reservation][:restaurant_id].to_i)
    
    #get service based on times
    service = restaurant.services.where(
      "start_time <= :time AND last_booking_time >= :time",
      { time: params[:reservation][:time] }
    ).first

    #update service params
    return service.present? ? service.id : nil
  end
end
