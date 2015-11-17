class BasicInfoController < ApplicationController
  before_action :authenticate_user!

  def index
    @height_info = FhirConnection.get_patient_height_observations(current_user.fhir_id)
    @weight_info =  FhirConnection.get_patient_weight_observations(current_user.fhir_id)
    @current_user = current_user
    respond_to do |format|
      format.html
      format.json { render json: [@height_info, @weight_info] }
    end
  end
end
