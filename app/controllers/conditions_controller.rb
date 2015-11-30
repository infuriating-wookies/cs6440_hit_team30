class ConditionsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create
    FhirConnection.make_patient_condion(current_user.fhir_id, params["condCode"].to_i, params["condDisplay"].to_s) if params['condCode'] and params['condDisplay']
    #binding.pry
    flash[:success] = 'Successfully uploaded your new condition'
    redirect_to basic_info_index_path
  end
end
