class FeedController < ApplicationController
    def index
        @feed = Assembly.where(public: true)
        @feed_current_page = params[:feed_page]
        @feed_page_count = (@feed.size / 5.0).ceil
        @feed = Assembly.where(public: true).paginate(page: @feed_current_page, per_page: 5)
        
        @page_assembly_ids = @feed.map {|asm| asm.id }
        
        @popular_assemblies = Assembly.where(public: nil)
        @popular_assemblies_current_page = params[:popular_page]
        @popular_assemblies_page_count = (@popular_assemblies.size / 5.0).ceil
        @popular_assemblies = Assembly.where(public: nil).paginate(page: @popular_assemblies_current_page, per_page: 5)

        @experimental_assemblies = Assembly.where(public: nil)
        @experimental_assemblies_current_page = params[:experimental_page]
        @experimental_assemblies_page_count = (@experimental_assemblies.size / 5.0).ceil
        @experimental_assemblies = Assembly.where(public: nil).paginate(page: @experimental_assemblies_current_page, per_page: 5)

    end
end
