require 'json'

class InspectorController < ApplicationController
    def index
        # @assembly = Assembly.find_by(name: "3x5Z-10H-ZigZag")
        # @assembly_map = @assembly[:assembly_map].to_json
        # @bond_map = @assembly.normalize_bonds.to_json 
    end

    def inspect
      @assembly = Assembly.find_by(id: params[:id])

    end

    private
    def inspect_params
      params.require(:inspector).permit(:id)
    end
end
