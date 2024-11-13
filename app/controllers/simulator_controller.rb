class SimulatorController < ApplicationController
    def index
        @assembly = Assembly.all.first
    end
end
