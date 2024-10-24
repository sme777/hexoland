class FeedController < ApplicationController
    def index
        @feed = Assembly.where(public: true)
        @current_page = params[:page]
        @page_count = (@feed.size / 5.0).ceil
        @feed = Assembly.paginate(page: @current_page, per_page: 5)
        @page_assembly_ids = @feed.map {|asm| asm.id }
    end
end
