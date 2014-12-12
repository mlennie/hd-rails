class Invoice < ActiveRecord::Base

  belongs_to :restaurant
  belongs_to :invoice_transaction, class_name: :transaction
end
