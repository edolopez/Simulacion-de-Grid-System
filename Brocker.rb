class Brocker

  attr_accessor :ultimo_asignado, :tipo
  
  def initialize(tipo)
    @ultimo_asignado = -1 #ultimo procesador asignado que al inicio es -1
    @tipo = tipo
  end
  
  def procesadores_asignados(procesadores, nProcesadores, nproc)
    if @tipo == "RoundRobin"
      return round_robin(procesadores, nProcesadores, nproc)
    elsif @tipo == "List"
      return list(procesadores, nproc)
    elsif @tipo == "Paretofractal"
      return paretofractal(procesadores, nproc)
    end
  end
  
  def round_robin(procesadores, nProcesadores, nproc)
    processors = procesadores.rotate(@ultimo_asignado+1).first(nproc)
    @ultimo_asignado=(@ultimo_asignado+nproc)%nProcesadores
    processors
  end
  
  def list(procesadores, nproc)
    (procesadores.sort {|a,b| a.listaEventos.size <=> b.listaEventos.size}).first(nproc)
  end
  
  def paretofractal(procesadores, nproc)
    (procesadores.sort {|a,b| a.tiempo_paretofractal <=> b.tiempo_paretofractal}).first(nproc)
  end
end
