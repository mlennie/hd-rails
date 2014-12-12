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

  index do
    selectable_column
    id_column
    column :name
    column :emails
    column :phone
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
  filter :emails
  filter :phone
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
      f.input :emails
      f.input :phone
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
