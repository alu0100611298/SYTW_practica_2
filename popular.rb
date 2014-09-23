require 'twitter'

class Popular
	require './configure'

	def initialize
		@user = Hash.new
	end
	def Ver
		client = my_twitter_client()
		seguidores = client.friend_ids("leizercruz").take(5)
		#print seguidores

		seguidores.each do |fid|
				f = client.user(fid)
				@user[f.screen_name.to_s] = f.followers_count
		end
		#print @user
		@users = @user.sort_by {|k,v| -v}

		@users.each do |user,count|
			puts "#{user},#{count}"
		end

	end
end

busqueda = Popular.new
busqueda.Ver
