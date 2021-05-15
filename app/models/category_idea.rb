class CategoryIdea
  include ActiveModel::Model
  attr_accessor :body, :category_name

  with_options presence: true do
    validates :body
    validates :category_name
  end

  def save
    ActiveRecord::Base.transaction do
      category = Category.find_or_create_by!(name: category_name)
      idea = Idea.new(body: body, category_id: category.id)
      idea.save!
    end

  end
end