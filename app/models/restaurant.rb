class Restaurant < ActiveRecord::Base
  include Archiving

  has_many :services
  has_many :reservations
  has_many :reservation_errors
  has_many :ratings
  belongs_to :user
  has_many :favorite_restaurants
  has_many :favorite_users, through: :favorite_restaurants, source: :users
  has_one :wallet, as: :concernable
  has_many :transactions, as: :concernable
  has_many :invoices
  has_many :restaurant_cuisines
  has_many :cuisines, through: :restaurant_cuisines
  has_many :menus
  has_many :service_templates

  #add geolocation and reverse geolocation
  geocoded_by :full_street_address
  after_validation :geocode, if: :full_street_address_changed?
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      obj.geocoded_address = geo.address 
    end
  end

  after_validation :reverse_geocode, if: :full_street_address_changed?

  after_save :create_new_wallet

  validates_presence_of :name, :principle_email

  def to_s
    unless name.blank? 
      name
    else
      email
    end
  end

  def full_street_address
    street + city + country + zipcode
  end

  #add year's worth of services for all restaurants 
  #if today is first day of month
  def self.add_services_for_restaurants_if_first_of_month
    date = Time.new
    if date.midnight == date.beginning_of_month
      Restaurant.add_services_for_one_year_for_all_restaurants
    else
      puts "no restaurants were added since it's not the first day of the month"
    end
  end

  #add one years worth of services for all restaurants
  def self.add_services_for_one_year_for_all_restaurants
    Restaurant.get_unarchived.all.each do |restaurant|
      restaurant.add_services_for_one_year_from_automation_template
    end
  end

  #add services for one year for restaurant
  def add_services_for_one_year_from_automation_template

    #set date and restaurant params
    params[:date] = Time.new
    params[:restaurant_id] = self.id

    #set service template id param
    params[:service_template_id] = self.get_automation_service_template_id

    Restaurant.use_template_to_create_services_for_12_months params
  end

  #get template id that will be used to automate service creation
  def get_automation_service_template_id
    template_id = nil

    #get template from restaruant templates if exists
    self.service_templates.get_unarchived.all.each do |template|
      template_id = template.id if template.use_for_automation
    end

    #if restaurant did not have any automation templates, 
    #get automation template id from master template
    unless template_id != nil
      template_id = ServiceTemplate.get_unarchived
                     .where(restaurant_id: nil)
                     .where(use_for_automation: true).first.id
    end

    return template_id
  end

  def self.use_template_to_create_services_for_12_months params
    original_date = params[:date]
    12.times do |index|
      date = original_date + index.months
      params[:date] = date
      params[:whole_month] = true
      Restaurant.use_template_to_create_services params
    end
    return true
  end

  #turn string date eg "2015-4-7" into real date
  def self.get_date_from_string date
    #make date calculations
    array_date = date.split("-")
    year = array_date[0].to_i # eg. 2015
    month = array_date[1].to_i # eg. 4 (april)
    day = array_date[2].to_i # eg. 7 (7th day of month)
    return Date.new(year, month, day) #eg . Tue, 07 Apr 2015
  end

  def self.use_template_to_create_services params

    #get current date, service template and restaurant
    date = params[:date]
    service_template = ServiceTemplate.get_unarchived.find(params[:service_template_id].to_i)
    service_template_services = service_template.services.get_unarchived
    restaurant = Restaurant.get_unarchived.find(params[:restaurant_id].to_i)
    restaurant_services = restaurant.services.get_unarchived.today_or_future

    day_of_week = date.cwday # eg. 2 (tuesday)

    first_date_of_month = date.beginning_of_month #eg. Wed, 01 Apr 2015
    last_date_of_month = date.end_of_month #eg. Thu, 30 Apr 2015

    first_day_of_first_week_of_month = first_date_of_month.cwday # eg. 3 (wednesday)
    last_day_of_last_week_of_month = last_date_of_month.cwday #eg. 4 (thursday)

    #get date of first day of first week on calendar (evens if it's from last month)
    first_date_of_calendar = case first_day_of_first_week_of_month
      when 1
        first_date_of_month
      when 2
        first_date_of_month - 1.day
      when 3
        first_date_of_month - 2.days
      when 4
        first_date_of_month - 3.days
      when 5
        first_date_of_month - 4.days
      when 6
        first_date_of_month - 5.days
      when 7
        first_date_of_month - 6.days
    end

    #get number of weeks in calendar 
    first_week_of_calendar = first_date_of_calendar.cweek #eg 14
    last_week_of_calendar = last_date_of_month.cweek #eg 18
    number_of_weeks_in_month = last_week_of_calendar - first_week_of_calendar + 1 

    #get starting dates for each weeks in calendar
    #already have first: first_date_of_calendar
    second_week_of_calendar = first_date_of_calendar + 7.days
    third_week_of_calendar = second_week_of_calendar + 7.days
    fourth_week_of_calendar = third_week_of_calendar + 7.days
    fifth_week_of_calendar = fourth_week_of_calendar + 7.days
    if (number_of_weeks_in_month == 6)
      sixth_week_of_calendar = fifth_week_of_calendar + 7.days
    end

    #start a transaction so that if something fails,
    #database will be rolled back
    ActiveRecord::Base.transaction do
  
      if params[:week_one] || params[:whole_month]
        restaurant.create_services_for_week(
          first_date_of_calendar, 
          service_template_services,
          restaurant_services
        )
      end

      if params[:week_two] || params[:whole_month]
        restaurant.create_services_for_week(
          second_week_of_calendar,
          service_template_services,
          restaurant_services
        )
      end

      if params[:week_three] || params[:whole_month]
        restaurant.create_services_for_week(
          third_week_of_calendar,
          service_template_services,
          restaurant_services
        )
      end

      if params[:week_four] || params[:whole_month]
        restaurant.create_services_for_week(
          fourth_week_of_calendar,
          service_template_services,
          restaurant_services
        )
      end

      if params[:week_five] || params[:whole_month]
        restaurant.create_services_for_week(
          fifth_week_of_calendar,
          service_template_services,
          restaurant_services
        )
      end

      if (params[:week_six] || params[:whole_month]) && (number_of_weeks_in_month == 6)
        restaurant.create_services_for_week(
          sixth_week_of_calendar,
          service_template_services,
          restaurant_services
        )
      end
    end
    return true
  end

  def create_services_for_week(start_of_week_date, 
                               service_template_services, 
                               restaurant_services)

    #create services for restaurant from template
    service_template_services.each do |template_service|
      
      service_day = template_service.template_day

      template_date = case service_day
        when "Monday"
          start_of_week_date
        when "Tuesday" 
          start_of_week_date + 1.day
        when "Wednesday" 
          start_of_week_date + 2.days
        when "Thursday"
          start_of_week_date + 3.days
        when "Friday"
          start_of_week_date + 4.days
        when "Saturday"
          start_of_week_date + 5.days
        when "Sunday"
          start_of_week_date + 6.days
      end

      #get year, month and day
      service_year = template_date.year
      service_month = template_date.month
      service_day = template_date.day

      #start hour and minutes
      service_start_hour = template_service.start_time.hour
      service_start_minutes = template_service.start_time.min

      #last booking hour and minutes
      service_end_hour = template_service.last_booking_time.hour
      service_end_minutes = template_service.last_booking_time.min

      #create new start time date
      service_start_time = DateTime.new(
        service_year,
        service_month,
        service_day,
        service_start_hour,
        service_start_minutes
      )

      #create new end time date
      service_last_booking_time = DateTime.new(
        service_year,
        service_month,
        service_day,
        service_end_hour,
        service_end_minutes
      )
      
      #don't add services to days that already have services
      unless restaurant_services.services_within_time_period(
               service_start_time, 
               service_last_booking_time).any? ||
        service_start_time < Time.new
        #create service for restaurant
        self.services.create({
          availabilities: template_service.availabilities,
          start_time: service_start_time,
          last_booking_time: service_last_booking_time,
          nb_10: template_service.nb_10,
          nb_15: template_service.nb_15,
          nb_20: template_service.nb_20,
          nb_25: template_service.nb_25
        })
      end
    end
  end

  def full_street_address_changed?
    if street == nil ||
      city == nil ||
      country == nil ||
      zipcode == nil
      return false
    else
      street_changed? || city_changed? || country_changed? || zipcode_changed?
    end
  end

  def create_new_wallet
    Wallet.create_for_concernable self
  end

  def full_address
    street + ', ' + city + ', ' + zipcode
  end
end
