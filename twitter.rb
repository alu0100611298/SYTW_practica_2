# -*- coding: utf-8 -*-
require 'twitter'
require 'sinatra'

require './configure'

#Inicializar variables
get '/' do
	@name = ''
	@number = 0
	@number_total = 0
	@users = []
	erb :twitter
end

post '/' do
    req = Rack::Request.new(env)
    client = my_twitter_client() 
    binding.pry if ARGV[0]
   
   #Si no esta vacio , no es un espacio y el usuario existe en Twitter el nombre es el introducido
    @name = (req["firstname"] && req["firstname"] != '' && client.user?(req["firstname"]) == true ) ? req["firstname"] : ''

	@number = (req["n"] && req["n"].to_i>1 ) ? req["n"].to_i : 1
	# Se fuerza el máximo de consultas a 10
	@number_total = @number
	@number = 10 if @number > 10
	
	#Si el nombre existe buscamos sus últimos Tweets
	if @name == req["firstname"]
		# Buscamos a los amigos de ese usuario
		seguidores = client.friends(@name,{})
		# Nos quedamos con el nombre y el número de seguidores
		seguidores = seguidores.map { |i| [i.name , i.followers_count]}
		# Ordenamos por el número de seguidores
		@users = seguidores.sort_by!{|k,v| -v}
		# De esos usuarios coge 10
		@users = @users.take(@number)
	end
	erb :twitter
	#Invoca a erb
end
