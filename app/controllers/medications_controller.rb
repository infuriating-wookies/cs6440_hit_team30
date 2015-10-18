class MedicationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @medication_json = FhirConnection.get_patient_prescriptions(current_user.id)
  end
end
