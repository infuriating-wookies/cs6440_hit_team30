class FhirConnection

  FHIR_URL = 'http://polaris.i3l.gatech.edu:8080'

  BASE_PATH = '/gt-fhir-webapp/base'

  BASE_URL = FHIR_URL + BASE_PATH

  USER_AGENT = 'HAPI-FHIR/1.1 (FHIR Client)'

  DEFAULT_HEADERS = {
    "User-Agent" => USER_AGENT,
    "Accept" => 'application/json'
  }

  CREATE_HEADERS = DEFAULT_HEADERS.merge('Content-Type' => 'application/json+fhir')

  def self.get_patient_info(id)
    href = BASE_URL + "/Patient/#{id}"
    r = HTTParty.get(href,
      headers: DEFAULT_HEADERS
    )
    return nil unless r.success?
    JSON.parse(r.body)
  end

  def self.get_patient_prescriptions(user_id)
    href = BASE_URL + "/MedicationPrescription"
    r = HTTParty.get(href,
      headers: DEFAULT_HEADERS,
      query: {'patient' => user_id}
    )
    return nil unless r.success?
    JSON.parse(r.body)
  end

  def self.get_patient_height_observations(user_id)
    href = BASE_URL + "/Observation"
    r = HTTParty.get(href,
      headers: DEFAULT_HEADERS,
      query: {
        'patient' => user_id,
        'code' => 'LOINC|8302-2'
      }
    )
    return nil unless r.success?
    JSON.parse(r.body)
  end

  def self.get_patient_weight_observations(user_id)
    href = BASE_URL + "/Observation"
    r = HTTParty.get(href,
      headers: DEFAULT_HEADERS,
      query: {
        'patient' => user_id,
        'code' => 'LOINC|3141-9'
      }
    )
    return nil unless r.success?
    JSON.parse(r.body)
  end

  def self.make_patient_height_observation(user_id, height_in_inches)
    href = BASE_URL + "/Observation"
    r = HTTParty.post(href,
      headers: CREATE_HEADERS,
      body: height_measurement_json(user_id, height_in_inches)
    )
    return r.code == 201
  end

  def self.make_patient_weight_observation(user_id, weight_in_kg)
    href = BASE_URL + "/Observation"
    r = HTTParty.post(href,
      headers: CREATE_HEADERS,
      body: height_measurement_json(user_id, weight_in_kg)
    )
    return r.code == 201
  end

  def self.get_medication(id)
    href = BASE_URL + "/Medication"
    r = HTTParty.get(href,
      headers: DEFAULT_HEADERS,
      query: {'_id' => id}
    )
    return nil unless r.success?
    JSON.parse(r.body)
  end

  # Takes in the given data and creates a user with that information. Unfortunately the API
  # does not return an id for the user it created to we will need to find a way around this.
  def self.create_user(last_name, first_name, gender, address, city, state, postal_code, birth_date)
    href = BASE_URL + "/Patient"
    r = HTTParty.post(href,
      headers: CREATE_HEADERS,
      body: user_creation_json(last_name, first_name, gender, address, city, state, postal_code, birth_date)
    )
    return r.code == 201
  end

  private

  def self.height_measurement_json(patient_id, height_in_cm)
    {
      resourceType: "Observation",
      code: {
        coding: [
          {
            system: "http://loinc.org",
            code: "8302-2"
          }
        ]
      },
      valueQuantity: {
        value: height_in_cm,
        units: "cm",
        system: "http://unitsofmeasure.org",
        code: "cm"
      },
      appliesDateTime: Time.now.strftime("%Y-%m-%dT%H:%M:%S%z"),
      status: "final",
      subject: {
        reference: "Patient/#{patient_id}"
      }
    }.to_json
  end

  def self.weight_measurement_json(patient_id, weight_in_kg)
    {
      resourceType: "Observation",
      code: {
        coding: [
          {
            system: "http://loinc.org",
            code: "3141-9"
          }
        ]
      },
      valueQuantity: {
        value: height_in_cm,
        units: "kg",
        system: "http://unitsofmeasure.org",
        code: "kg"
      },
      appliesDateTime: Time.now.strftime("%Y-%m-%dT%H:%M:%S%z"),
      status: "final",
      subject: {
        reference: "Patient/#{patient_id}"
      }
    }.to_json
  end

  def self.user_creation_json(last_name, first_name, gender, address, city, state, postal_code, birth_date)
    {
      resourceType: "Patient",
      name: [
        {
          family: [
            last_name
          ],
          given: [
            first_name
          ]
        }
      ],
      gender: gender,
      birthDate: birth_date.strftime("%Y-%m-%d"),
      address: [
        {
          line: [
            address
          ],
          city: city,
          state: state,
          postalCode: postal_code
        }
      ],
      active: true
    }.to_json
end

end
