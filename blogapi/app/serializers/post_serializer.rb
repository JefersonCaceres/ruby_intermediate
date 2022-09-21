class PostSerializer < ActiveModel::Serializer
  ##usamos el serializador 
  ##para acomodar el json con el modelo en este caso "post"
  attributes :id, :title, :content, :published, :author

  #para definir el author en el post
  ##debemos crear un metodo con el mismo nombre
  ###incluimos los campos que deseamos retornar
  ####usamos el self para hacer referencia a user 
  def author
    user = self.object.user
    {
    name:user.name,
    email: user.email,
    id: user.id
  }
  end
end
