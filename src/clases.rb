require 'set'

require_relative '../src/mixines'

# Motor es el encargado de cargar las clases de los test
# y luego ejecutarlos con motor.correrTest
class Motor
  include Parser

  # initialize(clase_test) -> Motor
  # cuando se inicializa recibe la clase con los test que va a ejecutar
  def initialize (*clases_test)
    clases_test.each { |clase|
      enseniar_condiciones_a_clase(clase)
    }

    enseniar_deberia_a_Object
  end

  # obtener_metodos_de_test(Class) -> [:Method]
  # dado una clase devuelve los metodos que son test
  def obtener_metodos_de_test(clase_test)
    clase_test.instance_methods.
        select{ |metodo| es_un_test?(metodo)}
  end

  # enseniar_deberia_a_Object -> void
  # fuerza a que todos los objetos entiendan deberia
  def enseniar_deberia_a_Object

    unless Object.instance_methods.include? :deberia
      Object.class_exec do
        # deberia(Object) -> bool
        def deberia(objeto_a_comparar)
          resultado = Resultado.new
            resultado.resultado_del_equal= objeto_a_comparar.equal?(self)

          resultado
        end
      end
    end
  end

  # olvidar_deberia_a_Object -> void
  def olvidar_deberia_a_Object
    #preguntar como lo hago
  end

  # enseniar_condiciones_a_clase(Class) -> void
  # hace que la clase entienda los mensajes ser, mayor_a, etc
  def enseniar_condiciones_a_clase(clase_test)
    clase_test.class_eval do
      include Condiciones
    end
  end

  def testear(clase_test)
    if es_un_test_suite?(clase_test)
      instancia = clase_test.new
      lista_resultados = Set.new

      obtener_metodos_de_test(clase_test).each { |metodo_test|
        resultado = instancia.send(metodo_test).clone
          resultado.nombre_test = metodo_test.to_s
          resultado.nombre_test_suite = instancia.class.name

        lista_resultados.add resultado
      }

      lista_resultados
    end
  end

end


# Validacion es el objeto que crean los metodos del mixin Condicion (ser, mayor_a, etc.)
# y es el parametro de la funcion deberia del mixin Deberia
class Validacion

  attr_accessor :objeto

  # initialize(Object) -> Validacion
  def initialize(objeto_para_preguntar_equal)
    self.objeto= objeto_para_preguntar_equal
  end

end

# Resultado es lo que devuelve la funcion deberia
class Resultado
  attr_accessor :resultado_del_equal,:nombre_test,:nombre_test_suite

  def initialize
  end

  def imprimir_en_pantalla
  end
end
