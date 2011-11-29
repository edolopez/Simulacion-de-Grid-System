require_relative 'Evento'
require_relative 'Array'

class Procesador

  attr_accessor :tiempo, :tInicio, :tAnterior, :longAcum, :tServidor, :nTrabajos, :llegadas
  attr_accessor :salidas, :listaEventos

  def initialize
    @tiempo = 0 #tiempo total
    @tInicio = 0 #tiempo de inicio del servicio
    @tAnterior = 0 #tiempo del evento anterior
    @longAcum = 0 #longitud acumulada de trabajos
    @tServidor = 0 #tiempo acumulado del servidor
    @nTrabajos = 0 #numero de trabajos
    @llegadas = 0 #contador de llegadas
    @salidas = 0 #contador de salidas
    @listaEventos = [] #lista de eventos
  end
  
  def self.run(procesadores, tiempo)
    procesadores.each do |procesador|
      procesador.simulate tiempo if procesador.tareas_en_fila?
    end
  end
  
  def self.tareas_pendientes?(procesadores)
    procesadores.each do |procesador|
      return true if procesador.nTrabajos > 0
    end
    return false
  end

  #
  # metodo que inicia la simulacion
  #
  def simulate(tiempo)
    evento = @listaEventos.first
    if evento.tiempo <= tiempo
      evento = @listaEventos.shift
      if evento.tipo == "llegada"
        procesa_llegada evento.tiempo
  #          puts "Llegada del mensaje #{@llegadas} al sistema en T=#{@tiempo} --- Hay #{@nTrabajos} Paquetes en Sistema"
      else
        #procesamos la salida
        procesa_salida evento.tiempo
  #          puts "Salida del mensaje #{@salidas} al sistema en T=#{@tiempo} --- Hay #{@nTrabajos} Paquetes en Sistema"
      end
#      puts @tiempo
    end
  end
  
  def utilizacion
    if @tiempo > 0
      @tServidor / @tiempo
    else
      0
    end
  end
  
  def mensajes_promedio
    if @tiempo > 0
      @longAcum / @tiempo
    else
      0
    end
  end
  
  def tiempo_promedio_en_sistema
    if @salidas > 0
      (mensajes_promedio * @tiempo) / @salidas
    else
     0
    end
  end
  
  def flujo_salida
    if @tiempo > 0
      @salidas / @tiempo
    else
      0
    end
  end
  
  #
  #metodo que crea las llegadas
  #
  def agregar_evento(evento)
    @listaEventos.insertar_evento_en_orden evento
  end
  
  #
  #metodo que procesa las llegadas
  #
  def procesa_llegada(tEvento)
    actualiza_tiempos tEvento
    @nTrabajos+=1
    @llegadas+=1
  end
  
  #
  #metodo que procesa las salidas
  #
  def procesa_salida(tEvento)
    actualiza_tiempos tEvento
    intServ = @tiempo - @tInicio
    @tInicio = @tiempo
    @tInicio = [@tiempo, @listaEventos[0].tiempo].max if @listaEventos.size > 0
    @tServidor += intServ
    @salidas+=1
    @nTrabajos-=1
  end
  
  #
  #metodo que actualiza tiempos
  #
  def actualiza_tiempos(tEvento)
    @tiempo = tEvento
    intervalo = tEvento - @tAnterior
    @tAnterior = tEvento
    @longAcum += (@nTrabajos * intervalo)
  end
  
  def salida_maxima
    return @listaEventos.last.tiempo if @listaEventos.last
    return 0
  end
  
  def tareas_en_fila?
    @listaEventos.any?
  end
  
  def tiempo_paretofractal(tiempo)
    tiempo_de_fila(tiempo) + tiempo_procesamiento(tiempo)
  end
  
  def tiempo_de_fila(tiempo)
    n = ((@listaEventos.tamano_en_tiempo tiempo)/2)
    n*0.000342291+((600*(n**0.8))/(0.05**(1/1.58)))
  end
  
  def tiempo_procesamiento(tiempo)
    if @listaEventos.any?
      @listaEventos.primero_despues_de_tiempo(tiempo).runtime*((0.05**(-1/1.58))-1)
    else
      0
    end
  end
end
