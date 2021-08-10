FactoryBot.define do
  factory :discount do
    name { 'Thanksgiving Sale' }
    percentage { 20 }
    quantity_threshold { 10 }
  end
end
