
superadmin = Role.create(
  name: "superadmin",
  description: "Can do everything!"
)

puts 'created superadmin role'

admin = User.create(
  :email => "superman@gmail.com",
  :password => "kryptonring",
  :password_confirmation => "kryptonring",
  :confirmed_at => Time.now, :confirmation_token => '1234567890')

User.create([
  {email: 'green@mail.com',
   password: '12345678', password_confirmation: '12345678'},
  {email: 'pink@mail.com',
   password: '12345678', password_confirmation: '12345678'}
])

puts 'created user'

admin.roles << superadmin

puts 'made user admin'


