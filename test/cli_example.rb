require '../lib/hatchbuck.rb'
require 'faraday'
require 'json'
include Hatchbuck

# debug stuff
print 'First name: '
fname = gets.chomp
print 'Last name: '
lname = gets.chomp
print 'Company: '
company = gets.chomp
print 'Email address or contact id: '
new_signup = gets.chomp
print 'Tag id: '
tag_id = gets.chomp
print 'API key: '
api_key = gets.chomp

# populating api key
Hatchbuck::Key.set(api_key)

# searching for a contact
# response is either response JSON from API, a string ("not found"), or boolean false (error)
term = new_signup 
response = Hatchbuck::Contact.search(term)


# testing for validity
if response

	#
	# HANDLING CONTACT NOT FOUND | CREATING ONE
	#
	if response == 'not found'
		puts "Contact not found. Creating it..."
		contact = Hash[
			'firstname' => fname,
			'lastname' => lname,
			'company' => company,
			'email' => new_signup,
			'email_type_id' => 'VmhlQU1pZVJSUFFJSjZfMHRmT1laUmwtT0FMNW9hbnBuZHd2Q1JTdE0tYzE1',
			'status_id' => 'M1BWX2RLc0FITklIMWRjMUUteGJ1ZTJEMEZiU2ktd0hCOUE1NTNUZTgzSTE1'
		]
	
		# making API call to Hatchbuck
		response = Hatchbuck::Contact.create(contact)

		# handling response
		# successful creation returns reponse JSON while anything else returns bool false
		if response 
			metadata = JSON.parse(response)
			id_to_tag = metadata["contactId"]
			puts "\nNew contact created successfully:"
			puts "First Name: #{metadata["firstName"]}"
			puts "Last Name: #{metadata["lastName"]}"
			puts "Company: #{metadata["company"]}"
			puts "Email: #{metadata["emails"].first["address"]}"
			puts "Contact ID: #{metadata["contactId"]}"
			puts "\n"
		else
			'Something went wrong. Undefined error.'
		end

 	#
	# CONTACT FOUND | PULLING METADATA
	#
	else
		# returns array of JSONs since there can be more than one match
		# if you search by email or contact id and only expect one result, 
		# just use JSON.parse($res).first 
		metadata = JSON.parse(response).first
		id_to_tag = metadata["contactId"]
		puts "\nContact found:"
		puts "First Name: #{metadata["firstName"]}"
		puts "Last Name: #{metadata["lastName"]}"
		puts "Company: #{metadata["company"]}"
		puts "Email: #{metadata["emails"].first["address"]}"
		puts "Contact ID: #{metadata["contactId"]}"
		puts "\n"
	end

# API threw an error
else 
	puts "Something went wrong: #{response}"
end


# Tagging new (or found) contact
response = Hatchbuck::Tag.create(id_to_tag, tag_id)
if response
	metadata = JSON.parse(response)
	puts metadata
else
	puts 'Error adding tag!'
end

