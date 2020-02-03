class HomeController < ApplicationController
    before_action :authenticate_user!

    def index
        render json: { msg: 'Hello World' }
    end

    def profile
        user = current_user
        render_resource(user, with: [:tasks])
    end


end