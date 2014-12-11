class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :timeoutable and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :lockable #, :omniauthable
end
