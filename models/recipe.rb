class Recipe
  attr_reader :results
  
  def initialize
    @results = []
  end

  def db_connection
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

    db_connection do |conn|
      @results = conn.exec_params(sql)
    end
  end
end
