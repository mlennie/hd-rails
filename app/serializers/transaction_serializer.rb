class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :kind, :itemable_type, :itemable_id, :concernable_type,
  					 :concernable_id, :discount, :user_contribution, :amount, 
  					 :original_balance, :final_balance

end
