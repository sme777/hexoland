class StudioController < ApplicationController
    def index
        
    end

    def create
        assembly = Assembly.new(user_params)
        if assembly.save
            flash[:success] = "Successfully designed assembly #{assembly[:name]}"
        else
            flash[:danger] = assembly.errors.full_messages
        end
        redirect_to '/studio'
    end

    private
    def assembly_params
        params.require(:assembly).permit(:author, :name, :design_map, :volumes, :wells)
    end
end
