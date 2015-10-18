class MedicationsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: FhirConnection.get_patient_prescriptions(current_user.id)
  end
end
