require 'set'

require_relative 'Parser'
require_relative 'Manejo_Resultados'
require_relative 'Test_tadp'

class Motor
  include Parser, Manejo_Resultados

  attr_accessor :lista_de_test

  def initialize (*clases_test)
    crear_y_cargar_objetos_test clases_test
  end

  def testear(*args)
    limpiar_test_cargados

    test_a_correr = generar_lista_de_test_a_partir_de_argumentos args

    ejecutar_tests test_a_correr
    mostrar_resultados test_a_correr

    obtener_resultados_de_tests test_a_correr
  end

  def esta_cargado? suite
    self.lista_de_test.any? { |test| test.suite == suite}
  end

  private
  def limpiar_test_cargados
    self.lista_de_test.each { |test| test.resultado = nil }
  end

  private
  def crear_y_cargar_objetos_test (clases_test)
    self.lista_de_test ||=[]

    clases_test.each { |suite|
      (filtrar_metodos_test suite.instance_methods).each { |test|
        self.lista_de_test << Test_tadp.new(suite, test)
      }
    }
  end

  private
  def obtener_resultados_de_tests lista_test
    @resultados_obtenidos = []

    lista_test.each{|test|
      @resultados_obtenidos << test.resultado if test.te_ejecutaste?
    }

    @resultados_obtenidos
  end

  private
  def generar_lista_de_test_a_partir_de_argumentos args
    case
      when args.count == 0
        @test_a_correr = self.lista_de_test

      when args.count == 1 && esta_cargado?(args[0])
        @test_a_correr = self.lista_de_test.select{|test| test.suite == args[0]}

      when args.count > 1
        metodos_test = filtrar_metodos_test args[1..-1]
        @test_a_correr = self.lista_de_test.select{|test|
          (test.suite == args[0]) && (metodos_test.include? test.test)}
    end

    @test_a_correr
  end

  private
  def ejecutar_tests test_a_correr
    test_a_correr.each { |test| test.testear}
  end

end