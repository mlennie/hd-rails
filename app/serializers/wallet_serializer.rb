class WalletSerializer < ActiveModel::Serializer
  attributes :id, :balance, :concernable_type, :concernable_id
end
