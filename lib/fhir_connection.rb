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
      query: {'patient._id' => user_id}
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

  def self.get_patient_bmi_observations(user_id)
    href = BASE_URL + "/Observation"
    r = HTTParty.get(href,
                     headers: DEFAULT_HEADERS,
                     query: {
                         'patient' => user_id,
                         'code' => 'LOINC|39156-5'
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

  def self.make_patient_bmi_observation(user_id, bmi_in_kg_m2)
    href = BASE_URL + "/Observation"
    r = HTTParty.post(href,
                      headers: CREATE_HEADERS,
                      body: bmi_measurement_json(user_id, bmi_in_kg_m2)
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

  # this looks up a user by their first and alst name and returns their ID
  def self.find_user_id(last_name, first_name)
    href = BASE_URL + "/Patient"
    r = HTTParty.get(href,
      headers: DEFAULT_HEADERS,
      query: {
        'family' => last_name,
        'given' => first_name,
      }
    )
    return nil unless r.success?
    JSON.parse(r.body)['entry'][0]['resource']['id']
  end

  private

  def self.height_measurement_json(patient_id, height_in_cm)
    {
      resourceType: "Observation",
      code: {
        coding: [
          {
            system: "http://loinc.org",
            code: "8302-2",
            display:"Body height Measured"
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
            code: "3141-9",
            display:"Body weight Measured"
          }
        ]
      },
      valueQuantity: {
        value: weight_in_kg,
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

  def self.bmi_measurement_json(patient_id, bmi_in_kg_m2)
    {
        resourceType: "Observation",
        code: {
            coding: [
                {
                    system: "http://loinc.org",
                    code: "39156-5",
                    display:"Body mass index (BMI) [Ratio]"
                }
            ]
        },
        valueQuantity: {
            value: bmi_in_kg_m2,
            units: "kg/m2",
            system: "http://unitsofmeasure.org",
            code: "kg/m2"
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

  # def self.get_patient_condition(user_id, id)
  #
  #   href = BASE_URL + "/Condition"
  #   r = HTTParty.get(href,
  #                    headers: DEFAULT_HEADERS,
  #                    query: {'patient' => user_id, '_id' =>id}
  #   )
  #   return nil unless r.success?
  #   JSON.parse(r.body)
  # end
end
