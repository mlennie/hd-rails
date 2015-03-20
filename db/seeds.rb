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
    :confirmed_at => Time.now, :confirmation_token => '1234567890',
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
  unconfirmed_user.created_at = Time.now - 2.days
  unconfirmed_user.save!

  puts 'created unconfirmed user'
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

  #
  #Services
  #

  #1 to 3 current day service
  one_to_three_today_service = {
    availabilities: 99,
    start_time: Time.now.midnight + 13.hours,
    last_booking_time: Time.now.midnight + 15.hours,
    nb_10: 99,
    nb_20: 2
  }

  #5 to 10 current day service
  five_to_ten_today_service = {
    availabilities: 99,
    start_time: Time.now.midnight + 17.hours,
    last_booking_time: Time.now.midnight + 22.hours,
    nb_10: 99
  }

  #1 to 3 tomorrow service
  one_to_three_tomorrow_service = {
    availabilities: 2,
    start_time: Time.now.midnight + 1.day + 13.hours,
    last_booking_time: Time.now.midnight + 1.day + 15.hours,
    nb_10: 99,
    nb_15: 1
  }

  #5 to 10 tomorrow service
  five_to_ten_tomorrow_service = {
    availabilities: 6,
    start_time: Time.now.midnight + 1.day + 17.hours,
    last_booking_time: Time.now.midnight + 1.day + 22.hours,
    nb_10: 99,
    nb_15: 1,
    nb_20: 1,
    nb_25: 1
  }

  #make service with no availabilities left
  #1 to 3 current day service
  one_to_three_today_service_no_availabilities = {
    availabilities: 0,
    start_time: Time.now.midnight + 13.hours,
    last_booking_time: Time.now.midnight + 15.hours,
    nb_10: 99,
    nb_20: 2
  }

  #5 to 10 current day service
  five_to_ten_today_service_no_availabilities = {
    availabilities: 0,
    start_time: Time.now.midnight + 17.hours,
    last_booking_time: Time.now.midnight + 22.hours,
    nb_10: 99
  }

  description = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus urna metus, dictum non nulla feugiat, pharetra fringilla sem. Pellentesque sed fringilla massa, sed efficitur nisl. Nunc rutrum posuere lobortis. Praesent iaculis leo id felis bibendum, sed tempus est porta. Vivamus molestie interdum tempus. Donec hendrerit, erat in accumsan sodales, orci ipsum finibus erat, eget laoreet massa mauris et lorem. Proin egestas, diam vitae rutrum dapibus, sapien orci consectetur ligula, a posuere tellus urna in libero. Integer quis leo urna. Nulla aliquam ac tortor vel porta.'

  #add restaurant
  r1 = Restaurant.create(
  	name: 'Grand Bistro Maillot Saint Ferdinand',
    img_url: "http://www.toxel.com/wp-content/uploads/2009/06/restaurant08.jpg",
    description: description,
    zipcode: '75017',
    city: 'Paris', 
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
    zipcode: '75017',
    city: 'Paris', 
    street: '823 main street',
    principle_email: "fake@restaurant.com"
  )

  #add cuisines
  r3.cuisines << french
  r3.cuisines << classy

  r4 = Restaurant.create(
    name: "Brasserie Lip",
    img_url: "http://www.paris-bistro.com/culture/ecrivain/pics_ecrivain/prix_lipp.jpg",
    description: description,
    zipcode: '75008',
    city: 'Paris', 
    street: '7723 main street',
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
    street: '1823 main street',
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
    u = Role.first.users.create(
      first_name: "Owner",
      last_name: r.name.gsub(/\s+/, ""),
      :email => "owner@#{r.name.gsub(/\s+/, "")}.com",
      :password => "123456",
      :password_confirmation => "123456",
      :confirmed_at => Time.now, 
      :confirmation_token => "1234567890#{r.id}",
      gender: 'Male'
    )
    r.update(user_id: u.id)

    #add default services to restaurants
    #add for today
    if index == 0 #add service with no availabilites
      r.services.create(one_to_three_today_service_no_availabilities)
      r.services.create(five_to_ten_today_service_no_availabilities)
    else
      r.services.create(one_to_three_today_service)
      r.services.create(five_to_ten_today_service)
    end
    #add for tomorrow
    r.services.create(one_to_three_tomorrow_service)
    r.services.create(five_to_ten_tomorrow_service)

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


