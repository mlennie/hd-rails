class Service < ActiveRecord::Base

  include Archiving

  enum status: [ :complete ]

  has_many :reservations
  belongs_to :restaurant
  belongs_to :service_template

  just_define_datetime_picker :start_time
  just_define_datetime_picker :last_booking_time

  before_save :update_current_discount

  
  def self.future_with_availabilities
    self.where(
      "start_time > :yesterday",
      { yesterday: Time.new.midnight }
    ).where("current_discount > :zero",
      { zero: 0 }
    )
  end

  def self.get_template_services_for_day(service_template_id, day)
    where(service_template_id: service_template_id)
    .where(template_day: day)
    .get_unarchived
  end

  #get services that match date
  #used for services calendar
  def self.get_services_for_day date
    date_day = date.day
    date_month = date.month
    date_year = date.year
    service_ids = []
    find_each do |s|
      service_time = s.start_time
      if service_time.day === date_day &&
        service_time.month === date_month &&
        service_time.year === date_year
        service_ids << s.id
      end
    end
    where(id: service_ids)
  end

  #don't get services where restaurants said they 
  #were complete (full)
  def self.not_complete
    self.where(id: get_not_complete_ids).get_unarchived
  end

  def self.get_not_complete_ids
    s_ids = []
    self.all.each do |s|
      if s.status != Service.statuses[:complete]      
          s_ids << s.id    
          end  
      end    
  end

  def self.check_and_update(owner_id, params)
    service_id = params[:id].to_i
    restaurant_id = params[:service][:restaurant_id].to_i
    service = Service.find(service_id)
    user = User.find(owner_id)

    #Authorization: start checking credentials and associations
    if user.is_owner? &&
      service &&
      user.restaurants.first.service_ids.include?(service_id) &&
      user.restaurant_ids.include?(restaurant_id) &&
      service.restaurant_id === restaurant_id 

      #update and save
      service.complete!
      service.save!
      return true
    else
      return false
    end
  end

  def self.get_service params

  	#add service 
    #get restaurant
    restaurant = Restaurant.find(params[:reservation][:restaurant_id].to_i)
    
    #get service based on times
    service = restaurant.services.where(
      "start_time <= :time AND last_booking_time >= :time",
      { time: params[:reservation][:time] }
    ).first

    #update service params
    return service
  end

  #before save or update, adjust current discount
  def update_current_discount
    #get spots already taken
    spots_taken = self.reservations.get_unarchived.where(
                    "status != ?", Reservation.statuses[:cancelled]
                  ).count

    #get percentage availabilites
    number_of_ten_available = self.nb_10
    number_of_fifteen_available = self.nb_15
    number_of_twenty_available = self.nb_20
    number_of_twenty_five_available = self.nb_25

    #get new current discount
    #return 0 if no spots left
    if spots_taken >= self.availabilities
      discount = 0
    #start highest to lowest percentages 
    #to see which percentage is still available 
    elsif spots_taken < number_of_twenty_five_available
      discount = 0.25
    elsif spots_taken < number_of_twenty_available
      discount = 0.20
    elsif spots_taken < number_of_fifteen_available
      discount = 0.15
    else
      discount = 0.10
    end
    self.current_discount = discount
  end

  def service_params
    params.require(:service).permit(:availabilities, :start_time, :last_booking_time,
                :restaurant_id, :nb_10, :nb_15, :nb_20, :nb_25,
                :start_time_date, :start_time_time_hour, :start_time_time_minute,
                :last_booking_time_date, :last_booking_time_time_hour, 
                :last_booking_time_time_minute, :service_template_id, :service_template,
                :template_day)
  end
end
