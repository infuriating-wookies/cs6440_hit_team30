# == Schema Information
#
# Table name: medications
#
#  id           :integer          not null, primary key
#  medical_name :string
#  common_name  :string
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Medication < ActiveRecord::Base
  has_many :user_medications
end
