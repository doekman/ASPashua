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

-- Get the path to the current folder, and create an alias for the mentioned file
set script_path to (path to me as text) & "::"
set config_file_name to "5.dpd-with file and dynamic values.pashua"
set config_file to alias (script_path & config_file_name)

try
	set entered_data to display pashua dialog config_file
	set error_message to validate_data(entered_data)
	
	repeat until error_message = ""
		set dyn_val to entered_data & {message:"Error encountered:[return]* " & error_message}
		set entered_data to display pashua dialog config_file dynamic values dyn_val
		set error_message to validate_data(entered_data)
	end repeat
	
	display notification "With your consent, you will be spammed at " & email of entered_data & "." with title "Hello " & |name| of entered_data
on error number -128
	display notification "You did not complete the form, and thus will not share in the advantages of our generous offers." with title "Hello anonymous"
end try