class ContactEmailsController < ApplicationController
	def create
		ce = ContactEmail.new(contact_email_params)
		if ce.save
			head 204
		else 
			head 422
		end
	end

	private

	  def contact_email_params
	    params.require(:contact_email).permit(:name, :email, :user_id, :content)
	  end
end