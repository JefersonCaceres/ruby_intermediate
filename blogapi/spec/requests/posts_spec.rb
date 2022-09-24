require "rails_helper"
##require "byebug"
## pruebas con RSpec
##vamos a probar los posts
RSpec.describe "Posts", type: :request do
    ##se prueba el GET al post
    describe "GET /posts" do
    ##generamos una peticion 
    it "should return OK" do
        ##parametros que le agregamos a la url
        get '/posts'
        payload =JSON.parse(response.body)
        ## en caso de que no haya un post en la bd
        expect(payload).to be_empty  
        ## esperamos que retorne un ok(200)
        expect(response).to have_http_status(200)
    
    end
    
    describe "Search" do
        let!(:hola_mundo) {create(:published_post, title: 'Hola mundo')}
        let!(:hola_rails) {create(:published_post, title: 'Hola rails')}
        let!(:curso_rails) {create(:published_post, title: 'curso rails')}
    it "should filter posts by title" do
    ##parametros que le agregamos a la url
    get "/posts?search=Hola"
    payload =JSON.parse(response.body)
    ## esperamos que no este vacio
    expect(payload).to_not be_empty
    ##que el tamaño sea igual a 2
    expect(payload.size).to eq(2)  
    ##verificar si son los id que buscamos
    expect(payload.map { |p| p["id"]}.sort).to eq([hola_mundo.id, hola_rails.id].sort)    ## esperamos que retorne un ok(200)
    expect(response).to have_http_status(200)
    end
    end
    end
    ##creamos otra prueba con la siguiente descripcion
    ## "con datos en la base de datos"
    describe "with data in the BD" do         
     ## de esta prueba se espera el retorno 
     ## - de una lista de articulos 
     ## para esto utilizare factoryBot 
     ## esta libreria nos permite generar datos de prueba
     ## con esto let(:post) vamos a crear una variable
     ## donde lo que se le ponga aca{ ej: 5}se le asignara a la variable{}   
     let!(:posts) {create_list(:post, 10, published: true)}
        #let
        #let!
     ## create_list(:post,10 published: true) --> es factoryBot
     
     ## nombre de la prueba
     ## puede retornar todo los post publicados 

    it "should return all the published posts" do     
        get '/posts'
        payload =JSON.parse(response.body)
        ##debemos esperar una lista de posts en payload
        expect(payload.size).to eq(posts.size)
          ##esperamos que el tamaño sea igual al de posts
        expect(response).to have_http_status(200)

    end
     end
     ##probar el get al detalle{id} del post
     describe "GET /post/{id}" do
        let!(:post) {create(:post)}
        ## create_list(:post,10 published: true) --> es factoryBot
         ## nombre de la prueba
         ## puede retornar todo los post publicados   
        it "should return a post" do    
            get "/posts/#{post.id}"
            payload =JSON.parse(response.body)
            
            expect(payload).to_not be_empty
            ##en las pruebas para hacer la serializacion
            expect(payload["id"]).to eq(post.id)
            expect(payload["title"]).to eq(post.title)
            expect(payload["content"]).to eq(post.content)
            expect(payload["published"]).to eq(post.published)
            expect(payload["author"]["name"]).to eq(post.user.name)
            expect(payload["author"]["email"]).to eq(post.user.email)
            expect(payload["author"]["id"]).to eq(post.user.id)
            ###___________________________
            expect(response).to have_http_status(200)
    
     end
    end
# describe "POST /posts" do
#     let!(:user) {create(:user)}
    
#     it "shoukd create a post" do
#     req_payload = {
#         post: {
#             title: "title",
#             content: "content",
#             published: false,
#             user_id: user.id
#         }
#     }
#     ##post http
#     post "/posts", params: req_payload
#     payload = JSON.parse(response.body)
#     expect(payload).to_not be_empty
#     expect(payload["id"]).to_not be_nil
#     expect(response).to have_http_status(:created)
#         end
#         it "shoukd return error message on invalid post" do
#             req_payload = {
#                 post: {
                    
#                     content: "content",
#                     published: false,
#                     user_id: user.id
#                 }
#             }
#             ##post http
#             post "/posts", params: req_payload
#             payload = JSON.parse(response.body)
#             expect(payload).to_not be_nil
#             expect(payload["error"]).to_not be_empty
#             expect(response).to have_http_status(:unprocessable_entity)
#                 end
#     end
#     describe "PUT /posts/{id}" do
#         let!(:article) {create(:post)}
#         it "shoukd create a post" do
#         req_payload = {
#             post: {
#                 title: "title",
#                 content: "content",
#                 published: true
#             }
#         }
#         ##put http
#         put "/posts/#{article.id}", params: req_payload
#         payload = JSON.parse(response.body)
#         expect(payload).to_not be_empty
#         expect(payload["id"]).to eq(article.id)
#         expect(response).to have_http_status(:ok)
#     end
#     it "shoukd return error message on invalid " do
#         req_payload = {
#             post: {
#                 title: nil,
#                 content: nil,
#                 published: false,
#             }
#         }
#         ##put http
#         put "/posts/#{article.id}", params: req_payload
#         payload = JSON.parse(response.body)
#         expect(payload).to_not be_empty
#         expect(payload["error"]).to_not be_empty
#         expect(response).to have_http_status(:unprocessable_entity)
#     end
#     end
    
end

### este codigo en la terminal podemos generar el factoryBot
### rails g factory_bot:model user email:string name:string auth_token:string
### rails g factory_bot:model post title:string content:string published:boolean user:references

### VERIFICAR LA CREACION CON FACTORI (posibles errores)
### en consola
## RAILS_ENV=test rails c
## corremos el factory con 
## FactoryBot.build(:post)
## guardamos con post= FactoryBot.build(:post)
## preguntamos si es valido con post.valid?
## tambien preguntamos los errores con post.errors
