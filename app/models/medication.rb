class Medication < ActiveRecord::Base
  has_many :user_medications
end
