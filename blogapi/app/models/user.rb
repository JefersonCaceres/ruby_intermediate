class User < ApplicationRecord
    has_many :posts
    validates :email, presence:true
    validates :name, presence:true
    validates :auth_token, presence: true

    after_initialize :generate_auth_token
    ##genera un token
    def generate_auth_token
        ##contrario al if = if!
        unless auth_token.present?
            self.auth_token = TokenGenerateService.generate
        end
    end
end
