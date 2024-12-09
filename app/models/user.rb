class User < ApplicationRecord
    def self.find_or_create_from_auth(auth)
        where(provider: auth.provider, id: auth.uid).first_or_create do |user|
          user.provider = auth.provider
          user.id = auth.uid
          user.username = auth.info.nickname
          user.email = auth.info.email || ""
        end
    end

    def create_with_github

    end

    def create_with_x

    end
end
