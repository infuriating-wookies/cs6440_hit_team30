class FhirConnection

  FHIR_URL = 'http://polaris.i3l.gatech.edu:8080'

  BASE_PATH = '/gt-fhir-webapp/base'

  BASE_URL = FHIR_URL + BASE_PATH

  USER_AGENT = 'HAPI-FHIR/1.1 (FHIR Client)'

  DEFAULT_HEADERS = {
    "User-Agent" => USER_AGENT,
    "Accept" => 'application/json'
  }

  def self.get_patient_info(id)
    href = BASE_URL + "/Patient/#{id}"
    r = HTTParty.get(href,
      headers: DEFAULT_HEADERS
    )
    return nil unless r.success?
    JSON.parse(r.body)
  end

  def self.get_patient_prescriptions(id)
    href = BASE_URL + "/MedicationPrescription"
    r = HTTParty.get(href,
      headers: DEFAULT_HEADERS,
      query: {'patient._id' => id}
    )
    return nil unless r.success?
    JSON.parse(r.body)

  end


end
