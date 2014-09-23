# -*- coding: utf-8 -*-
require 'twitter'
require 'rack'
#require 'pry-debugger'
require 'thin'
require 'erb'

class Twitts

  require './configure'

	#Inicializar variables
	def initialize
		@name = ''
		@number = 0
		@user = Hash.new

	end

	#Acceso al HTML para mostrar los resultados
	def erb(template)
  		template_file = File.open("twitter.html.erb", 'r')
  		ERB.new(File.read(template_file)).result(binding)
	end
	
	#Método call
	def call env
	    req = Rack::Request.new(env)
	    client = my_twitter_client() 
	    binding.pry if ARGV[0]
	   
	   #Si no esta vacio , no es un espacio y el usuario existe en Twitter el nombre es el introducido
	    @name = (req["firstname"] && req["firstname"] != '' && client.user?(req["firstname"]) == true ) ? req["firstname"] : ''

		@number = (req["n"] && req["n"].to_i>1 ) ? req["n"].to_i : 1
		
		#Si el nombre existe buscamos sus últimos Tweets
		if @name == req["firstname"]
			# Conseguimos el identificador de los seguidores del usuario
			seguidores = client.friend_ids(@name).take(@number)
			# Borramos la consulta anterios
			@user = Hash.new
			# Por cada amigo sacamos el numero de seguidores
			seguidores.each do |fid|
					f = client.user(fid)
					@user[f.screen_name.to_s] = f.followers_count
			end
			# Ordenamos a nuestros amigos por el numero de seguidores
			@users = @user.sort_by {|k,v| -v}			
		end

		#Invoca a erb
		Rack::Response.new(erb('twitter.html.erb'))
	end

end

if $0 == __FILE__
	Rack::Server.start(
# 		:app => Rack::ShowExceptions.new(
#        	Rack::Lint.new(
#           	Rack::Twitts.new)), 
		:app => Twitts.new,
	    :Port => 9393,
	    :server => 'thin'
  	)
end
