require 'json'
require 'csv'
require 'will_paginate/array'

class StudioController < ApplicationController
    before_action :init_params, only: [:index, :create, :get_picklist]
    before_action :set_assembly, only: [:delete, :update, :get_picklist, :get_json, :make_private, :make_public]

    def index
        @assembly_method = "Forward"
        @current_page = 1
        @page_count = (Assembly.all.size.to_f / 3).ceil
        @assemblies = Assembly.order(updated_at: :desc).paginate(page: @current_page, per_page: 3)
        @page_assembly_ids = @assemblies.map {|asm| asm.id }
    end

    def paginate_assemblies
        @current_page = params[:page].to_i
        @assemblies = Assembly.paginate(page: @current_page, per_page: 3)
        @page_count = (Assembly.all.size.to_f / 3).ceil
        @page_assembly_ids = @assemblies.map {|asm| asm.id }
        render partial: "studio/page_assemblies"
    end

    # def code
    #     @assembly_method = "Code"
    #     render partial: "studio/code"
    # end

    # def model
    #     @assembly_method = "Voxelizer"
    #     render partial: "studio/model"
    # end

    # def gui
    #     @assembly_method = "GUI"
    #     render partial: "studio/gui"
    # end

    def forward
        @assembly_method = "Forward"
        render partial: "studio/forward"
    end

    def reverse
        @assembly_method = "Reverse"
        render partial: "studio/reverse"
    end

    def load_sequence(file)
        br = BondRecoverer.new
        recovery_map = br.recover(file)
        render json: recovery_map
    end

    def load_hexland(file)
        file_content = File.read(file)
        render json: file_content
    end

    def load_obj(file)

    end

    def loader
        if params[:fileType] == "csv"
            load_sequence(params[:file])
        elsif params[:fileType] == "json"
            load_hexland(params[:file])
        elsif params[:fileType] == "obj"
            load_obj(params[:file])
        end
    end

    def create
        assembly = Assembly.new(assembly_params)
        
        begin
            bond_map, messages = @bond_generator.configure_blocks(JSON.parse(assembly_params[:design_map]))
            assembly[:design_map] = bond_map.to_json
            assembly[:assembly_map] = assembly.compute_neighbors
            if assembly.save
                flash[:success] = ["Successfully designed assembly #{assembly[:name]}"] + messages.flatten
            else
                flash[:danger] = assembly.errors.full_messages
            end
        rescue => e
            flash[:danger] = "An error was encountered while trying to parse assembly code, please double-check!"
        end
        redirect_to '/studio'
    end

    def get_picklist
        final_volume = params[:final_volume]
        wells = params[:wells].gsub(" ", "").split(",")
        scaffold_start_concetration = params[:scaffold_start_concetration]
        scaffold_final_concetration = params[:scaffold_final_concetration]
        staple_ratio = params[:staple_ratio]
        staple_concetration = params[:staple_concetration]
        
        
        add_buffer = !!params[:add_buffer]
        add_scaffold = !!params[:add_scaffold]

        picklist = @picklist_generator.generate_picklist(JSON.parse(@assembly.design_map), 
                            final_volume, scaffold_start_concetration, staple_ratio,
                            scaffold_final_concetration, staple_concetration, wells,
                            add_buffer, add_scaffold)
        temp_file = Tempfile.new(["#{@assembly.name}_picklist.csv", '.csv'])
        
        CSV.open(temp_file.path, 'w') do |csv|
            csv << picklist.vectors.to_a
            picklist.each_row do |row|
                csv << row
            end
        end

        send_file(Rails.root.join("#{temp_file.path}"), type: 'text/csv', 
            filename: "#{@assembly.name}_picklist.csv", disposition: 'attachment')
    end

    def get_json
        temp_file = Tempfile.new(["#{@assembly.name}_design_map.json", '.json'])
        # Write the JSON data to the temporary file
        temp_file.write(@assembly.design_map)
        temp_file.rewind  # Rewind the file to the beginning
    
        # Send the file for download
        send_file(Rails.root.join("#{temp_file.path}"), type: 'application/json', 
            filename: "#{@assembly.name}_design_map.json", :disposition => 'attachment')
    end

    def update
        flash[:danger], flash[:success] = [], []
        did_merge = false
        if !(params[:merge_assembly] == "" ||  params[:merge_assembly].nil?)
            @merge_assembly = Assembly.find_by(id: params[:merge_assembly].to_i)
            change_count, merged_design_map = @assembly.merge_with(@merge_assembly)
            flash[:danger] << "Nothing was changed, please make sure that the naming match across Merges!" if change_count == 0
            @assembly.update_column(:design_map, merged_design_map)
            did_merge = true
        end

        @assembly.update_column(:name, params[:name])
        @assembly.update_column(:description, params[:description])
        @assembly.update_column(:public, params[:assembly_public_check] == "1" ? true : false)
        if params[:design_map] != ""
            if did_merge
                flash[:danger] << "Cannot update design map when performing a merge operation!"
            else
                @assembly.update_column(:design_map, params[:design_map])
            end
        end
        flash[:success] << "Successfully updated Assembly #{@assembly.name} with id #{@assembly.id}"
        redirect_to "/inspector/#{@assembly.id}"
    end

    def delete
        if @assembly.delete
            flash[:success] = "Successfully deleted assembly ##{@assembly.name}"
        else
            flash[:danger] = "Unable to delete bot due to the following errors: \n #{@assembly.errors.full_messages}"
        end
        redirect_to '/studio'
    end

    def make_private
        @assembly.update_column(:public, false)
        redirect_to '/studio'
    end

    def make_public
        @assembly.update_column(:public, true)
        redirect_to '/studio'
    end

    private
    def assembly_params
        params.require(:assembly).permit(:author, :name, :description, :visibility, :design_map)
    end


    def init_params
        @bond_generator = BondGenerator.new
        @picklist_generator = PicklistGenerator.new
    end

    def set_assembly
        @assembly = Assembly.find_by(id: params[:id])
    end
end
