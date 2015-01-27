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

  def get_highest_discount_available
    #get total availabilites and spots already taken
    availabilities = self.availabilities
    spots_taken = self.reservations.get_unarchived.where(
                    "status != ?", Reservation.statuses[:cancelled]
                  ).count

    #get percentage availabilites
    number_of_ten_available = self.nb_10
    number_of_fifteen_available = self.nb_15
    number_of_twenty_available = self.nb_20
    number_of_twenty_five_available = self.nb_25

    #return 0 if no spots left
    if spots_taken >= availabilites 
      return 0
    #start highest to lowest percentages 
    #to see which percentage is still available 
    elsif spots_taken < number_of_twenty_five_available
      return 0.25
    elsif spots_taken < number_of_twenty_available
      return 0.20
    elsif spots_taken < number_of_fifteen_available
      return 0.15
    else
      return 0.10
    end
  end
end
