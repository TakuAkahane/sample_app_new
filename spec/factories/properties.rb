# frozen_string_literal: true

FactoryBot.define do
  factory :property, class: Property do
    property_name { '広尾ガーデンヒルズH棟' }
    # area_id { ['Shibuya'] }
    address { '東京都渋谷区広尾4-1' }
    price { 100_000_000 }
    layout { ['3ldk'] }
    exclusive_area_size { 72 }
    floore_level { 4 }
    completion_date { '1998-09-04' }
    property_type { ['unit_apartment'] }
    balcony_size { 15 }
    balcony_direction { ['west'] }
    total_number_of_houses { 45 }
    rights_concening_land { 'ownership' }
    management_company { '野村不動産' }
    management_fee { 45_000 }
    repair_reserve_fund { 50_000 }
    handover_date { '2019-09-20' }
    transportation { 'yamanote' }
    created_at { Time.now }
    updated_at { Time.now }
  end

  factory :property_2, class: Property do
    property_name { '六本木ヒルズレジデンスB棟' }
    # area_id { ['minato'] }
    address { '東京都港区六本木6丁目12-1～3' }
    price { 300_000_000 }
    layout { ['5ldk'] }
    exclusive_area_size { 145 }
    floore_level { 24 }
    completion_date { '1991-09-04' }
    property_type { ['unit_apartment'] }
    balcony_size { 35 }
    balcony_direction { ['east'] }
    total_number_of_houses { 110 }
    rights_concening_land { 'ownership' }
    management_company { '東急不動産' }
    management_fee { 100_000 }
    repair_reserve_fund { 150_000 }
    handover_date { '2019-11-30' }
    transportation { 'yamanote' }
    created_at { Time.now }
    updated_at { Time.now }
  end
end
