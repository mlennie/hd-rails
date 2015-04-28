ActiveAdmin.register Invoice do
  permit_params :previous_balance, :additional_balance, :hd_percent, :due_date,
  							:date_paid, :confirmation, :total_amount_paid, :restaurant_id

  belongs_to :restaurant, optional: true

  controller do
    def scoped_collection
      Invoice.get_unarchived
    end

    def create

      if params[:invoice][:restaurant_id] || params[:restaurant_id]
        restaurant_id = params[:invoice][:restaurant_id] || params[:restaurant_id]
        if params[:invoice][:start_date] && params[:invoice][:end_date]
      else
        flash[:danger] = "Please select a restaurant"
        redirect_to new_admin_invoice_path
      end
    end

    def destroy
      r = Invoice.find(params[:id])
      r.archive
      flash[:success] = "You have successfully archived this resource"
      redirect_to admin_invoices_path
    end
  end

  index do
    selectable_column
    id_column
    column :previous_balance
    column :additional_balance
    column :hd_percent
    column :due_date
    column :date_paid
    column :confirmation
    column :total_amount_paid
    column :restaurant_id
    column :created_at
    actions
 end

  filter :previous_balance
	filter :additional_balance
	filter :hd_percent
	filter :due_date
	filter :date_paid
	filter :confirmation
	filter :total_amount_paid
	filter :restaurant_id
	filter :created_at

  form do |f|
    f.inputs "Invoice Details" do
      unless params[:restaurant_id]
        f.input :restaurant
      end
      if params[:restaurant_id]
        restaurant = Restaurant.find(params[:restaurant_id])
        start_date = restaurant.get_invoice_start_date
      end
    end
    f.actions
 end
end
