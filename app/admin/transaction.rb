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
        logs = parent.logs 
      else
        Transaction.get_unarchived
      end
    end

    def destroy
      r = Transaction.find(params[:id])
      r.archive
      flash[:success] = "You have successfully archived this resource"
      redirect_to admin_transactions_path
    end
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

end
