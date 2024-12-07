class FeedController < ApplicationController
    def index
        @feed = Assembly.where(public: true)
        @feed_current_page = params[:feed_page]
        @feed_page_count = (@feed.size / 5.0).ceil
        @feed = Assembly.where(public: true).paginate(page: @feed_current_page, per_page: 5)
        
        @feed_assembly_ids = @feed.map {|asm| asm.id }
        
        @popular_assemblies = Assembly.where(public: true)
        @popular_assemblies_current_page = params[:popular_page]
        @popular_assemblies_page_count = (@popular_assemblies.size / 5.0).ceil
        @popular_assemblies = Assembly.where(public: true).paginate(page: @popular_assemblies_current_page, per_page: 5)

        @popular_assembly_ids = @popular_assemblies.map {|asm| asm.id }

        @experimental_assemblies = Assembly.where(public: false)
        @experimental_assemblies_current_page = params[:experimental_page]
        @experimental_assemblies_page_count = (@experimental_assemblies.size / 5.0).ceil
        @experimental_assemblies = Assembly.where(public: true).paginate(page: @experimental_assemblies_current_page, per_page: 5)

        @experimental_assembly_ids = @experimental_assemblies.map {|asm| asm.id }
    end
end
