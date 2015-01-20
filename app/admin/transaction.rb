ActiveAdmin.register Transaction do
  permit_params :id, :kind, :original_balance, :amount, :amount_positive,
                :final_balance, :confirmation, :itemable_type, :itemable_id, 
                :itemable, :concernable, :concernable_type, :concernable_id,
                :reason

  belongs_to :user, optional: true

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
      if Transaction.create_adjustable_transaction params current_admin_user.id
        flash[:success] = "Transaction Added"
        redirect_to admin_user_transactions(self)
      else
        flash[:danger] = "Transaction Could not be added. Please make sure reason is filled out so we know you're not just sending yourself money :)"
        redirect_to new_admin_user_transaction(self)
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
    column :itemable
    column :concernable
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
  filter :itemable
  filter :concernable
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
