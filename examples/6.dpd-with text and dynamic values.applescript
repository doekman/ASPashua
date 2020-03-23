use script "ASPashua"
use scripting additions

-- This script demonstrates form validation and re-displays the entered
-- data, so the user doesn't have to re-enter the data.

on validate_data(entered_data)
	if email of entered_data does not contain "@" then
		return "Please enter a valid email address."
	end if
	try
		set age_int to (age of entered_data) as integer
		if age_int < 21 then
			return "Sorry, you are too young. Ask a grown up to fill out this form."
		end if
	on error err_msg number err_nr
		return "Please enter a valid age"
	end try
	if agree of entered_data is not "1" then
		return "You need to agree with our policy."
	end if
	return ""
end validate_data

-- The form definition. 
-- See the documentation for more options: http://www.bluem.net/pashua-docs-latest.html 
set config_text to "# Pashua dialog config
message.type = text
message.default = Please complete the form
name.type = textfield
name.label = First & Last Name
name.mandatory = true
email.type = textfield
email.label = Email Address
email.mandatory = true
age.type = textfield
age.label = Age
age.mandatory = true
agree.type = checkbox
agree.label = Do You Agree Evading Your Privacy?
cb.type = cancelbutton
db.type = defaultbutton"

try
	set entered_data to display pashua dialog config_text
	set error_message to validate_data(entered_data)
	
	repeat until error_message = ""
		set dyn_val to entered_data & {message:"Error encountered:" & return & "* " & error_message}
		set entered_data to display pashua dialog config_text dynamic values dyn_val
		set error_message to validate_data(entered_data)
	end repeat
	
	display notification "With your consent, you will be spammed at " & email of entered_data & "." with title "Hello " & |name| of entered_data
on error number -128
	display notification "You did not complete the form, and thus will not share in the advantages of our generous offers." with title "Hello anonymous"
end try