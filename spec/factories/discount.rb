FactoryBot.define do
  factory :discount do
    percentage { 10 }
    quantity_threshold { 10 }
  end
end
