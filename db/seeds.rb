AdminUser.create!(
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
  img_url: "http://www.minervas.net/images/jqg_13539536932.jpg",
  description: "Best food ever!! soooo good"
)

Restaurant.create(
  name: "Shang hi noon",
  img_url: "http://www.huahintoday.com/wp-content/uploads/2013/04/InAzia-Restaurant-II.jpg",
  description: "Fancy fancy fancy oh and did we say fancy"
)

Restaurant.create(
  name: "Haute couture",
  img_url: "http://www.a-onehotel.com/pattaya/pattaya_images/300ppi/50MARITIME%20RESTAURANT.JPG",
  description: "The Lobster is to die for"
)

Restaurant.create(
  name: "Brasserie Lip",
  img_url: "http://www.paris-bistro.com/culture/ecrivain/pics_ecrivain/prix_lipp.jpg",
  description: "Classy Brasserie sur Saint Germain"
)

Restaurant.create(
  name: "Fouquet",
  img_url: "http://www.lucienbarriere.com/localized/image/photoelement/pj/500x240-ho-hbf-fouquet's-salle1_opt318838617194458100.jpg",
  description: "Sarkozy ate here. Enough said."
)

puts 'created restaurants'


