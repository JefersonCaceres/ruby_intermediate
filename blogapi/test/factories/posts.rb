FactoryBot.define do
  factory :post do
    
    ###usamos Faker para crear datos falsas
    title {Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    published { 
      r = rand{0..1}
      if r==0
        false
      else
        true
      end
     }
    user 
  end
  ##otra forma de usar o configurar factory_bot
  factory :published_post, class: 'Post' do
    
    ###usamos Faker para crear datos falsas
    title {Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    ##siempre va a ser true
    published { true }
    user 
  end
end
