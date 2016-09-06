require 'set'

require_relative '../src/clases'

# Condiciones es un mixin que le da a las clasesTest
# los mensajes de validacion
# Cada funcion retorna un objeto de tipo Validacion
# que recibe la funcion deberia que entiende Object
module Condiciones

  # ser (un_objeto)-> Validacion
  def ser (un_objeto)
    validacion = Validacion.new(un_objeto)

    validacion.instance_eval do
      def equal?(otro)
        self.objeto.equal?(otro)
      end
    end

    validacion
  end

  # mayor_a (un_objeto)-> Validacion
  def mayor_a (un_objeto)
    validacion = Validacion.new(un_objeto)

    validacion.instance_eval do
      def equal?(otro)
        otro > self.objeto
      end
    end

    validacion
  end

  # menor_a (un_objeto)-> Validacion
  def menor_a (un_objeto)
    validacion = Validacion.new(un_objeto)

    validacion.instance_eval do
      def equal?(otro)
        otro < self.objeto
      end
    end

    validacion
  end

  # uno_de_estos(Objetos) -> Validacion
  def uno_de_estos (*args)

    if args.count == 1 && args[0].class.equal?([].class)
      una_lista = args[0]
    else
      una_lista = args
    end

    validacion = Validacion.new(una_lista)

    validacion.instance_eval do
      def equal?(otro)
        self.objeto.include? otro
      end
    end

    validacion
  end

end


# Parser es quien se encarga de todo lo relacionado
# con la sintaxis de como se escriben los test y
# los hace objetos que el motor u otro objeto los puedan usar
module Parser

  @@STRING_TEST = 'testear_que_'
  @@STRING_TEST_SUITE = 'Test'

  # es_un_tests?(:method) -> bool
  # se fija si los metodos empiesan con el nombre de los test
  def es_un_test?(metodo_de_instancia)
    metodo_de_instancia.to_s.start_with?(@@STRING_TEST)
  end

  # es_un_tests?(Class) -> bool
  # se fija si la clase es una clase tipo testSuite
  def es_un_test_suite?(clase)
    clase.name.include? (@@STRING_TEST_SUITE)
  end
end
