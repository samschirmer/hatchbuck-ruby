module Hatchbuck  
	class Contact
		@object_path = 'contact'

		# accepts either an email address or contact id as a search term
		def self.search(term)
			endpoint = Hatchbuck::URLifier.build(@object_path, '/search') 
			if term =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
				search_json = '{ "emails":[{"address": "' + term + '"}] }'
			else
				search_json = '{ "contactId": "' + term + '" }'
			end

			conn = Faraday.new
			result = conn.post do |req|
				req.url endpoint
				req.headers['Content-Type'] = 'application/json'
				req.body = search_json
			end
			
			# handling response
			if result.status == 400
				return 'not found'
			elsif result.status == 200
				return result.body
			else 
				return false
				puts "Error!"
			end
		end

		# creates the contact; returns false if it exists already
		# use search first and capture the response to update contacts
		def self.create(contact)
			firstname = contact['firstname']
			lastname = contact['lastname']
			email = contact['email']
			email_type = contact['email_type_id']
			status = contact['status_id']

			endpoint = Hatchbuck::URLifier.build(@object_path, '') 
			conn = Faraday.new
			result = conn.post do |req|
				req.url endpoint
				req.headers['Content-Type'] = 'application/json'
				req.body = '{ 
					"firstName": "' + firstname + '", 
					"lastName": "' + lastname + '",
					"emails": [{
						"address": "' + email + '",
						"typeId": "' + email_type + '"
					}],
					"status": {
						"id": "' + status + '"
					} 
				}'
			end

			# handling response
			if result.status == 400
				puts 'Contact already exists.'
				return false
			elsif result.status == 200
				return result.body
			else 
				puts "Error!"
				return false
			end
		end
	
		# TODO
		# accepts either contact id or email address
		# responds false if contact isn't found
		def self.update 
			# PUT api call here
			return json_response
		end
	end
end

