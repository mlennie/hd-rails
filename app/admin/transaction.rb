ActiveAdmin.register Transaction do
  permit_params :id, :kind, :original_balance, :amount, :amount_positive,
                :final_balance, :confirmation, :itemable_type, :itemable_id, 
                :itemable, :concernable, :concernable_type, :concernable_id,
                :reason, :restaurant_id

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
      
      #move user_id if came through transaction params
      if params[:transaction][:user_id]
        params[:user_id] = params[:transaction][:user_id] 
      end

      #concernable id is restaurant id. 
      #Active admin couldn't make nested routes for both users and restaurants
      #check that admin came to this page through a user or restaurant first
      if params[:user_id] || params[:transaction][:concernable_id]

        #get concernable variables for redirect
        if params[:user_id].present?
          id = params[:user_id]
          type = "User"
        else
          id = params[:transaction][:concernable_id]
          type = "Restaurant"
        end

        #check to see if admin has entered amount yet or not and if not
        #ask admin to enter amount
        if params[:transaction][:amount]
          if params[:transaction][:kind] == "Adjustment"

            #create transaction
            if Transaction.create_adjustable_transaction(params, current_admin_user.id)
              flash[:notice] = "Transaction Added"
              redirect_to admin_transactions_path(id: id, type: type)
            else
              flash[:danger] = "Transaction Could not be added. " +
              "Please make sure reason is filled out so we know you're not " +
              "just sending yourself money :)"
              redirect_to :back
            end
          # use "who is paying" presence to check if it is a 
          #restaurant balance payment
          elsif params[:transaction][:who_is_paying] 
            transaction_params = Transaction.setup_balance_payment_params params
            if Transaction.create_balance_payment_transaction(transaction_params)
              flash[:notice] = "Transaction Added"
              redirect_to admin_transactions_path(id: id, type: "Restaurant")
            else
              flash[:danger] = "Transaction Could not be added. There was an error"
              redirect_to :back
            end
          else
            flash[:danger] = "Please choose a proper transaction category"
            redirect_to :back
          end
        else 
          flash[:notice] = "Please enter transaction information"
          redirect_to new_admin_transaction_path(id: id, kind: params[:transaction][:kind], type: type)
        end
      else
        flash[:danger] = "Transaction Could not be added. Please make a " + 
        "transaction through a user or restaurant first"
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
      #1st step make admin choose transaction_kind
      if params[:kind] == "Adjustment"
        f.input :amount, required: true
        f.input :reason, required: true
        if params[:type] == "Restaurant"
          f.input :concernable_id, input_html: { value: params[:id], hidden: true  }, label: false
        else
          f.input :user_id, input_html: { value: params[:id], hidden: true  }, label: false
        end
        f.input :concernable_type, input_html: { value: params[:type], hidden: true  }, label: false
        f.input :kind, as: :string, input_html: { value: params[:kind], hidden: true  }, label: false
        
      elsif params[:kind] == "Restaurant Balance Payment"
        f.input :amount, required: true
        f.input :who_is_paying, label: "Who is paying?", :as => :select, 
                :collection => ['happy dining', 'restaurant']
        f.input :concernable_id, input_html: { value: params[:id], hidden: true  }, label: false
        f.input :concernable_type, input_html: { value: "Restaurant", hidden: true  }, label: false
        f.input :kind, input_html: { value: params[:kind], hidden: true  }, label: false
      else
        f.input :kind, label: "Please choose type of transaction you would like to create", :as => :select, 
                :collection => ['Adjustment', 'Restaurant Balance Payment']
        f.input :concernable_id, input_html: { value: params[:id], hidden: true  }, label: false
      end
    end
    f.actions
  end
end
