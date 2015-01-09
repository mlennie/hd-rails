class WalletSerializer < ActiveModel::Serializer
  attributes :id, :balance #, :concernable_type, :concernable_id

=begin
 	def attributes
    data = super
    data[:concernable] = {id: data[:concernable_id], type: data[:concernable_type]}
    data.delete(:concernable_type)
    data.delete(:concernable_id)
    data
  end
=end

end
