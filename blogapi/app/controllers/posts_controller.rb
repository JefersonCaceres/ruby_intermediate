class PostsController <ApplicationController
    ##el only nos dice que debe ser ejecutado antes de un create, update
    ##
    include Secured
    before_action :authenticate_user!, only: [:create, :update]

    ##manejo de excepciones
    ##usamos
    ## NOTA
    ## el rescue_from que se posiciona de ultimo tiene mas prioridad
    ## 
    rescue_from Exception do |e|
         render json: {error: e.message}, status: :internal_error
    end
    
    rescue_from ActiveRecord::RecordNotFound do |e|
        render json: {error: e.message}, status: :not_found
    end
    
    rescue_from ActiveRecord::RecordInvalid do |e|
        render json: {error: e.message}, status: :unprocessable_entity
    end

    #GET/post
    def index
        ## debemos traer solo los articulos publicados
        @posts = Post.where(published: true)
       
        if !params[:search].nil? && params[:search].present?
        @posts= PostsSearchService.search(@posts, params[:search])
        end
         ##para retornar usamos 
         ##con este codigo obtendremos el error N+1 query
         ## render json: @posts, status: :ok 
         ##con este codigo lo corregimos
         ##para detectarlo esta escrito a lo ultimo de esta pagina
        render json: @posts.includes(:user), status: :ok 
    end
    #GET /post/{id}
    def show
        ## debemos buscar el id
        @post= Post.find(params[:id])
        if (@post.published?|| (Current.user && @post.user_id == Curen.user.id))
        render json: @post, status: :ok
        else
            render json: {error: 'Not Found'}, status: :not_found
        end
    end
    ## Metodo post /posts 
    def create
    @post = Current.user.posts.create!(create_params)
    render json: @post, status: :created
    end
    ## metodo put /posts/{id}
    def update
     @post= Current.user.posts.find(params[:id])
     @post.update!(update_params)
     render json: @post, status: :ok
    end
    
    private

    def create_params
        params.require(:post).permit(:title, :content, :published)
    end
    def update_params
        params.require(:post).permit(:title, :content, :published)  
    end
    
end
##DETECTAR N + 1 QUERY
### para detectar el problemas vamos a las pruebas rspec
### buscamos especificamente la prueba donde listamos 
###en este caso un post "prueba:index"
## miramo el numero de linea donde esta la prueba
## en este caso es la linea 40
##vamos a la terminal y usamos el siguiente comando
##donde buscamos la prueba y señalamos la linea de codigo
### bundle exec rspec spec/requests/posts_spec.rb:40
###solo se ejecutara esa prueba
### veremos los log que se usan en la prueba usando...
## ls log/development.log test.log
##limpiamos el test de prueba
### rm log/test.log
##creamo un archivo
###touch log/test.log
##usamos este comando para moritoriar lo que pasa con el archivo
### tail -f log/test.log

###en otra terminal corremos la prueba 
####bundle exec rspec spec/requests/posts_spec.rb:40