# Hatchbuck-Ruby 

This is a very rudimentary gem for interfacing with the Hatchbuck API. This is severly under/untested. It should work just fine for basic scripting needs, I haven't even tried it in a Rails app yet, so use at your own risk. 

Required dependencies: JSON and Faraday. 

The currently supported calls are:

- search for contact by contact id or email address
- create a basic contact record (first/last names, email address)
- add tags to contacts by contact id or email address

Basic usage is as follows:

- `Hatchbuck::Key.set('API KEY HERE')` is obviously required
- `Hatchbuck::Contact.search(email [or] contact id)` returns all metadata about the contact or a boolean false if not found
- `Hatchbuck::Contact.create(fname, lname, email)` returns all metadata about the new contact
- `Hatchbuck::Tag.create(email [or] contactid, tag id)` gives a confirmation of success

Hatchbuck does not allow you to add tags or custom fields on the fly via the API, so you will need to log into the web app and create these things before using them. You will also need to log in to set up tag rules, which are probably the most powerful part of the CRM. Using tag rules, you can set any number of automations in motion upon tagging a contact, which is the only way to accomplish most things via an API.

You will need to go to account settings -> web api -> lookup table keys to find the GUIDs for the required fields:

- API key (on first page of web api portal)
- email type
- contact status
- tag(s) if applicable

There's a CLI test in the tests folder if you want to play around with the functionality. 

This is under heavy development. I hope to expand the capabilities by a lot, namely to include things like custom fields, updating contacts, capturing more detailed contact record information, and deleting tags. If I get on a roll, I'll tackle campaign stuff, but honestly, tag rules fill that gap fairly well for now. 
