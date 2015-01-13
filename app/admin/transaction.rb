ActiveAdmin.register Transaction do
  permit_params :id, :kind, :original_balance, :amount, :amount_positive,
                :final_balance, :confirmation, :itemable_type, :itemable_id, 
                :itemable, :concernable, :concernable_type, :concernable_id

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

end
