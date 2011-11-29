#agregamos un metodo a la clase Array para insertar los eventos en orden

class Array
  def insertar_evento_en_orden(evento) 
    pos=self.size
    each_with_index do |v, i|
      if v.tiempo > evento.tiempo
         pos=i
         break
      end
    end
    insert(pos,evento)
  end
  
  def tamano_en_tiempo(tiempo)
    tamano = 0
    self.each_with_index do |evento, index|
      if evento.tiempo >= tiempo
        tamano = self.size-index
        break
      end
    end
    tamano
  end
  
  def primero_despues_de_tiempo(tiempo)
    l = 0
    u = self.size
    while l<u
      m = l+(u-l)/2
      if m > l and self[m-1].tiempo == tiempo and self[m].tiempo > tiempo
        return self[m]
      elsif self[m].tiempo > tiempo
        u = m
      elsif self[m].tiempo <= tiempo
        l = m+1
      end
    end
    return self[l] if l < self.size and l >= 0 and l == u and self[l].tiempo > tiempo
    return 0
  end
  
end
