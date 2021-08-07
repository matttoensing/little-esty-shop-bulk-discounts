FactoryBot.define do
  factory :discount do
    percentage { 20 }
    quantity_threshold { 10 }
  end
end
