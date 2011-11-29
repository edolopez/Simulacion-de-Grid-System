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
end
