class ConditionsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create
    FhirConnection.make_patient_condion_diabetes(current_user.fhir_id) if params['diabetes']=='yes'
    FhirConnection.make_patient_condion_diabetes_t2(current_user.fhir_id) if params['diabetesT2']=='yes'
    FhirConnection.make_patient_condion_hypertension(current_user.fhir_id) if params['hypertension']=='yes'
    FhirConnection.make_patient_condion_arthritis(current_user.fhir_id) if params['arthritis']=='yes'
    FhirConnection.make_patient_condion_coronary(current_user.fhir_id) if params['coronary']=='yes'

    flash[:success] = 'Successfully uploaded your new conditions'
    redirect_to basic_info_index_path
  end
end
