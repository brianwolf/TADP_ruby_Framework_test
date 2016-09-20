require_relative 'Mock'

class Comportamiento
  include Mock

  attr_accessor :klass,:metodo

  def initialize(klass,metodo)
    self.klass= klass
    self.metodo= metodo
  end

  def recomponer
    self.klass.send(:undef_method, self.metodo)

    nombre_metodo_viejo = Mock.nombre_metodo_viejo(metodo)

    if self.klass.new.respond_to? nombre_metodo_viejo
      self.klass.send(:alias_method, self.metodo, nombre_metodo_viejo)
      self.klass.send(:undef_method, nombre_metodo_viejo)
    end

  end

end