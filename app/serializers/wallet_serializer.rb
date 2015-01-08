class WalletSerializer < ActiveModel::Serializer
  attributes :id, :balance, :concernable_type, :concernable_id

  belongs_to :concernable, polymorphic: true

  embed :ids, :include => true

end
