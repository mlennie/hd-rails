ActiveAdmin.register Invoice do
  permit_params :previous_balance, :additional_balance, :hd_percent, :due_date,
  							:date_paid, :confirmation, :total_amount_paid, :restaurant_id

  belongs_to :restaurant, optional: true
  menu false

  controller do
    def scoped_collection
      Invoice.get_unarchived
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
      f.input :previous_balance
			f.input :additional_balance
			f.input :hd_percent
			f.input :due_date
			f.input :date_paid
			f.input :confirmation
			f.input :total_amount_paid
			f.input :restaurant_id
    end
    f.actions
 end
end
