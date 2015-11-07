# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  firstname              :string
#  lastname               :string
#  birthday               :date
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  fhir_id                :integer
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :user_medications

  def initialize(options={})
    FhirConnection.create_user(options[:lastname], options[:firstname], options[:gender], options[:address], options[:city], options[:state], options[:postal_code], options[:birthday])
    options[:fhir_id] = FhirConnection.find_user_id(options[:lastname], options[:firstname]).to_s
    options.delete(:city)
    options.delete(:address)
    options.delete(:state)
    options.delete(:gender)
    options.delete(:postal_code)
    super(options)
  end
end
