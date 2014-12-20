class PreSubscribersController < ApplicationController
	def create
		ps = PreSubscriber.new(pre_subscriber_params)
		if ps.save
			head 204
		else 
			head 422
		end
	end

	private

	  def pre_subscriber_params
	    params.require(:pre_subscriber).permit(:first_name, :last_name, :email)
	  end
end

