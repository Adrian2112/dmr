module DMR
  class VirtualMachine

    def initialize(input_file)
      file = File.new(input_file, "r")
      @variables = DMR::Variables.new
      @procedimientos = {}
      @cuadruplos = []      
      @ip = 1
      @pointer_regex = /\A\(\d*\)/
      
      read_procedimientos(file)
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
        cuadruplo = @cuadruplos[@ip].clone

        # cambia las direcciones con parentesis por la direccion que esta dentro de esta direccion
        if cuadruplo[2] =~ @pointer_regex
          cuadruplo[2] = @variables.get_variable(cuadruplo[2].gsub(/\(|\)/, ""))
        end
        if cuadruplo[4] =~ @pointer_regex
          cuadruplo[4] = @variables.get_variable(cuadruplo[4].gsub(/\(|\)/, ""))
        end
        
        case cuadruplo[1]
        when "+"                            
          tmp = (@variables.get_variable(cuadruplo[2]) + @variables.get_variable(cuadruplo[3]))
          @variables.set_variable(cuadruplo[4], tmp)
        when "-"                                    
          tmp = (@variables.get_variable(cuadruplo[2]) - @variables.get_variable(cuadruplo[3]))
          @variables.set_variable(cuadruplo[4], tmp)
        when "/"                                    
          tmp = (@variables.get_variable(cuadruplo[2]) / @variables.get_variable(cuadruplo[3]))
          @variables.set_variable(cuadruplo[4], tmp)
        when "*"                                    
          tmp = (@variables.get_variable(cuadruplo[2]) * @variables.get_variable(cuadruplo[3]))
          @variables.set_variable(cuadruplo[4], tmp)
        when "="
          @variables.set_variable(cuadruplo[4],@variables.get_variable(cuadruplo[2]))
        when "+A"
          tmp = (@variables.get_variable(cuadruplo[2]) + cuadruplo[3].to_i)
          @variables.set_variable(cuadruplo[4],tmp)
        when "<"
          tmp = (@variables.get_variable(cuadruplo[2]) < @variables.get_variable(cuadruplo[3]))
          @variables.set_variable(cuadruplo[4],tmp)
        when ">"
          tmp = (@variables.get_variable(cuadruplo[2]) > @variables.get_variable(cuadruplo[3]))
          @variables.set_variable(cuadruplo[4],tmp)
        when "<="
          tmp = (@variables.get_variable(cuadruplo[2]) <= @variables.get_variable(cuadruplo[3]))
          @variables.set_variable(cuadruplo[4],tmp)
        when ">="
          tmp = (@variables.get_variable(cuadruplo[2]) >= @variables.get_variable(cuadruplo[3]))
          @variables.set_variable(cuadruplo[4],tmp)
        when "=="
          tmp = (@variables.get_variable(cuadruplo[2]) == @variables.get_variable(cuadruplo[3]))
          @variables.set_variable(cuadruplo[4],tmp)
        when "or"
          tmp = (@variables.get_variable(cuadruplo[2]) or @variables.get_variable(cuadruplo[3]))
          @variables.set_variable(cuadruplo[4],tmp)          
        when "and"
          tmp = (@variables.get_variable(cuadruplo[2]) and @variables.get_variable(cuadruplo[3]))
          @variables.set_variable(cuadruplo[4],tmp)          
        when "write"
          puts @variables.get_variable(cuadruplo[4])
          $stdout.flush
        when "goTo"
          @ip = cuadruplo[4].to_i - 1
        when "gotoFalso"
          @ip = (cuadruplo[4].to_i - 1) if @variables.get_variable(cuadruplo[2]) == false
        when "param"
          @variables.push_param(cuadruplo[4], cuadruplo[2])
        when "gosub"
          @variables.push_variables_stack
          @variables.push_ip(@ip)
          @variables.set_params
          @ip = (cuadruplo[4].to_i - 1)
        when "return"
          @variables.set_variable(cuadruplo[2], @variables.get_variable(cuadruplo[4]))
        when "RET"
          @ip = @variables.pop_stack
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

    def read_procedimientos(file)
      while((line = file.gets) and !line.include?("---"))
        line = line.gsub("\n", "").split("\t")
        @procedimientos.merge!( { line[3].to_i => [] } )
      end
    end
    
  end
end