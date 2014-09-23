# -*- coding: utf-8 -*-
require 'twitter'
require 'sinatra'

require './configure'

#Inicializar variables
get '/' do
	@name = ''
	@number = 0
	@number_total = 0
	@user = Hash.new
	erb :twitter
end

post '/' do
    req = Rack::Request.new(env)
    client = my_twitter_client() 
    binding.pry if ARGV[0]
   
   #Si no esta vacio , no es un espacio y el usuario existe en Twitter el nombre es el introducido
    @name = (req["firstname"] && req["firstname"] != '' && client.user?(req["firstname"]) == true ) ? req["firstname"] : ''

	@number = (req["n"] && req["n"].to_i>1 ) ? req["n"].to_i : 1
	#Numero maximo de consulta para no sobrepasar el ancho de banda
	@number_total = @number
	@number = 10 if @number > 10
	
	#Si el nombre existe buscamos sus últimos Tweets
	if @name == req["firstname"]
		# Conseguimos el identificador de los seguidores del usuario
		seguidores = client.friend_ids(@name).take(@number)
		# Borramos la consulta anterios
		@user = Hash.new
		# Por cada amigo sacamos el numero de seguidores
		seguidores.each do |fid|
				f = client.user(fid)
				# En un hash metemos usuario, nº de seguidores
				@user[f.screen_name.to_s] = f.followers_count
		end
		# Ordenamos a nuestros amigos por el numero de seguidores
		@users = @user.sort_by {|k,v| -v}			
	end
	erb :twitter
	#Invoca a erb
end
