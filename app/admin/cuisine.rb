ActiveAdmin.register Cuisine do
  permit_params :name

  controller do
    def scoped_collection
      Cuisine.get_unarchived
    end

    def destroy
    end
  end
end