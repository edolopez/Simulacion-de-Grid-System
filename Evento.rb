# Clase Evento que guarda el tiempo del evento y el tipo de evento
class Evento
  attr_accessor :tiempo, :tipo, :runtime
  
  def initialize(tiempo, tipo, runtime)
    @tiempo = tiempo
    @tipo = tipo
    @runtime = runtime
  end
end
