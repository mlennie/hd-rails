ActiveAdmin.register Transaction do
  permit_params :id, :kind, :original_balance, :amount, :amount_positive,
                :final_balance, :confirmation, :itemable_type, :itemable_id, 
                :itemable, :concernable, :concernable_type, :concernable_id
  controller do
    def scoped_collection
      if params[:id] && params[:type]
        loggable_type = params[:type]
        loggable_id = params[:id]
        type = loggable_type.constantize
        parent = type.find(loggable_id)
        transactions = parent.transactions.get_unarchived
      else
        Transaction.get_unarchived
      end
    end

    def create
      #do nothing for now
    end

    def destroy
      #do nothing for now
    end

    def update
      #do nothing for now
    end
  end
end
