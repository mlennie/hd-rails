unless AdminUser.any? || User.any?
  AdminUser.create(
    email: 'admin@happydining.fr', 
    password: 'happydine421', 
    password_confirmation: 'happydine421'
  )

  puts 'created admin user'

  User.create(
    :email => "superman@gmail.com",
    :password => "kryptonring",
    :password_confirmation => "kryptonring",
    :confirmed_at => Time.zone.now, :confirmation_token => '1234567890',
    first_name: "clark", last_name: 'Kent', gender: 'Male'
  )

  puts 'created user'

  unconfirmed_user = User.create(
    email: "unconfirmed@user.com",
    password: "password",
    password_confirmation: "password",
    confirmation_token: "12345678901",
    first_name: "unconfirmed",
    last_name: "user",
    gender: "Female"
  )

  #make unconfirmed user created at more that 1 day ago
  unconfirmed_user.created_at = Time.zone.now - 2.days
  unconfirmed_user.save!

  puts 'created unconfirmed user'
end

unless ServiceTemplate.any?
  #SERVICE TEMPLATES

  #create a service template
  service_template = ServiceTemplate.create({
    name: "Lord of the templates",
    description: "One template to rule them all."
  })

  #add services to service template
  day_array = %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday)
  day_array.each do |day|

    #SERVICES

    #1 to 3 pm service
    one_to_three_service = {
      availabilities: 99,
      start_time: Time.zone.now.midnight + 13.hours,
      last_booking_time: Time.zone.now.midnight + 15.hours,
      nb_10: 99,
      nb_20: 2,
      nb_25: 1,
      template_day: day
    }

    #5 to 10 pm service
    five_to_ten_service = {
      availabilities: 99,
      start_time: Time.zone.now.midnight + 17.hours,
      last_booking_time: Time.zone.now.midnight + 22.hours,
      nb_10: 99,
      nb_15: 1,
      template_day: day
    }

    #create services
    service_template.services.create(one_to_three_service)
    service_template.services.create(five_to_ten_service)
  end

  puts 'created master service template'
end

unless Restaurant.any?

  #
  #cuisines
  #
  italian = Cuisine.create(name: 'Italian')
  french = Cuisine.create(name: 'French')
  chinese = Cuisine.create(name: 'Chinese')
  budget = Cuisine.create(name: 'Budget')
  classy = Cuisine.create(name: 'Classy')
  world = Cuisine.create(name: 'World')
  indian = Cuisine.create(name: 'Indian')
  seafood = Cuisine.create(name: 'Seafood')

  description = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus urna metus, dictum non nulla feugiat, pharetra fringilla sem. Pellentesque sed fringilla massa, sed efficitur nisl. Nunc rutrum posuere lobortis. Praesent iaculis leo id felis bibendum, sed tempus est porta. Vivamus molestie interdum tempus. Donec hendrerit, erat in accumsan sodales, orci ipsum finibus erat, eget laoreet massa mauris et lorem. Proin egestas, diam vitae rutrum dapibus, sapien orci consectetur ligula, a posuere tellus urna in libero. Integer quis leo urna. Nulla aliquam ac tortor vel porta.'

  #add restaurant
  r1 = Restaurant.create(
  	name: 'Grand Bistro Maillot Saint Ferdinand',
    img_url: "http://www.toxel.com/wp-content/uploads/2009/06/restaurant08.jpg",
    description: description,
    zipcode: '75017',
    city: 'Paris', 
    country: 'France',
    street: '223 main street',
    principle_email: "fake@restaurant.com"
  )

  #add cuisines
  r1.cuisines << seafood 
  r1.cuisines << classy

  r2 = Restaurant.create(
    name: "Shang hi noon",
    img_url: "http://www.huahintoday.com/wp-content/uploads/2013/04/InAzia-Restaurant-II.jpg",
    description: description,
    zipcode: '75017',
    city: 'Paris', 
    country: 'France',
    street: '623 main street',
    principle_email: "fake@restaurant.com"
  )

  #add cuisines
  r2.cuisines << chinese 
  r2.cuisines << budget 

  r3 = Restaurant.create(
    name: "Haute couture",
    img_url: "http://www.a-onehotel.com/pattaya/pattaya_images/300ppi/50MARITIME%20RESTAURANT.JPG",
    description: description,
    zipcode: '75008',
    city: 'Paris', 
    country: 'France',
    street: 'Champ de Mars, 5 Avenue Anatole',
    principle_email: "fake@restaurant.com"
  )

  #add cuisines
  r3.cuisines << french
  r3.cuisines << classy

  r4 = Restaurant.create(
    name: "Brasserie Lip",
    img_url: "http://www.paris-bistro.com/culture/ecrivain/pics_ecrivain/prix_lipp.jpg",
    description: description,
    zipcode: '75016',
    city: 'Paris', 
    country: 'France',
    street: ' 102 Boulevard du Montparnasse',
    principle_email: "fake@restaurant.com"
  )

  #add cuisines
  r4.cuisines << french
  r4.cuisines << budget

  r5 = Restaurant.create(
    name: "Fouquet",
    img_url: "http://www.lucienbarriere.com/localized/image/photoelement/pj/500x240-ho-hbf-fouquet's-salle1_opt318838617194458100.jpg",
    description: description,
    zipcode: '75008',
    city: 'Paris', 
    country: 'France',
    street: '99 avenue des Champs-Elysées',
    principle_email: "fake@restaurant.com"
  )

  #add cuisines
  r5.cuisines << french
  r5.cuisines << classy
  

  puts 'created restaurants'

  Role.create(
    name: 'owner',
    description: 'restaurant owner'
  )

  puts 'created restaurant owner role'

  Restaurant.all.each_with_index do |r, index|

    #add users for restaurants
    u = Role.first.users.create!(
      first_name: "Owner",
      last_name: r.name.gsub(/\s+/, ""),
      :email => "owner@#{r.name.gsub(/\s+/, "")}.com",
      :password => "123456",
      :password_confirmation => "123456",
      :confirmed_at => Time.zone.now, 
      :confirmation_token => "1234567890#{r.id}",
      gender: 'Male'
    )
    r.update(user_id: u.id)

    #delete services so doesn' interfere with the services with reservations 
    #(next) and then add services for year again at end
    r.services.destroy_all

    #make a reservation for every day of the week for current restaruant
    7.times do |day_index|

      #SERVICES

      #make service for every day for every restaurant
      #1 to 3 pm service
      one_to_three_service = {
        availabilities: 99,
        start_time: Time.zone.now.midnight + day_index.day + 13.hours,
        last_booking_time: Time.zone.now.midnight + day_index.day + 15.hours,
        nb_10: 99,
        nb_20: 2,
        nb_25: 1
      }

      #5 to 10 pm service
      five_to_ten_service = {
        availabilities: 99,
        start_time: Time.zone.now.midnight + day_index.day + 17.hours,
        last_booking_time: Time.zone.now.midnight + day_index.day + 22.hours,
        nb_10: 99,
        nb_15: 1
      }

      s1 = r.services.create!(one_to_three_service)
      s2 = r.services.create!(five_to_ten_service)


      #RESERVATIONS
      #add reservations
      reservation_night_params = {
        nb_people: 12,
        time: Time.new.midnight + day_index.day + 20.hours,
        user_id: r.id,
        discount: 0.1,
        service_id: s2.id,
        user_contribution: 0,
        booking_name: "Twinny"
      }
      reservation_day_params = {
        nb_people: 2,
        time: Time.new.midnight + day_index.day + 14.hours,
        user_id: r.id,
        discount: 0.1,
        service_id: s1.id,
        user_contribution: 0,
        booking_name: "Pierre"
      }
      r.reservations.create!(reservation_night_params)
      r.reservations.create!(reservation_day_params)
    end

    #
    #PAST SERVICE AND RESERVATIONS
    #
    #make past services
    one_to_three_yesterday_service = {
      availabilities: 99,
      start_time: Time.zone.now.midnight - 1.day + 13.hours,
      last_booking_time: Time.zone.now.midnight - 1.day + 15.hours,
      nb_10: 99,
      nb_20: 2,
      nb_25: 1
    }
    #5 to 10 pm service
    five_to_ten_yesterday_service = {
      availabilities: 99,
      start_time: Time.zone.now.midnight - 1.day + 17.hours,
      last_booking_time: Time.zone.now.midnight - 1.day + 22.hours,
      nb_10: 99,
      nb_15: 1
    }

    s1 = r.services.create!(one_to_three_yesterday_service)
    s2 = r.services.create!(five_to_ten_yesterday_service)

    #add past reservations
    reservation_night_params = {
      nb_people: 6,
      time: Time.new.midnight - 1.day + 20.hours,
      user_id: r.id,
      discount: 0.1,
      service_id: s2.id,
      user_contribution: 0,
      booking_name: "Maxime"
    }
    reservation_day_params = {
      nb_people: 4,
      time: Time.new.midnight - 1.day + 14.hours,
      user_id: r.id,
      discount: 0.1,
      service_id: s1.id,
      user_contribution: 0,
      booking_name: "Benjamin"
    }
    r.reservations.create!(reservation_night_params)
    r.reservations.create!(reservation_day_params)

    puts 'created services and reservations for ' + Restaurant.find(r.id).name

    #create menu for restaurant with menu items
    #setup params
    menu_params = { name: "Default", title: "Our everyday menu", 
                    description: "This menu is valid from 15:00 to 22:00",
                    kind: 1}
    entree_params = { course: 1, name: "chicken salad", description: "Le tartare de dorade au caviar de Sologne", 
                      price: 9.99 }
    principaux_params = { course: 2, name: "steak a la potato", description: "La salade de homard tiède, vinaigrette au jus de truffe", 
                      price: 13.99 }
    dessert_params = { course: 3, name: "tireamisou", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus tincidunt efficitur", 
                      price: 6.50 }

    #add menu and 3 menu items per menu category
    m = r.menus.create(menu_params)
    3.times do 
      m.menu_items.create(entree_params)
      m.menu_items.create(principaux_params)
      m.menu_items.create(dessert_params)
    end
  end

  puts 'created owners, services and menus for restaurants'

end

#add back services for year
Restaurant.add_services_for_one_year_for_all_restaurants

# mark production reservations with transactions as validated since they were
#not all updated before
reservations = Reservation.get_unarchived.where(status: nil)
reservations.all.each do |reservation|
  reservation.validated! if reservation.transactions.any?
  puts "validated all reservations with transactions that didn't have a status"
end




