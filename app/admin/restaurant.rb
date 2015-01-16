ActiveAdmin.register Restaurant do
  permit_params :name, :emails, :street, :district, :city, :country,
                :zipcode, :user_id, :wallet_id, :wants_sms_per_reservation,
                :wants_phonecall_per_reservation, :has_computer_in_restaurant,
                :cuts_midi_sevice_in_2, :cuts_soir_service_in_2,
                :service_midi_start, :service_midi_end, :service_soir_start,
                :service_soir_end, :day_with_most_people,
                :want_10_or_more_people, :client_more_business,
                :client_more_tourists, :other_restaurants, :cuisine, 
                :description, :img_url, :owner_name, :responsable_name, 
                :communications_name, :server_one_name, :server_two_name, 
                :restaurant_phone, :responsable_phone, :principle_email, 
                :second_email, :cuisine_ids

  controller do
    def scoped_collection
      Restaurant.get_unarchived
    end

    before_create do |r|
      unless params[:restaurant][:cuisine_ids].empty?
        params[:restaurant][:cuisine_ids].each do |c_id| 
          r.cuisines << Cuisine.find(c_id.to_i) if Cuisine.exists?(c_id.to_i)
        end
      end
    end

    def update
      r = Restaurant.find(params[:id])
      unless params[:restaurant][:cuisine_ids].empty?
        params[:restaurant][:cuisine_ids].each do |c_id| 
          unless r.cuisines.include? Cuisine.find(c_id.to_i)
            r.cuisines << Cuisine.find(c_id.to_i) if Cuisine.exists?(c_id.to_i)
          end
        end
      end
      super
    end

    def destroy
      r = Restaurant.find(params[:id])
      r.archive
      flash[:success] = "You have successfully archived this resource"
      redirect_to admin_restaurants_path
    end
  end

  sidebar "Services and Reservations", only: [:show, :edit] do
    ul do
      li link_to "Services",    admin_restaurant_services_path(restaurant)
      #li link_to "Reservations", admin_restaurant_reservations_path(restaurant)
      li link_to "Invoices", admin_restaurant_invoices_path(restaurant)
      li link_to "Reservation Errors", admin_restaurant_reservation_errors_path(restaurant)
      li link_to 'View Transactions', admin_transactions_path(id: restaurant.id, type: "Restaurant")
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column 'Cuisines' do |r|
      cuisines = r.cuisines.map do |c|
        c.name
      end
      cuisines.join(', ')
    end
    column :description
    column :img_url
    column :owner_name
    column :responsable_name
    column :communications_name
    column :server_one_name
    column :server_two_name
    column :restaurant_phone
    column :responsable_phone
    column :principle_email
    column :second_email
    column :street
    column :district
    column :city
    column :country
    column :zipcode
    column 'Balance' do |restaurant|
      if restaurant.try(:wallet).try(:balance)
        restaurant.wallet.balance.to_s + '€'
      else
        '0€'
      end
    end
    column :created_at
    column :wants_sms_per_reservation
    column :wants_phonecall_per_reservation
    column :has_computer_in_restaurant
    column :cuts_midi_sevice_in_2
    column :cuts_soir_service_in_2
    column :service_midi_start
    column :service_midi_end
    column :service_soir_start
    column :service_soir_end
    column :day_with_less_people
    column :day_with_most_people
    column :want_10_or_more_people
    column :client_more_business
    column :client_more_tourists
    column :other_restaurants
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row 'Cuisines' do |r|
        cuisines = r.cuisines.map do |c|
          c.name
        end
        cuisines.join(', ')
      end
      row :description
      row :img_url
      row :owner_name
      row :responsable_name
      row :communications_name
      row :server_one_name
      row :server_two_name
      row :restaurant_phone
      row :responsable_phone
      row :principle_email
      row :second_email
      row :street
      row :district
      row :city
      row :country
      row :zipcode
      row 'Balance' do |restaurant|
        if restaurant.try(:wallet).try(:balance)
          restaurant.wallet.balance.to_s + '€'
        else
          '0€'
        end
      end
      row :created_at
      row :wants_sms_per_reservation
      row :wants_phonecall_per_reservation
      row :has_computer_in_restaurant
      row :cuts_midi_sevice_in_2
      row :cuts_soir_service_in_2
      row :service_midi_start
      row :service_midi_end
      row :service_soir_start
      row :service_soir_end
      row :day_with_less_people
      row :day_with_most_people
      row :want_10_or_more_people
      row :client_more_business
      row :client_more_tourists
      row :other_restaurants
    end
 end

  filter :name
  filter :img_url
  filter :description
  filter :cuisines
  filter :owner_name
  filter :responsable_name
  filter :communications_name
  filter :server_one_name
  filter :server_two_name
  filter :restaurant_phone
  filter :responsable_phone
  filter :principle_email
  filter :second_email
  filter :street
  filter :district
  filter :city
  filter :country
  filter :zipcode
  filter :user_id
  filter :wallet_id
  filter :created_at
  filter :wants_sms_per_reservation
  filter :wants_phonecall_per_reservation
  filter :has_computer_in_restaurant
  filter :cuts_midi_sevice_in_2
  filter :cuts_soir_service_in_2
  filter :service_midi_start, rescue: nil
  filter :service_midi_end
  filter :service_soir_start
  filter :service_soir_end
  filter :day_with_less_people
  filter :day_with_most_people
  filter :want_10_or_more_people
  filter :client_more_business
  filter :client_more_tourists
  filter :other_restaurants

  form do |f|
    f.inputs "Restaurant Details" do
      f.input :name
      f.input :img_url
      f.input :description
      f.input :cuisines, as: :select, collection: Cuisine.get_unarchived, multiple: true
      f.input :owner_name
      f.input :responsable_name
      f.input :communications_name
      f.input :server_one_name
      f.input :server_two_name
      f.input :restaurant_phone
      f.input :responsable_phone
      f.input :principle_email
      f.input :second_email
      f.input :street
      f.input :district
      f.input :city
      f.input :country
      f.input :zipcode
      f.input :user_id, as: :select, collection: User.get_unarchived
      f.input :wallet_id
      f.input :wants_sms_per_reservation
      f.input :wants_phonecall_per_reservation
      f.input :has_computer_in_restaurant
      f.input :cuts_midi_sevice_in_2
      f.input :cuts_soir_service_in_2
      f.input :service_midi_start
      f.input :service_midi_end
      f.input :service_soir_start
      f.input :service_soir_end
      f.input :day_with_less_people
      f.input :day_with_most_people
      f.input :want_10_or_more_people
      f.input :client_more_business
      f.input :client_more_tourists
      f.input :other_restaurants
    end
    f.actions
 end
end
