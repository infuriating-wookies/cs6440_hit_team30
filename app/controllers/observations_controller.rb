class ObservationsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create
    FhirConnection.make_patient_height_observation(current_user.fhir_id, params["height"].to_i) if params['height']
    FhirConnection.make_patient_weight_observation(current_user.fhir_id, params["weight"].to_i) if params['weight']
    flash[:success] = 'Successfully uploaded your new height and weight'
    redirect_to basic_info_index_path
  end
end
