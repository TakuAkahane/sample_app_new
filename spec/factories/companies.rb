# frozen_string_literal: true

FactoryBot.define do
  factory :company, class: Company do
    ward_id { 'shinjuku' }
    address { 'Nishishinjuku 1-26-2' }
    name { 'Nomura Real Estate' }
    tel { '0333488811' }
    public { 'public' }
    establishment { 1957 }
    description { 'Nomura Real Estate is one of the leading major real estate companies in Japan. A comprehensive real estate company that sells and leases real estate.' }
    deleted { 0 }
    company_size_id { 'less_than_thousand' }
    created_at { Time.now }
    updated_at { Time.now }
  end
end
