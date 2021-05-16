module Api
  module V1
    class IdeasController < ApplicationController
    before_action :set_idea, only: [:show, :update, :destroy]

    # GET /ideas
    def index
      if params.include? "category_name"
        @category = Category.find_by(name: params[:category_name])
        if @category == nil
          render status: 404, json: { status: 404 }
        else
          @ideas = Idea.joins(:category).where(category_id: @category.id).select('ideas.id, name as category_name, body')
          render json: @ideas
        end
      else
        @ideas = Idea.joins(:category).select('ideas.id, name as category_name, body')
        render json: @ideas
      end
    end

    # POST /ideas
    def create
      @category_idea = CategoryIdea.new(idea_params)
      if @category_idea.valid?
        @category_idea.save
        render status: 201, json: { status: 201 }
      else
        render status: 422, json: { status: 422 }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_idea
        @idea = Idea.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def idea_params
        params.permit(:category_name, :body)
      end
    end
  end
end