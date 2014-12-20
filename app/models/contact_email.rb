class ContactEmail < ActiveRecord::Base
	include Archiving

	after_save :send_received_emails

	protected 

		def send_received_emails
			#send user email of acknowledgment
			#send email to admin
			puts 'sent emails!'
		end
end
