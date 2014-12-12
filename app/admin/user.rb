ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :last_name,
                :first_name, :phone, :birth_date, :gender, :wallet_id, :street,
                :district, :city, :state, :country, :zipcode

  index do
    selectable_column
    id_column
    column :email
    column :last_name
    column :first_name
    column :phone
    column :birth_date
    column :gender
    column :wallet_id
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
    f.inputs "Admin Details" do
      f.input :email
      f.input :last_name
      f.input :first_name
      f.input :phone
      f.input :birth_date, :as => :date_picker
      f.input :gender, as: :select, collection:['Male', 'Female']
      f.input :street
      f.input :district
      f.input :city
      f.input :state
      f.input :country
      f.input :zipcode
    end
    f.actions
 end
end
