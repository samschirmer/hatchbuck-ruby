module Hatchbuck  
	class Contact
		@object_path = 'contact'

		# accepts either an email address or contact id as a search term
		def self.search(term)
			endpoint = Hatchbuck::URLifier.build(@object_path, '/search') 

			determination = Hatchbuck::TermDeterminer.determine(term)
			if determination == 'email'
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
			endpoint = Hatchbuck::URLifier.build(@object_path, '') 

			firstname = contact['firstname']
			lastname = contact['lastname']
			email = contact['email']
			company = contact['company']
			email_type = contact['email_type_id']
			status = contact['status_id']

			conn = Faraday.new
			result = conn.post do |req|
				req.url endpoint
				req.headers['Content-Type'] = 'application/json'
				req.body = '{ 
					"firstName": "' + firstname + '", 
					"lastName": "' + lastname + '",
					"company": "' + company + '",
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
	
		# accepts either contact id or email address as search term
		# responds false if contact isn't found
		def self.update(term, contact) 
			endpoint = Hatchbuck::URLifier.build(@object_path, '') 

			firstname = contact['firstname']
			lastname = contact['lastname']
			email = contact['email']
			company = contact['company']
			email_type = contact['email_type_id']
			status = contact['status_id']

			determination = Hatchbuck::TermDeterminer.determine(term)
			if determination == 'email'
				search_json = '	{ 	
													"emails": [{
														"address": "' + email + '", 
														"typeId": "' + email_type + '"
													}] 
												}'
			else
				search_json = '	{ 
													"contactId": "' + term + '", 
													"emails": [{
														"address": "' + email + '", 
														"typeId": :' + email_type + '"
													}] 
												}'
			end
				
			conn = Faraday.new
			result = conn.put do |req|
				req.url endpoint
				req.headers['Content-Type'] = 'application/json'
				req.body = '{
					"firstName": "' + firstname + '", 
					"lastName": "' + lastname + '",
					"company": "' + company + '",
					"emails": [{
						"address": "' + email + '",
						"typeId": "' + email_type + '"
					}],
					"status": {
						"id": "' + status + '"
					} 
				}'
			end

			puts result.status
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
			return json_response
		end
	end
end

