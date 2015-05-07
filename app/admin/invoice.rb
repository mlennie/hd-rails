ActiveAdmin.register Invoice do
  permit_params :previous_balance, :additional_balance, :hd_percent, :due_date,
  							:date_paid, :confirmation, :total_amount_paid, :restaurant_id,
                :start_date, :end_date, :paid

  belongs_to :restaurant, optional: true

  controller do
    def scoped_collection
      if params[:restaurant_id]
        Invoice.get_unarchived.where(restaurant_id: params[:restaurant_id])
      else
        Invoice.get_unarchived
      end
    end

    def create
      #check if request is to send email and send email if so.
      #could not figure out how to make an active admin seperate action (batch action)
      #so that's why I'm unpleasently putting it in the create action
      if params[:email]
        invoice = Invoice.find(params[:invoice_id])
        if invoice.send_email params
          flash[:notice] = "Email has been sent!"
          redirect_to admin_invoice_path(invoice)
        else
          flash[:danger] = "Oops could not send email"
          redirect_to admin_invoice_path(invoice)
        end
        return true
      end

      #check if invoice is at final step or else go through invoice build steps
      if params[:invoice][:complete]
        params[:start_date] = params[:invoice][:start]
        params[:end_date] = params[:invoice][:end]
        invoice_data = Restaurant.calculate_information_for_invoice params

        #build invoice
        invoice = Invoice.make_new invoice_data

        #save invoice and archive all invoices for restaurant that have not been paid
        if (invoice.save! && invoice.restaurant.archive_unpaid_invoices(invoice))
          flash[:notice] = "You have successfully created this invoice"
          redirect_to admin_invoice_path(invoice)
        else
          flash[:danger] = "Could not create invoice there was a problem"
          redirect_to new_admin_invoice_path
        end
      else
        #start invoice creation steps
        if params[:invoice][:restaurant_id].present? || params[:restaurant_id].present?
          restaurant_id = params[:invoice][:restaurant_id] || params[:restaurant_id]
          restaurant = Restaurant.find(restaurant_id)
          #make sure restaurant has commission_percentage set
          if restaurant.commission_percentage
            if params[:invoice][:start_date] && params[:invoice][:end_date]
              #make sure restaurant had reservations during these times
              reservations = Reservation.get_for_invoice(params)
              if reservations.any?
                date_params = Restaurant.get_date_params params
                flash[:notice] = "Please review and submit invoice."
                redirect_to new_admin_restaurant_invoice_path(restaurant_id, date_params)
              else
                flash[:warning] = "No reservations were made during these times. Please select a later date."
                redirect_to new_admin_restaurant_invoice_path restaurant_id
              end
            else
              flash[:notice] = "Please select an end date"
              redirect_to new_admin_restaurant_invoice_path restaurant_id
            end
          else
            flash[:warning] = "Please add commission_percentage to this restaurant"
            redirect_to new_admin_restaurant_invoice_path restaurant_id
          end
        else
          flash[:danger] = "Please select a restaurant"
          redirect_to new_admin_invoice_path
        end
      end
    end

    def destroy
      r = Invoice.find(params[:id])
      if !r.paid? 
        r.archive
        flash[:notice] = "You have successfully archived this resource"
        redirect_to admin_invoices_path
      else
        flash[:danger] = "Cannot delete. This invoice has already been paid."
        redirect_to admin_invoices_path
      end
    end
  end

  sidebar "Email Invoice", only: [:show, :edit] do
    ul do
      li link_to "Send test email to admin",    admin_invoices_path(invoice_id: invoice.id, email: "test"), method: "post"
      li link_to "Send invoice to restaurant",    admin_invoices_path(invoice_id: invoice.id, email: "restaurant"), method: "post"
    end
  end

  show do 
    invoice = Invoice.find(params[:id])
    params = {}
    params[:start_date] = invoice.start_date
    params[:end_date] = invoice.end_date
    params[:restaurant_id] = invoice.restaurant_id
    invoice = Restaurant.calculate_information_for_invoice params
    render partial: "invoice", locals: { invoice: invoice }
  end

  index do
    selectable_column
    id_column
    column :paid
    column :pre_tax_owed
    column :total_owed
    column :final_balance
    column :commission_percentage
    column :restaurant_id
    column :start_date
    column :end_date
    column :created_at
    actions
 end

  filter :paid
  filter :pre_tax_owed
  filter :total_owed
  filter :final_balance
  filter :commission_percentage
  filter :restaurant_id
  filter :start_date
  filter :end_date
  filter :created_at

  form do |f|
    f.inputs "Invoice Details" do
      if f.object.new_record? 
        #1.first make sure a restaurant is selected
        if !params[:restaurant_id] 
          f.input :restaurant
        elsif !params[:start_date] || !params[:end_date]
          #2.get start and end dates 
          restaurant_id = params[:restaurant_id] 
          restaurant = Restaurant.find(restaurant_id)
          start_date = restaurant.get_invoice_start_date
          f.input :start_date, as: :string, input_html: { value: start_date, readonly: true }
          end_date_array = restaurant.get_invoice_end_date_array
          f.input :end_date, as: :select, collection: end_date_array
        else
          #3. Calculate invoice information and show invoice
          invoice = Restaurant.calculate_information_for_invoice params
          f.input :start, label: false, input_html: { value: invoice[:start_date], hidden: true }
          f.input :end, label: false, input_html: { value: invoice[:end_date], hidden: true }
          f.input :complete, label: false, input_html: { value: true, hidden: true }
          render partial: "invoice", locals: { invoice: invoice, f: f }
        end
      else #not new (editing)
        f.input :paid
      end
    end
    f.actions
 end
end
