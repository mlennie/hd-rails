ActiveAdmin.register Menu do
  permit_params :restaurant_id, :name, :title, :description, :kind, :price

  belongs_to :restaurant

  controller do
    def scoped_collection
      Menu.where(restaurant_id: params[:restaurant_id]).get_unarchived
    end

    def destroy
      r = Menu.find(params[:id])
      r.archive
      flash[:success] = "You have successfully archived this resource"
      redirect_to admin_restaurant_menus_path( r.restaurant )
    end
  end

  sidebar "Menu Items", only: [:show] do
    ul do
      li link_to "Menu Items", admin_root_path + "/menus/" + Menu.find(params[:id]).id.to_s + "/menu_items"
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :title
    column :description
    column :kind
    column :price
    column :restaurant_id
    actions
  end

  filter :name
  filter :title
  filter :description
  filter :kind
  filter :price
  filter :restaurant_id

  form do |f|
    f.inputs "Menu Details" do
      f.input :name
      f.input :title
      f.input :description
      f.input :kind, as: :select, collection: Menu.kinds.keys
      f.input :price
    end
    f.actions
  end

end
