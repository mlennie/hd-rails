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

  def self.use_template_to_create_services params

    #get current date, service template and restaurant
    string_date = params[:date]
    service_template = ServiceTemplate.get_unarchived.find(params[:service_template_id].to_i)
    restaurant = Restaurant.get_unarchived.find(params[:restaurant_id].to_i)

    #get which weeks for calendar where selected
    week_one = params[:week_one]
    week_two = params[:week_two]
    week_three = params[:week_three]
    week_four = params[:week_four]
    week_five = params[:week_five]
    week_six = params[:week_six]

    #make date calculations
    array_date = string_date.split("-")
    year = array_date[0].to_i # eg. 2015
    month = array_date[1].to_i # eg. 4 (april)
    day = array_date[2].to_i # eg. 7 (7th day of month)
    date = Date.new(year,month,day) #eg . Tue, 07 Apr 2015
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

    #get date of first day on last week of calendar 
    first_date_of_last_week_of_calendar = case last_day_of_last_week_of_month
      when 1
        last_date_of_month
      when 2
        last_date_of_month - 1.day
      when 3
        last_date_of_month - 2.days
      when 4
        last_date_of_month - 3.days
      when 5
        last_date_of_month - 4.days
      when 6
        last_date_of_month - 5.days
      when 7
        last_date_of_month - 6.days

    #get number of weeks in calendar 
    first_week_of_calendar = first_date_of_last_week_of_calendar.cweek #eg 14
    last_week_of_calendar = first_date_of_last_week_of_calendar.cweek #eg 18
    number_of_weeks_in_month = last_week_of_calendar - first_week_of_calendar + 1 

    #get starting dates for each weeks in calendar
    #already have first: first_week of calendar
    second_week_of_calendar = first_week_of_calendar + 7.days
    third_week_of_calendar = second_week_of_calendar + 7.days
    fourth_week_of_calendar = third_week_of_calendar + 7.days
    fifth_week_of_calendar = fourth_week_of_calendar + 7.days
    if number_of_weeks_in_month == 6
      sixth_week_of_calendar = fifth_week_of_calendar + 7.days
    end

    if params[:week_one]
      #add services to week one of calendar
    end

    if params[:week_two]

    end

    if params[:week_three]

    end

    if params[:week_four]

    end

    if params[:week_five]

    end

    if params[:week_six]




    #create services for restaurant from template
    service_template.services.get_unarchived.each do |template_service|
      template_day = template_service.template_day
      restaurant.services.create({
        availabilities: template_service.availabilities,
        start_time: template_service.start_time,
        last_booking_time: template_service.last_booking_time,
        nb_10: template_service.nb_10,
        nb_15: template_service.nb_15,
        nb_20: template_service.nb_20,
        nb_25: template_service.nb_25
      })
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
