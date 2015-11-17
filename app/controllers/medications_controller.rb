class MedicationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @medication_json = FhirConnection.get_patient_prescriptions(current_user.fhir_id)
    medication_ids = []
    if @medication_json['total'] > 0
      @medication_json["entry"].each do |entry|
        medication_ids << entry['resource']['medication']['reference']
      end
      @specific_medications = Hash[medication_ids.map { |e| [e, FhirConnection.get_medication(e)] }]
    else
      @specific_medications = {}
    end
    respond_to do |format|
      format.html
      format.json { render json: @medication_json }
    end
  end
end
