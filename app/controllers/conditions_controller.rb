class ConditionsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create
    FhirConnection.make_patient_condion_diabetes(current_user.fhir_id) if params['diabetes']='yes'
    flash[:success] = 'Successfully uploaded your new conditions'
    redirect_to basic_info_index_path
  end
end
