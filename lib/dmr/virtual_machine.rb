module DMR
  class VirtualMachine

    def initialize(input_file)
      file = File.new(input_file, "r")
      @variables = DMR::Variables.new
      @procedimientos = []
      @cuadruplos = []      
      @ip = 1
      
      read_file_parts(file, @procedimientos, "<<")
      read_file_parts(file, @variables)
      
      while((line = file.gets) and !line.include?("---"))
        line = line.gsub("\n", "")
        var = line.split("\t")

        @variables.set_variable(var[0], var[1])
      end      

      # se agrega un arreglo vacio porque los cuadruplos empiezan en la direccion 1
      @cuadruplos << []
      read_file_parts(file, @cuadruplos, "<<")



      file.close
    end
    
    def start
      while @ip < @cuadruplos.size
        cuadruplo = @cuadruplos[@ip]
        case cuadruplo[1]
        when "+"                            
          tmp = @variables.get_variable(cuadruplo[2]) + @variables.get_variable(cuadruplo[3])
          @variables.set_variable(cuadruplo[4], tmp)
        when "-"                                    
          tmp = @variables.get_variable(cuadruplo[2]) - @variables.get_variable(cuadruplo[3])
          @variables.set_variable(cuadruplo[4], tmp)
        when "/"                                    
          tmp = @variables.get_variable(cuadruplo[2]) / @variables.get_variable(cuadruplo[3])
          @variables.set_variable(cuadruplo[4], tmp)
        when "*"                                    
          tmp = @variables.get_variable(cuadruplo[2]) * @variables.get_variable(cuadruplo[3])
          @variables.set_variable(cuadruplo[4], tmp)
        when "="
          @variables.set_variable(cuadruplo[4],@variables.get_variable(cuadruplo[2]))
        when "+A"
          tmp = @variables.get_variable(cuadruplo[2]) + cuadruplo[3].to_i
          @variables.set_variable(cuadruplo[4],tmp)
        when "<"
          tmp = @variables.get_variable(cuadruplo[2]) < @variables.get_variable(cuadruplo[3])
          @variables.set_variable(cuadruplo[4],tmp)
        when ">"
          tmp = @variables.get_variable(cuadruplo[2]) > @variables.get_variable(cuadruplo[3])
          @variables.set_variable(cuadruplo[4],tmp)
        when "<="
          tmp = @variables.get_variable(cuadruplo[2]) <= @variables.get_variable(cuadruplo[3])
          @variables.set_variable(cuadruplo[4],tmp)
        when ">="
          tmp = @variables.get_variable(cuadruplo[2]) >= @variables.get_variable(cuadruplo[3])
          @variables.set_variable(cuadruplo[4],tmp)
        when "=="
          tmp = @variables.get_variable(cuadruplo[2]) == @variables.get_variable(cuadruplo[3])
          @variables.set_variable(cuadruplo[4],tmp)
        when "or"
          tmp = @variables.get_variable(cuadruplo[2]) or @variables.get_variable(cuadruplo[3])
          @variables.set_variable(cuadruplo[4],tmp)          
        when "and"
          tmp = @variables.get_variable(cuadruplo[2]) and @variables.get_variable(cuadruplo[3])
          @variables.set_variable(cuadruplo[4],tmp)          
        when "write"
          puts @variables.get_variable(cuadruplo[4])
        when "goTo"
          @ip = cuadruplo[4].to_i - 1
        when "gotoFalso"
          @ip = (cuadruplo[4].to_i - 1) if @variables.get_variable(cuadruplo[2]) == false
        when "ver"
          if @variables.get_variable(cuadruplo[2]) >= cuadruplo[4].to_i
            puts "Dennis dice: Indice '#{@variables.get_variable(cuadruplo[2])}' fuera del rango del arreglo"
            Process.exit
          end
        end
        @ip += 1
      end
    end
    
    private
    
    # lee una parte del archivo y le manda cada linea a la 'funcion' de la 'variable'
    def read_file_parts(file, variable, funcion = nil)
      while((line = file.gets) and !line.include?("---"))
        line = line.gsub("\n", "").split("\t")
        variable.send(funcion, line) if funcion
      end
    end
    
  end
end