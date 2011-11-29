class Brocker

  attr_accessor :ultimo_asignado, :tipo
  
  def initialize(tipo)
    @ultimo_asignado = -1 #ultimo procesador asignado que al inicio es -1
    @tipo = tipo
  end
  
  def procesadores_asignados(procesadores, nProcesadores, nproc, tiempo)
    if @tipo == "RoundRobin"
      return round_robin(procesadores, nProcesadores, nproc)
    elsif @tipo == "List"
      return list(procesadores, nproc, tiempo)
    elsif @tipo == "Paretofractal"
      return paretofractal(procesadores, nproc, tiempo)
    end
  end
  
  def round_robin(procesadores, nProcesadores, nproc)
    processors = procesadores.rotate(@ultimo_asignado+1).first(nproc)
    @ultimo_asignado=(@ultimo_asignado+nproc)%nProcesadores
    processors
  end
  
  def list(procesadores, nproc, tiempo)
    (procesadores.sort {|a,b| (a.listaEventos.tamano_en_tiempo tiempo) <=> (b.listaEventos.tamano_en_tiempo tiempo)}).first(nproc)
  end
  
  def paretofractal(procesadores, nproc, tiempo)
    (procesadores.sort {|a,b| (a.tiempo_paretofractal tiempo) <=> (b.tiempo_paretofractal tiempo)}).first(nproc)
  end
end
