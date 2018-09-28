FactoryGirl.define do
  factory :fund_source do
    extra 'bitcoin'
    uid { Faker::Bitcoin.address }
    is_locked false
    currency 'btc'

    member { create(:member) }

    trait :aud do
      extra 'bc'
      uid '123412341234'
      currency 'aud'
    end

    factory :aud_fund_source, traits: [:aud]
    factory :btc_fund_source
  end
end

