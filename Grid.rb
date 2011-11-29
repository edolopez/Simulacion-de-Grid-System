require_relative 'Evento'
require_relative 'Procesador'
require_relative 'Brocker'
require_relative 'Progressbar'

class Grid

  attr_accessor :lambda, :nProcesadores, :procesadores, :input_file, :tiempo, :brocker
  
  def initialize(brocker, nProcesadores)
    @lambda = 0.027383 # razon de llegada al grid
    @nProcesadores = nProcesadores # numero de procesadores
    @procesadores = Array.new(@nProcesadores){Procesador.new} #arreglo de procesadores
    @input_file = File.new("datos_test.csv", "r")
    @tiempo = 0 #tiempo del grid
    @ultima_llegada = 0
    @brocker = brocker
    @numero_tareas = 65535
  end  
  
  def simulate
    @input_file.gets
    num = 0
    progressbar = Progressbar.new
    puts("\nBrocker con la estrategia #{@brocker.tipo}")
    progressbar.progress 0
    while(line = @input_file.gets)
      num += 1
      progressbar.progress ((num/(@numero_tareas*1.0))*100)
      genera_llegada_y_salida line
      Procesador.run @procesadores, @ultima_llegada
    end
    while(Procesador.tareas_pendientes? @procesadores)
      Procesador.run @procesadores, 1/0.0
    end
    promedio = 0
    @procesadores.each{|p| promedio+=p.tiempo_promedio_en_sistema}
    puts "\nPromedio de tiempo en el GRID #{promedio/@nProcesadores}"
#    tiempos = @procesadores.map{|p| p.tiempo_promedio_en_sistema}
#    puts "Tiempo promedio maximo de un Procesador en el GRID #{tiempos.max}"
#    puts "Tiempo promedio minimo de un Procesador en el GRID #{tiempos.min}"
    tareas = 0
    @procesadores.each{|p| tareas+=p.mensajes_promedio}
    puts "Promedio de Tareas en GRID #{tareas/@nProcesadores}"
    makespan = @procesadores.map{|p| p.tiempo}
    puts "Makespan del GRID #{makespan.max}\n"
     #imprimimos los datos para cada procesador
#     @nProcesadores.times do |i|
#      puts "Procesador #{i+1}\n"
#      puts "Utilizacion = #{@procesadores[i].utilizacion}"
#      puts "Mensajes Promedio = #{@procesadores[i].mensajes_promedio}"
#      puts "Tiempo Promedio en Sistema = #{@procesadores[i].tiempo_promedio_en_sistema}"
#      puts "Flujo de Salida = #{@procesadores[i].flujo_salida}\n\n"
#     end

    
  end
  
  def genera_llegada_y_salida(line)
    runtime,nproc=line.split(",")
    if (nproc.to_i <= @nProcesadores)  # Si el numero de procesadores solicitados es menor o igual que los del sistema      
      tEvento = @ultima_llegada + ((-1 * Math.log(rand)) / @lambda)
      processors = @brocker.procesadores_asignados(@procesadores, @nProcesadores, nproc.to_i, tEvento)
      salidamax = (processors.map{|p| p.salida_maxima}).max
      processors.each do |procesador|
        procesador.agregar_evento Evento.new(tEvento, "llegada", runtime.to_f)
        procesador.agregar_evento Evento.new(([tEvento, salidamax].max)+runtime.to_f, "salida", runtime.to_f)
      end
      @ultima_llegada = tEvento
    else
  #   puts 'tarea descartada\n'
    end
  end
  
end

proc = 0
while ((proc != 10) and (proc != 50) and (proc != 100) and (proc != 500) and (proc != 1000))
  puts "Cuantos procesadores tiene el sistema (10, 50, 100, 500 o 1000)?"
  proc = gets.to_i
  puts "\n"
end

puts "-----------------"
puts "Simulacion con #{proc} procesadores"
grid = Grid.new(Brocker.new("List"), proc)
grid.simulate

grid = Grid.new(Brocker.new("List"), proc)
grid.simulate

grid = Grid.new(Brocker.new("Paretofractal"), proc)
grid.simulate
