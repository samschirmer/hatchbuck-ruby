module Hatchbuck  
	class Tag
		@object_path = 'contact'
		def self.create(term, tag)
			endpoint = Hatchbuck::URLifier.build(@object_path, "/#{term}/tags") 

			conn = Faraday.new
			result = conn.post do |req|
				req.url endpoint
				req.headers['Content-Type'] = 'application/json'
				req.body = '[{ "id": "' + tag + '" }]'
			end

			# handling response
			if result.status == 201
				return result.body
			else 
				return false
				puts "Error!"
			end
		end
	end
end

