class TransactionsController < ApplicationController

	def index 
		if user_signed_in? && !current_user.is_owner? 

			transactions = current_user.transactions.get_unarchived.reverse
			render json: transactions
		else
			head 401
		end
	end
end
