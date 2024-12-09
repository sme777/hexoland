class UserController < ApplicationController

    def index

    end

    def create
        auth_hash = request.env['omniauth.auth']
        user = User.find_or_create_by(provider: auth_hash['provider'], id: auth_hash['uid']) do |u|
        u.name = auth_hash['info']['name']
        u.username = auth_hash['info']['nickname']
        u.image_url = auth_hash['info']['image']
        end

        session[:user_id] = user.id
        redirect_to studio_path, notice: "Signed in as #{user.name}"
    end

    def sign_out
        session[:user_id] = nil
        redirect_to studio_path, notice: "Successfully signed out!"
    end

end
