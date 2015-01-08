class WalletSerializer < ActiveModel::Serializer
  attributes :id, :balance, :concernable_type, :concernable_id

  belongs_to :concernable, polymorphic: true

  embed :ids, :include => true

  def attributes
    data = super
    data[:concernable] = {id: data[:concernable_id], type: data[:concernable_type]}
    data.delete(:concernable_type)
    data.delete(:concernable_id)
    data
  end

end
