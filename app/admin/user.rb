ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :last_name,
                :first_name, :phone, :birth_date, :gender, :wallet_id, :street,
                :district, :city, :state, :country, :zipcode

  controller do
    def scoped_collection
      User.get_unarchived
    end

    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
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
      li link_to 'View Transactions', admin_transactio_path(id: user.id, type: "User")
    end
  end

  index do
    selectable_column
    id_column
    column :last_name
    column :first_name
    column :balance do |user|
      unless user.wallet.present?
        Wallet.create_for_user user
      end
      user.wallet.balance.nil? ? 0 : user.wallet.balance 
    end
    column :email
    column :phone
    column :birth_date
    column :gender
    column 'Balance' do |user|
      if user.try(:wallet).try(:balance)
        user.wallet.balance.to_s + '€'
      else
        '0€'
      end
    end
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
  filter :created_at

  form do |f|
    f.inputs "User Details" do
      f.input :last_name
      f.input :first_name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :last_name
      f.input :first_name
      f.input :phone
      f.input :birth_date, :as => :date_picker
      f.input :gender, as: :select, collection:['Male', 'Female']
      f.input :street
      f.input :district
      f.input :city
      f.input :state
      f.input :country, default: "France"
      f.input :zipcode
    end
    f.actions
 end
end
