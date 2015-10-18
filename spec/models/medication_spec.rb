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

require 'rails_helper'

RSpec.describe Medication, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
