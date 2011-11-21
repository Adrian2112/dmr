module DMR
  class Stack
    
    attr_reader :stack
    
    def initialize
      @stack = []
    end
    
    def push_variables(int, float, boolean, string, tmp_int, tmp_float, tmp_boolean, tmp_string )
      int = int.clone
      float = float.clone
      boolean = boolean.clone
      string = string.clone
      tmp_int = tmp_int.clone
      tmp_float = tmp_float.clone
      tmp_boolean = tmp_boolean.clone
      tmp_string = tmp_string.clone
      @stack.push([int,float,boolean,string,tmp_int,tmp_float,tmp_boolean,tmp_string])
    end
    
    def push_ip(ip)
      @stack.last << ip
    end
    
    def pop
      @stack.pop
    end
    
  end
end