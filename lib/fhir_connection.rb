class FhirConnection

  FHIR_URL = 'http://polaris.i3l.gatech.edu:8080'

  BASE_PATH = '/gt-fhir-webapp/base'

  BASE_URL = FHIR_URL + BASE_PATH

  USER_AGENT = 'HAPI-FHIR/1.1 (FHIR Client)'

  DEFAULT_HEADERS = {
    "User-Agent" => USER_AGENT,
    "Accept" => 'application/json'
  }

  class FhirClient
    include HTTParty
    default_timeout 1
  end

  CREATE_HEADERS = DEFAULT_HEADERS.merge('Content-Type' => 'application/json+fhir')

  def self.get_patient_info(id)
    href = BASE_URL + "/Patient/#{id}"
    r = FhirClient.get(href,
      headers: DEFAULT_HEADERS
    )
    return nil unless r.success?
    JSON.parse(r.body)
  rescue StandardError
    nil
  end

  def self.get_patient_prescriptions(user_id)
    href = BASE_URL + "/MedicationPrescription"
    r = FhirClient.get(href,
      headers: DEFAULT_HEADERS,
      query: {'patient._id' => user_id}
    )
    return nil unless r.success?
    JSON.parse(r.body)
  rescue StandardError
    nil
  end

  def self.get_patient_height_observations(user_id)
    href = BASE_URL + "/Observation"
    r = FhirClient.get(href,
      headers: DEFAULT_HEADERS,
      query: {
        'patient' => user_id,
        'code' => 'LOINC|8302-2'
      }
    )
    return nil unless r.success?
    JSON.parse(r.body)
  rescue StandardError
    nil
  end

  def self.get_patient_weight_observations(user_id)
    href = BASE_URL + "/Observation"
    r = FhirClient.get(href,
      headers: DEFAULT_HEADERS,
      query: {
        'patient' => user_id,
        'code' => 'LOINC|3141-9',
        '_count' => 200
      }
    )
    return nil unless r.success?
    JSON.parse(r.body)
  rescue StandardError
    nil
  end

  def self.get_patient_bmi_observations(user_id)
    href = BASE_URL + "/Observation"
    r = FhirClient.get(href, headers: DEFAULT_HEADERS,
      query: {
        'patient' => user_id,
        'code' => 'LOINC|39156-5',
        '_count' => 100
      }
    )
    #binding.pry
    return nil unless r.success?
    JSON.parse(r.body)
  rescue StandardError
    nil
  end

  def self.get_patient_condions(user_id)
    href = BASE_URL + "/Condition"
    r = FhirClient.get(href, headers: DEFAULT_HEADERS,
                     query: {
                         'patient' => user_id,
                         '_count' => 100
                     }
    )
    #binding.pry
    return nil unless r.success?
    JSON.parse(r.body)
  rescue StandardError
    nil
  end


  def self.make_patient_height_observation(user_id, height_in_inches)
    href = BASE_URL + "/Observation"
    r = FhirClient.post(href,
      headers: CREATE_HEADERS,
      body: height_measurement_json(user_id, height_in_inches)
    )
    return r.code == 201
  rescue StandardError
    nil
  end

  def self.make_patient_weight_observation(user_id, weight_in_kg)
    href = BASE_URL + "/Observation"
    body = weight_measurement_json(user_id, weight_in_kg)
    r = FhirClient.post(href,
      headers: CREATE_HEADERS,
      body: body
    )
    return r.code == 201
  rescue StandardError
    nil
  end

  def self.make_patient_bmi_observation(user_id, bmi_in_kg_cm2)
    href = BASE_URL + "/Observation"
    #binding.pry
    body = bmi_measurement_json(user_id, bmi_in_kg_cm2)
    #binding.pry
    r = FhirClient.post(href,
                      headers: CREATE_HEADERS,
                      body: body
    )
    #binding.pry
    return r.code == 201
  rescue StandardError
    nil
  end

  def self.make_patient_condion_diabetes(user_id)
    href = BASE_URL + "/Condition"
    body = make_condition_diabetes_json(user_id)
    r = FhirClient.post(href,
                      headers: CREATE_HEADERS,
                      body: body
    )
    return r.code == 201
  rescue StandardError
    nil
  end

  def self.make_patient_condion_diabetes_t2(user_id)
    href = BASE_URL + "/Condition"
    body = make_condition_diabetes_t2_json(user_id)
    r = FhirClient.post(href,
                      headers: CREATE_HEADERS,
                      body: body
    )
    return r.code == 201
  rescue StandardError
    nil
  end

  def self.make_patient_condion_hypertension(user_id)
    href = BASE_URL + "/Condition"
    body = make_condition_hypertension_json(user_id)
    r = FhirClient.post(href,
                      headers: CREATE_HEADERS,
                      body: body
    )
    return r.code == 201
  rescue StandardError
    nil
  end

  def self.make_patient_condion_coronary(user_id)
    href = BASE_URL + "/Condition"
    body = make_condition_coronary_json(user_id)
    r = FhirClient.post(href,
                      headers: CREATE_HEADERS,
                      body: body
    )
    return r.code == 201
  rescue StandardError
    nil
  end

  def self.make_patient_condion_arthritis(user_id)
    href = BASE_URL + "/Condition"
    body = make_condition_arthritis_json(user_id)
    r = FhirClient.post(href,
                      headers: CREATE_HEADERS,
                      body: body
    )
    return r.code == 201
  rescue StandardError
    nil
  end

  def self.graphable_height_info(user_id)
    get_patient_height_observations(user_id)['entry']
      .map{ |e| [DateTime.strptime(e['resource']['appliesDateTime']).to_date.to_s, e['resource']['valueQuantity']['value']] }
      .sort_by { |entry| entry[0] }
  rescue StandardError => e
    nil
  end

  def self.graphable_weight_info(user_id)
    get_patient_weight_observations(user_id)['entry']
      .map{ |e| [DateTime.strptime(e['resource']['appliesDateTime']).to_date.to_s, e['resource']['valueQuantity']['value']] }
      .sort_by { |entry| entry[0] }
  rescue StandardError => e
    nil
  end

  def self.graphable_bmi_info(user_id)
    get_patient_bmi_observations(user_id)['entry']
      .map{ |e| [DateTime.strptime(e['resource']['appliesDateTime']).to_date.to_s, e['resource']['valueQuantity']['value']] }
      .sort_by { |entry| entry[0] }
  rescue StandardError => e
    nil
  end

  def self.get_medication(id)
    href = BASE_URL + "/Medication"
    r = FhirClient.get(href,
      headers: DEFAULT_HEADERS,
      query: {'_id' => id}
    )
    return nil unless r.success?
    JSON.parse(r.body)
  rescue StandardError
    nil
  end

  # Takes in the given data and creates a user with that information. Unfortunately the API
  # does not return an id for the user it created to we will need to find a way around this.
  def self.create_user(last_name, first_name, gender, address, city, state, postal_code, birth_date)
    href = BASE_URL + "/Patient"
    r = FhirClient.post(href,
      headers: CREATE_HEADERS,
      body: user_creation_json(last_name, first_name, gender, address, city, state, postal_code, birth_date)
    )
    return r.code == 201
  rescue StandardError
    nil
  end

  # this looks up a user by their first and alst name and returns their ID
  def self.find_user_id(last_name, first_name)
    href = BASE_URL + "/Patient"
    r = FhirClient.get(href,
      headers: DEFAULT_HEADERS,
      query: {
        'family' => last_name,
        'given' => first_name,
      }
    )
    return nil unless r.success?
    JSON.parse(r.body)['entry'][0]['resource']['id']
  rescue StandardError
    nil
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
                    display:"Body mass ratio Measured"
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

  def self.make_condition_diabetes_json(patient_id)
  {
        resourceType: "Condition",
        patient: { reference: "Patient/#{patient_id}"
                 },
        code: {
            coding: [
                {
                    system: "http://snomed.info/sct",
                    code: "46635009",
                    display:"Type 1 diabetes mellitus"
                }
            ],
            text: "Type 1 diabetes mellitus, SNOMED-CT, 46635009"
        },
        clinicalStatus:"unknown",
        onsetDateTime:Time.now.strftime("%Y-%m-%dT%H:%M:%S%z"),
        notes: "Type 1 Diabetes"
    }.to_json
  end


  def self.make_condition_diabetes_t2_json(patient_id)
    {
        resourceType: "Condition",
        patient: { reference: "Patient/#{patient_id}"
        },
        code: {
            coding: [
                {
                    system: "http://snomed.info/sct",
                    code: "44054006",
                    display:"Type 2 diabetes mellitus"
                }
            ],
            text: "Type 2 diabetes mellitus, SNOMED-CT, 44054006"
        },
        clinicalStatus:"unknown",
        onsetDateTime:Time.now.strftime("%Y-%m-%dT%H:%M:%S%z"),
        notes: "Type 2 Diabetes"
    }.to_json
  end


  def self.make_condition_hypertension_json(patient_id)
    {
        resourceType: "Condition",
        patient: { reference: "Patient/#{patient_id}"
        },
        code: {
            coding: [
                {
                    system: "http://snomed.info/sct",
                    code: "38341003",
                    display:"Hypertensive disorder"
                }
            ],
            text: "Hypertensive disorder, SNOMED-CT, 38341003"
        },
        clinicalStatus:"unknown",
        onsetDateTime:Time.now.strftime("%Y-%m-%dT%H:%M:%S%z"),
        notes: "38341003"
    }.to_json
  end


  def self.make_condition_arthritis_json(patient_id)
    {
        resourceType: "Condition",
        patient: { reference: "Patient/#{patient_id}"
        },
        code: {
            coding: [
                {
                    system: "http://snomed.info/sct",
                    code: "69896004",
                    display:"Rheumatoid arthritis"
                }
            ],
            text: "Rheumatoid arthritis, SNOMED-CT, 69896004"
        },
        clinicalStatus:"unknown",
        onsetDateTime:Time.now.strftime("%Y-%m-%dT%H:%M:%S%z"),
        notes: "Rheumatoid arthritis"
    }.to_json
  end


  def self.make_condition_coronary_json(patient_id)
    {
        resourceType: "Condition",
        patient: { reference: "Patient/#{patient_id}"
        },
        code: {
            coding: [
                {
                    system: "http://snomed.info/sct",
                    code: "53741008",
                    display:"	Coronary arteriosclerosis"
                }
            ],
            text: "Coronary arteriosclerosis, SNOMED-CT, 53741008"
        },
        clinicalStatus:"unknown",
        onsetDateTime:Time.now.strftime("%Y-%m-%dT%H:%M:%S%z"),
        notes: "	Coronary arteriosclerosis"
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
  #   r = FhitClient.get(href,
  #                    headers: DEFAULT_HEADERS,
  #                    query: {'patient' => user_id, '_id' =>id}
  #   )
  #   return nil unless r.success?
  #   JSON.parse(r.body)
  # end
end
