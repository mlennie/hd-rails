ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :last_name,
                :first_name, :phone, :birth_date, :gender, :wallet_id, :street,
                :district, :city, :state, :country, :zipcode

  controller do
    def scoped_collection
      User.get_unarchived
    end

    def create
    
      #make owner and don't send confirmation email if a 
      #restaurant was selected
      if restaurant_id = params[:user][:restaurant]

        #delete restaurant param so does not interfere later
        params[:user].delete(:restaurant)

        #build new user
        user = User.new permitted_params[:user]
        restaurant = Restaurant.find(restaurant_id)
        user.restaurants << restaurant
        user.confirmed_at = Time.new
        user.skip_confirmation!
      else #user is not an owner since no restaurant was selected
        user = User.new permitted_params[:user]
      end

      if user.save

        #MIXPANEL: add registration event
        @tracker.track(user.id.to_s , 'Registered', { 'Made By' => 'Admin' } )
        #MIXPANEL: add new user profile
        @tracker.people.set(user.id.to_s, {
          '$first_name'       => user.first_name,
          '$last_name'        => user.last_name,
          '$email'            => user.email,
          '$phone'            => user.phone,
          'Gender'            => user.gender
        })

        #flash notice and redirect
        flash[:success] = "You have successfully created this user"
        redirect_to admin_user_path user
      else
        flash[:danger] = "Zut!! User could not be saved! Please make sure email is not already used and that all required fields are filled"
        redirect_to new_admin_user_path user
      end
    end

    def update
      if params[:user][:password].blank? && 
        params[:user][:password_confirmation].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
      super
    end

    def destroy
      user = User.find(params[:id])
      user.archive
      flash[:success] = "You have successfully archived this resource"
      redirect_to admin_users_path
    end
  end

  sidebar "Services and Reservations", only: [:show] do
    ul do
      li link_to 'New Reservation', new_admin_user_reservation_path(user)
      li link_to 'View Reservations', admin_user_reservations_path(user)
      li link_to 'New Transaction', new_admin_user_transaction_path(user)
      li link_to 'View Transactions', admin_transactions_path(id: user.id, type: "User")
    end
  end

  index do
    selectable_column
    id_column
    column :last_name
    column :first_name
    column 'Balance' do |user|
      if user.try(:wallet).try(:balance)
        user.wallet.balance.to_s + '€'
      else
        '0€'
      end
    end
    column :email
    column :owner do |user|
      user.restaurants.any? ? 'Yes' : 'No'
    end
    column :restaurant do |user|
      restaurant = user.restaurants.get_unarchived.first
      if restaurant
        link_to restaurant.name, admin_restaurant_path(restaurant.id)
      end 
    end
    column :phone
    column :birth_date
    column :gender
    column :street
    column :district
    column :city
    column :state
    column :country
    column :zipcode
    column :referrer_id
    column :referrer_paid
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :confirmed_at
    actions
 end

  filter :email
  filter :last_name
  filter :first_name
  filter :phone
  filter :birth_date
  filter :gender
  filter :wallet_id
  filter :street
  filter :district
  filter :city
  filter :state
  filter :country
  filter :zipcode
  filter :referrer_id
  filter :referrer_paid
  filter :current_sign_in_at
  filter :sign_in_count

  form do |f|
    f.inputs "User Details" do
      f.input :last_name
      f.input :first_name
      f.input :email
      f.input :restaurant, as: :select, collection: Restaurant.get_unarchived.where(user_id: nil),
              label: "Restaurant (select to make user owner and not send confirmation email)"
      f.input :password
      f.input :password_confirmation
      f.input :phone
      f.input :birth_date, :as => :date_picker
      f.input :gender, as: :select, collection:['Male', 'Female']
      f.input :street
      f.input :district
      f.input :city
      f.input :state
      f.input :country, default: "France"
      f.input :zipcode
      f.input :created_at
    end
    f.actions
 end
end
