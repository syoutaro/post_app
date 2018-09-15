# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#

class User < ApplicationRecord

  validates :name,
          presence: :true,
          uniqueness: { case_sensitive: false }

  validates_format_of :name, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  validate :validate_username

  attr_accessor :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

        def login=(login)
          @login = login
        end

        def login
          @login || self.name || self.email
        end

        def self.find_for_database_authentication(warden_conditions)
          conditions = warden_conditions.dup
          if login = conditions.delete(:login)
           where(conditions.to_h).where(["lower(name) = :value OR lower(email) = :value",
            { :value => login.downcase }]).first
          elsif conditions.has_key?(:name) || conditions.has_key?(:email)
           where(conditions.to_h).first
          end
        end
      
        def validate_username
          if User.where(email: name).exists?
            errors.add(:name, :invalid)
          end
        end
end
