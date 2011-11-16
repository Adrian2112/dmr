module DMR
  class Variables
    
    GLOBAL_INT              = 1000..1999
    GLOBAL_FLOAT            = 2000..2999
    GLOBAL_BOOLEAN          = 3000..3999
    GLOBAL_STRING           = 4000..4999
    LOCAL_INT               = 5000..5999
    LOCAL_FLOAT             = 6000..6999
    LOCAL_BOOLEAN           = 7000..7999
    LOCAL_STRING            = 8000..8999
    TEMPORAL_GLOBAL_INT     = 9000..9999
    TEMPORAL_GLOBAL_FLOAT   = 10000..10999
    TEMPORAL_GLOBAL_BOOLEAN = 11000..11999
    TEMPORAL_LOCAL_INT      = 12000..12999
    TEMPORAL_LOCAL_FLOAT    = 13000..13999
    TEMPORAL_LOCAL_BOOLEAN  = 14000..14999
    CONSTANTE_INT           = 15000..15999
    CONSTANTE_FLOAT         = 16000..16999
    
    attr_reader :globales_int
    attr_reader :globales_float
    attr_reader :globales_boolean
    attr_reader :globales_string
    attr_reader :locales_int
    attr_reader :locales_float
    attr_reader :locales_boolean
    attr_reader :locales_string
    attr_reader :temporales_locales_int
    attr_reader :temporales_locales_float
    attr_reader :temporales_locales_boolean
    attr_reader :temporales_globales_int
    attr_reader :temporales_globales_float
    attr_reader :temporales_globales_boolean
    attr_reader :constante_int
    attr_reader :constante_float
    
    def initialize
      @globales_int = {}
      @globales_float = {}
      @globales_boolean = {}
      @globales_string = {}
      @locales_int = {}
      @locales_float = {}
      @locales_boolean = {}
      @locales_string = {}
      @temporales_locales_int = {}
      @temporales_locales_float = {}
      @temporales_locales_boolean = {}
      @temporales_globales_int = {}
      @temporales_globales_float = {}
      @temporales_globales_boolean = {}
      @constante_int = {}
      @constante_float = {}
    end
    
    # carga la variable dada en el arreglo que le corresponde segun su direccion
    def set_variable(direccion, valor)
      direccion = direccion.to_i

      case direccion
        when GLOBAL_INT                 then @globales_int.merge!({direccion => valor.to_i})
        when GLOBAL_FLOAT               then @globales_float.merge!({direccion => valor.to_f})
        when GLOBAL_BOOLEAN             then @globales_boolean.merge!({direccion => boolean(valor)})
        when GLOBAL_STRING              then @globales_string.merge!({direccion => valor.gsub("\"", "")})
        when LOCAL_INT                  then @locales_int.merge!({direccion => valor.to_i})
        when LOCAL_FLOAT                then @locales_float.merge!({direccion => valor.to_f})
        when LOCAL_BOOLEAN              then @locales_boolean.merge!({direccion => boolean(valor)})
        when LOCAL_STRING               then @locales_string.merge!({direccion => valor.gsub("\"", "")})
        when TEMPORAL_GLOBAL_INT        then @temporales_globales_int.merge!({direccion => valor.to_i})
        when TEMPORAL_GLOBAL_FLOAT      then @temporales_globales_float.merge!({direccion => valor.to_f})
        when TEMPORAL_GLOBAL_BOOLEAN    then @temporales_globales_boolean.merge!({direccion => boolean(valor)})
        when TEMPORAL_LOCAL_INT         then @temporales_locales_int.merge!({direccion => valor.to_i})
        when TEMPORAL_LOCAL_FLOAT       then @temporales_locales_float.merge!({direccion => valor.to_f})
        when TEMPORAL_LOCAL_BOOLEAN     then @temporales_locales_boolean.merge!({direccion => boolean(valor)})
        when CONSTANTE_INT              then @constante_int.merge!({direccion => valor.to_i})
        when CONSTANTE_FLOAT            then @constante_float.merge!({direccion => valor.to_f})
      end
    end
    
    def get_variable(direccion)
      direccion = direccion.to_i
      case direccion
        when GLOBAL_INT                 then return @globales_int[direccion]
        when GLOBAL_FLOAT               then return @globales_float[direccion]
        when GLOBAL_BOOLEAN             then return @globales_boolean[direccion]
        when GLOBAL_STRING              then return @globales_string[direccion]
        when LOCAL_INT                  then return @locales_int[direccion]
        when LOCAL_FLOAT                then return @locales_float[direccion]
        when LOCAL_BOOLEAN              then return @locales_boolean[direccion]
        when LOCAL_STRING               then return @locales_string[direccion]
        when TEMPORAL_GLOBAL_INT        then return @temporales_globales_int[direccion]
        when TEMPORAL_GLOBAL_FLOAT      then return @temporales_globales_float[direccion]
        when TEMPORAL_GLOBAL_BOOLEAN    then return @temporales_globales_boolean[direccion]
        when TEMPORAL_LOCAL_INT         then return @temporales_locales_int[direccion]
        when TEMPORAL_LOCAL_FLOAT       then return @temporales_locales_float[direccion]
        when TEMPORAL_LOCAL_BOOLEAN     then return @temporales_locales_boolean[direccion]
        when CONSTANTE_INT              then return @constante_int[direccion]
        when CONSTANTE_FLOAT            then return @constante_float[direccion]
      end
    end
    
    def boolean(valor)
      if valor.class == String
        valor.to_boolean
      elsif valor.class == TrueClass or valor.class == FalseClass
        return valor
      end
      return false
    end
            
  end
  
end