module Hatchbuck  
	module Key 
		def self.set(key)
			@api_key = key
		end
		def self.get
		return @api_key
		end
	end

	module URLifier
		def self.build(object, action)
			base_path = 'https://api.hatchbuck.com/api/v1/'
			key = Key.get
			return "#{base_path}#{object}#{action}?api_key=#{key}"
		end
	end
end

