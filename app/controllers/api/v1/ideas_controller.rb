module Api
  module V1
    class IdeasController < ApplicationController
      before_action :set_idea, only: [:show, :update, :destroy]
      before_action :idea_params, only: :index

      # GET /ideas
      def index
        if params.include? 'category_name'
          @category = Category.find_by(name: params[:category_name])
          if @category.nil?
            render status: 404, json: { errors: { title: 'アイデアが見つかりません', detail: 'ご指定のカテゴリー名と一致するアイデアが見つかりません' }, status: 404 }
          else
            @ideas = Idea.joins(:category).where(category_id: @category.id).select('ideas.id, name as category_name, body')
            render json: @ideas
          end
        else
          @ideas = Idea.joins(:category).select('ideas.id, name as category_name, body')
          render json: @ideas
        end
      end

      # GET /ideas/1
      def show
        render json: @idea
      end

      # POST /ideas
      def create
        @category_idea = CategoryIdea.new(idea_params)
        if @category_idea.valid?
          @category_idea.save
          render status: 201, json: { success: { title: '登録が完了しました' }, status: 201 }
        else
          render status: 422,
                 json: { errors: { title: '登録できませんでした', detail: @category_idea.errors.full_messages }, status: 422 }
        end
      end

      # PATCH/PUT /ideas/1
      def update
        if @idea.update(idea_params)
          render json: @idea
        else
          render json: @idea.errors, status: :unprocessable_entity
        end
      end

      # DELETE /ideas/1
      def destroy
        @idea.destroy
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
