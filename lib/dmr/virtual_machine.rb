module DMR
  class VirtualMachine
    def initialize(input_file)
      @file = File.new(input_file, "r")
      @variables = DMR::Variables.new
    end
    
    def start
    end
    
  end
end