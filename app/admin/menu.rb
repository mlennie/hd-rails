ActiveAdmin.register Menu do
  permit_params :restaurant_id, :course, :description, :price

  belongs_to :restaurant

  controller do
    def scoped_collection
      Menu.where(restaurant_id: params[:restaurant_id]).get_unarchived
    end

    def create
      params[:menu][:restaurant_id] = params[:restaurant_id]
      params.delete("restaurant_id")
      super
    end

    def destroy
      r = Menu.find(params[:id])
      r.archive
      flash[:success] = "You have successfully archived this resource"
      redirect_to admin_restaurant_menus_path r.restaurant
    end
  end

  index do
    selectable_column
    id_column
    column :course do |menu|
      courses = ['entree', 'principaux', 'dessert']
      courses[menu.course]
    end
    column :description
    column :price
    column :restaurant_id
    actions
  end

  filter :course
  filter :description
  filter :price
  filter :restaurant_id

  form do |f|
    f.inputs "Menu Details" do
      f.input :course, as: :select, 
              collection: ['entree', 'principaux', 'dessert']
      f.input :description
      f.input :price
    end
    f.actions
  end

end
