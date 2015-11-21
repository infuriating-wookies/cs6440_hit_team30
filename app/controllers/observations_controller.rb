class ObservationsController < ApplicationController
  require 'pry'
  before_action :authenticate_user!

  def index
  end

  def create
    FhirConnection.make_patient_height_observation(current_user.fhir_id, params["height"].to_i) if params['height']
    FhirConnection.make_patient_weight_observation(current_user.fhir_id, params["weight"].to_i) if params['weight']
    #binding.pry
    if defined? params['height'].to_i
      if defined? params['weight'].to_i
        if params['height'].to_i > 0
          bmi = params["weight"].to_i * 100 * 100 / (params["height"].to_i * params["height"].to_i)
          #binding.pry
          FhirConnection.make_patient_bmi_observation(current_user.fhir_id, bmi.to_i)
          #binding.pry
        end
      end
    end
    flash[:success] = 'Successfully uploaded your new height and weight'
    redirect_to basic_info_index_path
  end
end
