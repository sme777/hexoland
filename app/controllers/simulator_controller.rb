class SimulatorController < ApplicationController
    def index
        @assembly = Assembly.find_by(name: "2x7M")
    end
end
