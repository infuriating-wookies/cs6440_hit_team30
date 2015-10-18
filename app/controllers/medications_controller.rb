class MedicationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @medication_json = FhirConnection.get_patient_prescriptions(current_user.id)
    medication_ids = []
    @medication_json["entry"].each do |entry|
      medication_ids << entry['resource']['medication']['reference']
    end
    @specific_medications = medication_ids.map { |e| FhirConnection.get_medication(e) }
  end
end
