ActiveAdmin.register Restaurant do
  permit_params :name, :emails, :phone, :street, :district, :city, :country,
                :zipcode, :user_id, :wallet_id

  controller do
    def scoped_collection
      Restaurant.get_unarchived
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
      li link_to "Reservations", admin_restaurant_reservations_path(restaurant)
      li link_to "Reservation Errors", admin_restaurant_reservation_errors_path(restaurant)
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :emails, rescue: nil
    column :street
    column :district
    column :city
    column :country
    column :zipcode
    column :user_id
    column :wallet_id
    column :created_at
    actions
 end

  filter :name
  filter :emails, rescue: nil
  filter :street
  filter :district
  filter :city
  filter :country
  filter :zipcode
  filter :user_id
  filter :wallet_id

  form do |f|
    f.inputs "Restaurant Details" do
      f.input :name
      f.input :emails, rescue: nil
      f.input :street
      f.input :district
      f.input :city
      f.input :country, default: "France"
      f.input :zipcode
      f.input :user_id, as: :select, collection: User.get_unarchived
    end
    f.actions
 end
end
