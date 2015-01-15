source 'https://rubygems.org'

#
#General
#
gem 'rails', '4.1.8'
gem 'pg'

#
#styling
#
gem 'sass-rails', '~> 4.0.3'
gem 'country_select', github: 'stefanpenner/country_select'

#
#Javascript
#
gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'

#
#API
#
gem 'active_model_serializers', '~> 0.9.2'
gem "rack-cors", require: "rack/cors"

#
#Development
#
group :development do
  gem 'spring'
  gem 'rubocop', '~> 0.27.1'
end

#
#Testing
#
group :test, :development do
  gem 'rspec-rails', '~> 3.1.0'
  gem 'factory_girl', '~> 4.5.0'
  gem 'capybara', '~> 2.4.4'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'launchy', '~> 2.4.3'
  gem 'shoulda-matchers', '~> 2.7.0'
  gem 'shoulda-callback-matchers', '~> 1.1.1'
  gem 'pry-debugger', '~> 0.2.3'
  gem 'jazz_hands', '~> 0.5.2'
  gem 'foobar', '~> 0.0.1'
end

#
#Security
#
gem 'devise', '~> 3.4.1'
gem 'cancancan', '~> 1.9.2'

#
#Admin
#
gem 'activeadmin', github: 'activeadmin'
gem 'documentation', '~> 1.0.7'
gem 'just-time-picker', '~> 0.0.2'
gem 'just-datetime-picker', '~> 0.0.6'

#
#Emailing
#
gem 'mailcatcher', group: :development
gem 'sanitize_email', '~> 1.1.4'

#
#Deployment
#
group :production, :staging, :development_remote do
  gem 'rails_12factor', '~> 0.0.3'
  gem 'newrelic_rpm', '~> 3.9.8.273'
end

