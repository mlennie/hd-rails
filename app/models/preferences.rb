class Preferences < ActiveRecord::Base
	belongs_to :user

	def self.create_for_user user
		user.create_preferences if user.preferences.nil?
	end
end
