# == Schema Information
#
# Table name: user_medications
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  medication_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class UserMedication < ActiveRecord::Base
  belongs_to :user
  belongs_to :medication
end
