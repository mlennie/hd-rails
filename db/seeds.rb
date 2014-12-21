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

10.times do |i|
	Restaurant.create(
		name: "Blue Nile #{i}"
	)
end

puts 'created restaurants'


