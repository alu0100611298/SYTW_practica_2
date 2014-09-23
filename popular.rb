require 'twitter'
#Clase para la busqueda de tus amigos mas populares.
class Popular
	require './configure'
	def initialize
		# Si no se le pasan parametros por defecto es mi usuario
		@name = ARGV[0] || 'leizercruz'
		# Amigos a consultar por defecto 5
		@number = ARGV[1] || 5
		# Hash que guarda nombre del usuario y sus seguidores
		@user = Hash.new
	end
	def Ver
		client = my_twitter_client()
		# Conseguimos el identificador de los seguidores del usuario
		seguidores = client.friend_ids(@name).take(@number.to_i)
		# Por cada amigo sacamos el numero de seguidores
		seguidores.each do |fid|
				f = client.user(fid)
				@user[f.screen_name.to_s] = f.followers_count
		end
		# Ordenamos a nuestros amigos por el numero de seguidores
		@users = @user.sort_by {|k,v| -v}
		# Imprimimos el vector
		puts "Su lista ordenada de amigos:"
		@users.each do |user,count|
			puts "#{user},#{count}"
		end
	end
end

busqueda = Popular.new
busqueda.Ver
