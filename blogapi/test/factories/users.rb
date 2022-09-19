FactoryBot.define do
  factory :user do
    ###usamos Faker para crear datos falsas
    email { Faker::Internet.email }
    name {Faker::Name.name }
    auth_token { "xxxxx" }
  end
end
