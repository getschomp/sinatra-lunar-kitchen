require 'pry'
class Recipe
  attr_reader :results

  def initialize(name, id, description, instructions)
    @name = name
    @id = id
    @description = description
    @instructions = instructions
  end

  def self.db_connection
    begin
      connection = PG.connect(dbname: 'recipes')

      yield(connection)

    ensure
      connection.close
    end
  end

  def self.all
    sql = %{
      SELECT name, id, description, instructions, FROM recipes ORDER BY name LIMIT 20;
    }
    query_results = nil
    recipes_array = []

    db_connection do |conn|
      query_results = conn.exec_params(sql).to_a
    end

    query_results.each do |recipe_obj|
      recipe_obj = Recipe.new(recipe_obj["name"], recipe_obj["id"], recipe_obj["description"], recipe_obj["instructions"])
      recipes_array << recipe_obj
    end
    recipes_array
  end

  def id
    @id
  end

  def name
    @name
  end

  def description
    @description
  end

  def instructions
    @instructions
  end

  def self.find(id)
    sql = %{
      SELECT name, id, description, instructions FROM recipes WHERE id = #{id};
    }
    recipe = nil

    db_connection do |conn|
      recipe = conn.exec_params(sql).to_a
    end
    recipe = Recipe.new(recipe[0]["name"], recipe[0]["id"], recipe[0]["description"], recipe[0]["instructions"])
  end

end
