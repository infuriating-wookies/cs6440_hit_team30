class TestController < ApplicationController

  def show
    @raw_info = FhirConnection.get_patient_info(params[:id])
  end
end
