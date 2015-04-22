class Role < ActiveRecord::Base
  has_many :user_roles
  has_many :users, through: :user_roles

  def self.superadmin
    find_by(name: "superadmin")
  end

  def self.owner
    find_by(name: "owner")
  end
end
