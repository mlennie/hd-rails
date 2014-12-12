class RelatedTransaction < ActiveRecord::Base
  belongs_to :get_transaction, class_name: :transaction
end
