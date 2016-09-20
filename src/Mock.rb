  module Mock

    #atributos
    @@metodos_mockeados

    #constantes
    @@CARACTER_VIEJO = "___viejo"

    def self.enseniar_mockear_a_class
      Class.send(:define_method, :mockear, proc { |metodo, &block|

        Mock.agregar_metodo_mockeado(self, metodo)

        if self.new.respond_to? metodo
         nomre_metodo_viejo = metodo.to_s + @@CARACTER_VIEJO
           self.send(:alias_method, nomre_metodo_viejo, metodo)
        end

        self.send(:define_method, metodo, block)
      })
    end

    def self.agregar_metodo_mockeado(klass,metodo)
      @@metodos_mockeados ||= []
      @@metodos_mockeados << Comportamiento.new(klass,metodo)
    end

    def self.recomponer_comportamiento_mockeado
      @@metodos_mockeados ||= []
      @@metodos_mockeados.each {|comportamiento| comportamiento.recomponer()}

      @@metodos_mockeados = [] ##Los limpio para la siguiente corrida
    end

    def self.nombre_metodo_viejo(metodo)
      (metodo.to_s + @@CARACTER_VIEJO).to_sym
    end
  end