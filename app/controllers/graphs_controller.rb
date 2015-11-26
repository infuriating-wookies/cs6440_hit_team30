class GraphsController < ApplicationController

  def index
    @height_data = FhirConnection.graphable_height_info(current_user.fhir_id)
    @weight_data = FhirConnection.graphable_weight_info(current_user.fhir_id)
    @bmi_data= FhirConnection.graphable_bmi_info(current_user.fhir_id)
  end
end
