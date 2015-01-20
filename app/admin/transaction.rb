ActiveAdmin.register Transaction do
  permit_params :id, :kind, :original_balance, :amount, :amount_positive,
                :final_balance, :confirmation, :itemable_type, :itemable_id, 
                :itemable, :concernable, :concernable_type, :concernable_id,
                :reason

  belongs_to :user, optional: true
  belongs_to :restaurant, optional: true

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
      if params[:user_id] || params[:restaurant_id]

        #get concernable variables for redirect
        if params[:user_id]
          id = params[:user_id]
          type = "User"
        else
          id = params[:restaurant_id]
          type = "Restaurant"
        end

        #create transaction
        if Transaction.create_adjustable_transaction params, current_admin_user.id
          flash[:success] = "Transaction Added"
          redirect_to admin_transactions_path(id: id, type: type)
        else
          flash[:danger] = "Transaction Could not be added. Please make sure reason is filled out so we know you're not just sending yourself money :)"
          redirect_to :back
        end

      else
        flash[:danger] = "Transaction Could not be added. Please make a transaction through a user or restaurant first"
        redirect_to :back
      end
    end

    def destroy
      #do nothing for now
    end

    def update
      #do nothing for now
    end
  end

  index do
    selectable_column
    id_column
    column :kind
    column :confirmation
    column :original_balance
    column :amount
    column :amount_positive
    column :final_balance
    column :reason
    column :admin_id
    column :created_at
    column :updated_at
    actions
  end

  filter :kind
  filter :confirmation
  filter :original_balance
  filter :amount
  filter :amount_positive
  filter :final_balance
  filter :reason
  filter :admin_id
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs "New transaction" do
      f.input :amount, required: true
      f.input :reason, required: true
    end
    f.actions
  end
end
