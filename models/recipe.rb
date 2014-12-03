require 'pry'
class Recipe
  attr_reader :results

  def initialize
    @results = []
  end

  def self.all
    sql = %{
      SELECT name, id FROM recipes ORDER BY name LIMIT 20;
    }

    begin
      connection = PG.connect(dbname: 'recipes')
      @results = connection.exec_params(sql).to_a
    ensure
      connection.close
    end
  end
  binding.pry
  def self.id
    @results[:id]
  end
end
