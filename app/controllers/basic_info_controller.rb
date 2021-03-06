class BasicInfoController < ApplicationController
  before_action :authenticate_user!

  def index
    @height_info = FhirConnection.get_patient_height_observations(current_user.fhir_id)
    @weight_info =  FhirConnection.get_patient_weight_observations(current_user.fhir_id)
    @bmi_info = FhirConnection.get_patient_bmi_observations(current_user.fhir_id)
    @condition_info = FhirConnection.get_patient_condions(current_user.fhir_id)
    @current_user = current_user
    respond_to do |format|
      format.html
      format.json { render json: [@height_info, @weight_info, @bmi_info, @condition_info] }
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    update_status = @user.update_attributes(params[:user].permit(:firstname, :lastname, :email, :birthday, :state, :gender, :address, :postal_code))
    if update_status
      redirect_to basic_info_index_path
    else
      render :edit
    end
  end
end
