# Resources:

## Patient:
http://polaris.i3l.gatech.edu:8080/gt-fhir-webapp/search?serverId=gatechrealease&resource=Patient&param.0.qualifier=&param.0.0=&param.0.name=_id&param.0.type=string&sort_by=&sort_direction=&resource-search-limit=

### To Input medications:
We need the patient id from above in order to create the medication prescription for the patient.

### Medication:
Primarily used for identification and definition of Medication, but also covers ingredients and packaging.
http://polaris.i3l.gatech.edu:8080/gt-fhir-webapp/search?serverId=gatechrealease&encoding=json&resource=Medication&param.0.qualifier=&param.0.0=&param.0.name=_id&param.0.type=string&sort_by=&sort_direction=&resource-search-limit=

### Medication Dispense:
Dispensing a medication to a named patient. This includes a description of the supply provided and the instructions for administering the medication. This has a reference to Medication resource

http://polaris.i3l.gatech.edu:8080/gt-fhir-webapp/search?serverId=gatechrealease&resource=MedicationDispense&param.0.qualifier=&param.0.0=&param.0.name=_id&param.0.type=string&sort_by=&sort_direction=&resource-search-limit=

### Medication Prescription:
An order for both supply of the medication and the instructions for administration of the medicine to a patient. Medication  prescription has a reference to medication dispense.

http://polaris.i3l.gatech.edu:8080/gt-fhir-webapp/search?serverId=gatechrealease&encoding=json&resource=MedicationPrescription&param.0.qualifier=&param.0.0=&param.0.name=_id&param.0.type=string&sort_by=&sort_direction=&resource-search-limit=

### Condition:
Use to record detailed information about conditions, problems or diagnoses recognized by a clinician. There are many uses including: recording a Diagnosis during an Encounter; populating a problem List or a Summary Statement, such as a Discharge Summary.
http://polaris.i3l.gatech.edu:8080/gt-fhir-webapp/search?serverId=gatechrealease&encoding=json&resource=Condition&param.0.qualifier=&param.0.0=&param.0.name=_id&param.0.type=string&sort_by=&sort_direction=&resource-search-limit=

### Observation:
Measurements and simple assertions made about a patient, device or other subject.
http://polaris.i3l.gatech.edu:8080/gt-fhir-webapp/read?serverId=gatechrealease&resource=Observation&action=read&id=1&vid=

We need to add observations for body height, weight, blood pressure, oxygen, temperature etc and use these to calculate Framingham score, BMI.

### Deletion:
Be aware that when trying to delete a resource which is related to another resource a error will occur - for instance, trying to delete a Patient who has Observations, Conditions, etc., related to them. In such a case these related resources must be deleted before the patient can be deleted.
