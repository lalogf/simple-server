def common_names
  {
    'english' =>
      { 'female'      => %w[Anjali Divya Ishita Priya Priyanka Riya Shreya Tanvi Tanya Vani].take(3).take(3),
        'male'        => %w[Abhishek Aditya Amit Ankit Deepak Mahesh Rahul Rohit Shyam Yash].take(3),
        'transgender' => %w[Bharathi Madhu Bharathi Manabi Anjum Vani Riya Shreya Kiran Amit].take(3),
        'last_name'   => %w[Lamba Bahl Sodhi Sardana Puri Chhabra Khanna Malhotra Mehra Garewal Dhillon].take(3)
      },

    'punjabi' =>
      {
        'female'      => %w[ਅੰਜਲੀ ਦਿਵਿਆ ਇਸ਼ਿਤਾ ਪ੍ਰਿਆ ਪ੍ਰਿਯੰਕਾ ਰਿਯਾ ਸ਼੍ਰੇਯਾ ਟਾਂਵੀ ਤੰਯਾ ਵਨੀ].take(3),
        'male'        => %w[ਅਭਿਸ਼ੇਕ ਆਦਿਤਿਆ ਅਮਿਤ ਅੰਕਿਤ ਦੀਪਕ ਮਹੇਸ਼ ਰਾਹੁਲ ਰੋਹਿਤ ਸ਼ਿਆਮ ਯਸ਼ ].take(3),
        'transgender' => %w[ਭਰਾਠੀ ਮਧੂ ਮਾਨਬੀ ਅੰਜੁਮ ਵਨੀ ਰਿਯਾ ਸ਼੍ਰੇਯਾ ਕਿਰਨ ਅਮਿਤ].take(3),
        'last_name'   => %w[ਲੰਬਾ ਬਹਿਲ ਸੋਢੀ ਸਰਦਾਨਾ ਪੂਰੀ ਛਾਬੜਾ ਖੰਨਾ ਮਲਹੋਤਰਾ ਮੇਹਰ ਗਰੇਵਾਲ ਢਿੱਲੋਂ].take(3)
      }
  }
end

def common_addresses
  {
    'bathinda' => {
      'english' => {
        street_name:       ['Bhagat singh colony', 'Gandhi Basti', 'NFL Colony', 'Farid Nagari'],
        village_or_colony: %w[Bathinda Bhagwangarh Dannewala Nandgarh Nathana],
      },
      'punjabi' => {
        street_name:       ['ਭਗਤ ਸਿੰਘ ਕਾਲੋਨੀ', 'ਗਾਂਧੀ ਬਸਤੀ', 'ਨਫ਼ਲ ਕਾਲੋਨੀ', 'ਫਰੀਦ ਨਗਰੀ'],
        village_or_colony: %w[ਬਠਿੰਡਾ ਭਗਵੰਗੜ੍ਹ ਡੰਨਵਾਲਾ ਨੰਦਗੜ੍ਹ ਨਥਾਣਾ],
      }
    },
    'mansa'    => {
      'english' => {
        street_name:       ['Bathinda Road', 'Bus Stand Rd', 'Hirke Road', 'Makhewala Jhanduke Road'],
        village_or_colony: ['Bhikhi', 'Budhlada', 'Hirke', 'Jhanduke', 'Mansa', 'Bareta', 'Bhaini Bagha', 'Sadulgarh', 'Sardulewala']
      },
      'punjabi' => {
        street_name:       ['ਬਠਿੰਡਾ ਰੋਡ', 'ਬੱਸ ਸਟੈਂਡ ਰੱਦ', 'ਹੀਰਕੇ ਰੋਡ', 'ਮਖੇਵਾਲਾ ਝੰਡੂਕੇ ਰੋਡ'],
        village_or_colony: ['ਭੀਖੀ', 'ਬੁਢਲਾਡਾ', 'ਹੀਰਕੇ', 'ਝੰਡੂਕੇ', 'ਮਾਨਸਾ', 'ਬਰੇਟਾ', 'ਭੈਣੀ ਬਾਘਾ', 'ਸਾਦੁਲਗੜ੍ਹ', 'ਸਰਦੁਲੇਵਾਲਾ']
      }
    }
  }
end

def random_date(from = 0.0, to = Time.now)
  Time.at(from + rand * (to.to_f - from.to_f))
end

def generate_phone_number
  digits       = (0..9).to_a
  phone_number = ''
  10.times do
    phone_number += digits.sample.to_s
  end
  phone_number
end

def create_random_patient_phone_number(patient_id)
  patient_phone_number = {
    id:                SecureRandom.uuid,
    number:            generate_phone_number,
    phone_type:        PatientPhoneNumber::PHONE_TYPE.sample,
    active:            true,
    patient_id:        patient_id,
    device_created_at: Time.now,
    device_updated_at: Time.now
  }
  PatientPhoneNumber.create(patient_phone_number)
end

def create_random_address(district, language)
  addresses = common_addresses[district][language]
  address   = {
    id:                SecureRandom.uuid,
    street_address:    "# #{rand(100)}, #{addresses[:street_name].sample}",
    village_or_colony: addresses[:village_or_colony].sample,
    district:          district,
    state:             language == 'punjabi' ? 'ਪੰਜਾਬ' : 'Punjab',
    country:           language == 'punjabi' ? 'ਇੰਡੀਆ' : 'India',
    pin:               district == 'bathinda' ? "1510#{rand(100)}" : "1515#{rand(100)}",
    device_created_at: Time.now,
    device_updated_at: Time.now
  }
  Address.create(address)
end

def create_random_patient(address_id, language)
  has_age   = [true, false].sample
  gender    = Patient::GENDERS.sample
  full_name = "#{common_names[language][gender].sample} #{common_names[language]['last_name'].sample}"
  patient   = {
    id:                SecureRandom.uuid,
    gender:            gender,
    full_name:         full_name,
    status:            'active',
    age:               has_age ? rand(18..100) : nil,
    age_updated_at:    has_age ? Time.now : nil,
    address_id:        address_id,
    date_of_birth:     !has_age ? random_date : nil,
    device_created_at: Time.now,
    device_updated_at: Time.now,
    test_data:         true
  }

  Patient.create(patient)
end

namespace :generate do
  desc 'Generate test patients for user tests'
  # Example: rake "generate:random_patients_for_user_tests[20]"
  task :random_patients_for_user_tests, [:number_of_patients_to_generate] => :environment do |_t, args|
    max_patient_phone_numbers      = 1
    number_of_patients_to_generate = args.number_of_patients_to_generate.to_i

    number_of_patients_to_generate.times do
      district = common_addresses.keys.sample
      language = common_addresses[district].keys.sample
      address  = create_random_address(district, language)
      patient  = create_random_patient(address.id, language)
      rand(1..max_patient_phone_numbers).times do
        create_random_patient_phone_number(patient.id)
      end
    end
  end

  task :patients_for_user_tests => :environment do
    test_patient_data = [
      { full_name: "Govind Lamba", age: 57, language: 'english' },
      { full_name: "Govind Lamba", age: 41, language: 'english' },
      { full_name: "Govind Lamba", age: 79, language: 'english' },
      { full_name: "Govind Lamba", age: 33, language: 'english' },
      { full_name: "Govind Lamba", age: 30, language: 'english' },
      { full_name: "Govind Bahl", age: 51, language: 'english' },
      { full_name: "Govind Bahl", age: 48, language: 'english' },
      { full_name: "Govind Bahl", age: 21, language: 'english' },
      { full_name: "Govind Bahl", age: 54, language: 'english' },
      { full_name: "Govind Bahl", age: 77, language: 'english' },
      { full_name: "Govind Sodhi", age: 89, language: 'english' },
      { full_name: "Govind Sodhi", age: 36, language: 'english' },
      { full_name: "Govind Sodhi", age: 82, language: 'english' },
      { full_name: "Govind Sodhi", age: 64, language: 'english' },
      { full_name: "Govind Sodhi", age: 79, language: 'english' },
      { full_name: "Harjeet Lamba", age: 54, language: 'english' },
      { full_name: "Harjeet Lamba", age: 67, language: 'english' },
      { full_name: "Harjeet Lamba", age: 40, language: 'english' },
      { full_name: "Harjeet Lamba", age: 29, language: 'english' },
      { full_name: "Harjeet Lamba", age: 67, language: 'english' },
      { full_name: "Harjeet Bahl", age: 66, language: 'english' },
      { full_name: "Harjeet Bahl", age: 22, language: 'english' },
      { full_name: "Harjeet Bahl", age: 37, language: 'english' },
      { full_name: "Harjeet Bahl", age: 52, language: 'english' },
      { full_name: "Harjeet Bahl", age: 31, language: 'english' },
      { full_name: "Harjeet Sodhi", age: 30, language: 'english' },
      { full_name: "Harjeet Sodhi", age: 44, language: 'english' },
      { full_name: "Harjeet Sodhi", age: 68, language: 'english' },
      { full_name: "Harjeet Sodhi", age: 51, language: 'english' },
      { full_name: "Harjeet Sodhi", age: 55, language: 'english' },
      { full_name: "ਗੋਵਿੰਦ ਲੰਬਾ", age: 83, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਲੰਬਾ", age: 52, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਲੰਬਾ", age: 69, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਲੰਬਾ", age: 24, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਲੰਬਾ", age: 44, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਬਹਿਲ", age: 84, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਬਹਿਲ", age: 76, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਬਹਿਲ", age: 85, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਬਹਿਲ", age: 39, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਬਹਿਲ", age: 81, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਸੋਢੀ", age: 22, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਸੋਢੀ", age: 90, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਸੋਢੀ", age: 44, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਸੋਢੀ", age: 22, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਸੋਢੀ", age: 23, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਲੰਬਾ", age: 38, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਲੰਬਾ", age: 30, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਲੰਬਾ", age: 43, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਲੰਬਾ", age: 42, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਲੰਬਾ", age: 90, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਬਹਿਲ", age: 56, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਬਹਿਲ", age: 34, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਬਹਿਲ", age: 31, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਬਹਿਲ", age: 69, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਬਹਿਲ", age: 57, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਸੋਢੀ", age: 30, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਸੋਢੀ", age: 81, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਸੋਢੀ", age: 29, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਸੋਢੀ", age: 66, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਸੋਢੀ", age: 57, language: 'punjabi' }
    ]

    test_patient_data.each do |patient_data|
      patient = Patient.create(
        id:                SecureRandom.uuid,
        full_name:         patient_data[:full_name],
        age:               patient_data[:age],
        gender:            'male',
        status:            'active',
        age_updated_at:    Time.now,
        address_id:        create_random_address('bathinda', patient_data[:language]).id,
        date_of_birth:     nil,
        device_created_at: Time.now,
        device_updated_at: Time.now,
        test_data:         true)
      create_random_patient_phone_number(patient.id)
    end
  end
end
