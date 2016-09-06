require_relative '../src/mixines'
require_relative '../src/clases'

class MiSuiteDeTests
  def testear_que_pasa_algo
  end

  def testear_que_pasa_otra_cosa
  end

  def no_soy_test_me_cole
  end
end


class Test_de_prueba_ser
  def testear_que_7_es_igual_a_7
    7.deberia ser 7
  end

  def testear_que_true_es_igual_a_true
    true.deberia ser true
  end
end


class Prueba_Test_condiciones
  def testear_que_5_mayor_a_3
    5.deberia ser mayor_a 3
  end

  def testear_que_2_menor_a_100
    3.deberia ser menor_a 100
  end

  def testear_que_1_debia_ser_uno_de_estos
    1.deberia ser uno_de_estos [1,2]
  end

  def testear_que_uno_de_estos_con_parametros
    "asd".deberia ser uno_de_estos 1,"asd",false
  end

end
