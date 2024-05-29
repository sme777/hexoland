require 'json'
require 'csv'
require 'will_paginate/array'

class StudioController < ApplicationController
    before_action :init_params, only: [:create, :get_picklist]
    before_action :set_assembly, only: [:delete, :get_picklist]

    def index
        @assembly_method = "Code"
        @current_page = 1
        @page_count = (Assembly.all.size.to_f / 3).ceil
        @assemblies = Assembly.paginate(page: @current_page, per_page: 3)
        @page_assembly_ids = @assemblies.map {|asm| asm.id }
    end

    def paginate_assemblies
        @current_page = params[:page].to_i
        @assemblies = Assembly.paginate(page: @current_page, per_page: 3)
        @page_count = (Assembly.all.size.to_f / 3).ceil
        @page_assembly_ids = @assemblies.map {|asm| asm.id }
        render partial: "studio/page_assemblies"
    end

    def code
        @assembly_method = "Code"
        render partial: "studio/code"
    end

    def model
        @assembly_method = "Voxelizer"
        render partial: "studio/model"
    end

    def gui
        @assembly_method = "GUI"
        render partial: "studio/gui"
    end

    def create
        assembly = Assembly.new(assembly_params)
        
        # begin
            bond_map = @bond_generator.build_from_neighbors(JSON.parse(assembly_params[:design_map]))
            assembly[:design_map] = bond_map.to_json

            if assembly.save
                flash[:success] = "Successfully designed assembly #{assembly[:name]}"
            else
                flash[:danger] = assembly.errors.full_messages
            end
        # rescue => e
        #     flash[:danger] = "An error was encountered while trying to parse assembly code, please double-check!"
        # end

        redirect_to '/studio'
    end

    def get_picklist
        volumes = params[:volumes].gsub(" ", "").split(",")
        wells = params[:wells].gsub(" ", "").split(",")
        picklist = @picklist_generator.generate_picklist(JSON.parse(@assembly.design_map), volumes, wells)
        temp_file = Tempfile.new(["#{@assembly.name}_picklist.csv", '.csv'])
        
        CSV.open(temp_file.path, 'w') do |csv|
            csv << picklist.vectors.to_a
            picklist.each_row do |row|
                csv << row
            end
        end

        send_file(Rails.root.join("#{temp_file.path}"), :type => 'text/csv', 
            :filename => "#{@assembly.name}_picklist.csv", :disposition => 'attachment')
    end

    def delete
        if @assembly.delete
            flash[:success] = "Successfully deleted assembly ##{@assembly.name}"
        else
            flash[:danger] = "Unable to delete bot due to the following errors: \n #{@assembly.errors.full_messages}"
        end
        redirect_to '/studio'
    end

    private
    def assembly_params
        params.require(:assembly).permit(:author, :name, :design_map, :volumes, :wells)
    end


    def init_params
        @bond_generator = BondGenerator.new
        @picklist_generator = PicklistGenerator.new
    end

    def set_assembly
        @assembly = Assembly.find_by(id: params[:id])
    end
end
