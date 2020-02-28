require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade
  attr_reader :id 

  def initialize (id = nil, name ,grade)
      @name = name 
      @grade = grade
      @id = id
  end 


  def self.create_table
      sql = <<-SQL 
      create table if not exists students(
        id INTEGER PRIMARY KEY,
        name TEXT ,
        grade INTEGER
      )
      SQL
      DB[:conn].execute(sql)
  end

  def self.drop_table 
      sql = "DROP TABLE students"
      DB[:conn].execute(sql)
  end 


  def save 
   if self.id
    self.update 
   end
   
    sql = <<-SQL 
        insert into  students(name, grade)
        values ( ? , ? )
        
        SQL
        DB[:conn].execute(sql, self.name, self.grade)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    
    end 

    def self.create(name, grade )
        student = self.new(name, grade )
        student.save
        student 

    end

    def self.new_from_db(value)
        student = self.new(value[0], value[1], value[2])
        student.save 
        student
    end 

    def self.find_by_name(name)  
      sql = "SELECT * FROM students WHERE name = ?"
      result = DB[:conn].execute(sql, name)[0]
      Student.new(result[0], result[1], result[2])
        
    end 

    def update
     
        sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
        DB[:conn].execute(sql, self.name, self.grade, self.id)
     
    end 



end
