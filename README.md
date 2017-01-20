This is a very rudimentary gem for interfacing with the Hatchbuck API. The currently supported calls are:

- search for contact by contact id or email address
- create a basic contact record (first/last names, email address)
- add tags to contacts by contact id or email address

Basic usage is as follows:

- Hatchbuck::Contact.search(email [or] contact id)
		returns all metadata about the contact or a boolean false if not found
- Hatchbuck::Contact.create(fname, lname, email)
		returns all metadata about the new contact
- Hatchbuck::Tag.create(email [or] contactid, tag id)
		gives a confirmation of success

Hatchbuck does not allow you to add tags or custom fields on the fly via the API, so you will need to log into the web app and create these things before using them. You will also need to log in to set up tag rules, which are probably the most powerful part of the CRM. Using tag rules, you can set any number of automations in motion upon tagging a contact, which is the only way to accomplish most things via an API.

You will need to go to account settings -> web api -> lookup table keys to find the GUIDs for the required fields:

- email type
- contact status
- tag(s) if applicable
