def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')

    yield(connection)

  ensure
    connection.close
  end
end

class Recipe
  attr_reader :id, :name, :instructions, :description

  def initialize(name, id, description, instructions)
    @name = name
    @id = id
    @description = description
    @instructions = instructions
  end

  def self.all
    query_results = nil
    recipes_array = []

    db_connection do |conn|
      query_results = conn.exec_params(%{
        SELECT name, id, description, instructions FROM recipes ORDER BY name LIMIT 20;
        }).to_a
    end

    query_results.each do |recipe_obj|
      recipe_obj = Recipe.new(recipe_obj["name"], recipe_obj["id"], recipe_obj["description"], recipe_obj["instructions"])
      recipes_array << recipe_obj
    end

    recipes_array
  end

  def self.find(id)
    @id = id
    recipe = nil

    db_connection do |conn|
      recipe = conn.exec_params(%{
        SELECT name, id, description, instructions FROM recipes WHERE id = #{id};
        }).to_a
    end

    Recipe.new(recipe[0]["name"], recipe[0]["id"], recipe[0]["description"], recipe[0]["instructions"])
  end

  def ingredients
    result = nil
    @ingredients_array = []

    db_connection do |conn|
      result = conn.exec(%{
        SELECT ingredients.name, ingredients.recipe_id FROM ingredients
        JOIN recipes ON recipes.id = ingredients.recipe_id
        WHERE ingredients.recipe_id = #{@id}
        ORDER BY name;
      })
    end

    result.each do |ingredient|
      ingredient = Ingredient.new(ingredient["recipe_id"], ingredient["name"])
      @ingredients_array << ingredient
    end

    @ingredients_array
  end
end
