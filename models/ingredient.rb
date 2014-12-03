class Ingredient
  attr_accessor :recipe_id, :name
  def initialize(recipe_id, name)
    @recipe_id = recipe_id
    @name = name
  end
end
