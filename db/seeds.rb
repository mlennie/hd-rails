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
  :confirmed_at => Time.now, :confirmation_token => '1234567890'
)

puts 'created user'

Restaurant.create(
	name: "Blue Nile",
  img_url: "http://www.toxel.com/wp-content/uploads/2009/06/restaurant08.jpg",
  description: "Best food ever!! soooo good",
  zipcode: '75017',
  city: 'Paris', 
  street: '123 main street'
)

Restaurant.create(
  name: "Shang hi noon",
  img_url: "http://www.huahintoday.com/wp-content/uploads/2013/04/InAzia-Restaurant-II.jpg",
  description: "Fancy fancy fancy oh and did we say fancy",
  zipcode: '75017',
  city: 'Paris', 
  street: '123 main street'
)

Restaurant.create(
  name: "Haute couture",
  img_url: "http://www.a-onehotel.com/pattaya/pattaya_images/300ppi/50MARITIME%20RESTAURANT.JPG",
  description: "The Lobster is to die for",
  zipcode: '75017',
  city: 'Paris', 
  street: '123 main street'
)

Restaurant.create(
  name: "Brasserie Lip",
  img_url: "http://www.paris-bistro.com/culture/ecrivain/pics_ecrivain/prix_lipp.jpg",
  description: "Classy Brasserie sur Saint Germain",
  zipcode: '75008',
  city: 'Paris', 
  street: '123 main street'
)

Restaurant.create(
  name: "Fouquet",
  img_url: "http://www.lucienbarriere.com/localized/image/photoelement/pj/500x240-ho-hbf-fouquet's-salle1_opt318838617194458100.jpg",
  description: "Sarkozy ate here. Enough said.",
  zipcode: '75008',
  city: 'Paris', 
  street: '123 main street'
)

puts 'created restaurants'

Role.create(
  name: 'owner',
  description: 'restaurant owner'
)

puts 'created restaurant owner role'

Restaurant.all.each do |r|
  u = Role.first.users.create(
    first_name: "Owner",
    last_name: r.name.gsub(/\s+/, ""),
    :email => "owner@#{r.name.gsub(/\s+/, "")}.com",
    :password => "123456",
    :password_confirmation => "123456",
    :confirmed_at => Time.now, 
    :confirmation_token => "1234567890#{r.id}"
  )
  r.update(user_id: u.id)
end

puts 'created owners for restaurants'


