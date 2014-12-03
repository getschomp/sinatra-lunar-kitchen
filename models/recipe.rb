require 'pry'
class Recipe
  attr_reader :results

  def initialize(name, id)
    @name = name
    @id = id
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
      SELECT name, id FROM recipes ORDER BY name LIMIT 20;
    }
    query_results = nil
    recipes_array = []

    db_connection do |conn|
      query_results = conn.exec_params(sql).to_a
    end

    query_results.each do |recipe_obj|
      recipe_obj = Recipe.new(recipe_obj["name"], recipe_obj["id"])
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

end
