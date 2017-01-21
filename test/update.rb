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
print 'Email address: '
email = gets.chomp
print 'Email address or contact id for search: '
term = gets.chomp
print 'API key: '
api_key = gets.chomp

# creating hash of contact data including the emailtypeid and statusid from Hatchbuck
contact = Hash[
	'firstname' => fname,
	'lastname' => lname,
	'company' => company,
	'email' => email,
	'email_type_id' => 'VmhlQU1pZVJSUFFJSjZfMHRmT1laUmwtT0FMNW9hbnBuZHd2Q1JTdE0tYzE1',
	'status_id' => 'M1BWX2RLc0FITklIMWRjMUUteGJ1ZTJEMEZiU2ktd0hCOUE1NTNUZTgzSTE1'
]

# populating api key
Hatchbuck::Key.set(api_key)

# searching for a contact
# response is either response JSON from API, a string ("not found"), or boolean false (error)
response = Hatchbuck::Contact.search(term)

# testing for validity
if response

	#
	# HANDLING CONTACT NOT FOUND | CREATING ONE
	#
	if response == 'not found'
		puts "Contact not found. Creating it..."
	
		# making API call to Hatchbuck
		response = Hatchbuck::Contact.create(contact)

		# handling response
		# successful creation returns reponse JSON while anything else returns bool false
		if response 
			metadata = JSON.parse(response)
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
		puts "\nContact found:"
		puts "First Name: #{metadata["firstName"]}"
		puts "Last Name: #{metadata["lastName"]}"
		puts "Company: #{metadata["company"]}"
		puts "Email: #{metadata["emails"].first["address"]}"
		puts "Contact ID: #{metadata["contactId"]}"
		puts "\n"

		# updating contact with new data
		response = Hatchbuck::Contact.update(metadata["contactId"], contact)

		metadata = JSON.parse(response)
		puts "\nNew contact data:"
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
