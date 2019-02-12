use script "ASPashua"
use framework "Foundation"
use scripting additions

-- This script demonstrates form validation and re-displays the entered
-- data, so the user doesn't have to re-enter the data.


-- The form definition. 
-- See the documentation for more options: http://www.bluem.net/pashua-docs-latest.html 
set config_text to "# Pashua dialog config
message.type = text
message.default = Select a country from the list (or enter one below to add it to the list.
country.type = popup
country.label = Country
country_to_add.type = textfield
country_to_add.label = Country to add
cb.type = cancelbutton
db.type = defaultbutton"

set landenlijst to {"UK", "US", "USSR"}
set selected_country to item 1 of landenlijst

try
	repeat
		set val_rec to {|country.option|:landenlijst, country:selected_country}
		set entered_data to display pashua dialog config_text dynamic values val_rec
		set country_to_add to country_to_add of entered_data
		if length of country_to_add > 0 then
			set landenlijst to landenlijst & country_to_add
			set selected_country to country_to_add
		else
			set destination to country of entered_data
			display alert "Hi there!" message "You are going to «" & destination & "»."
			exit repeat
		end if
	end repeat
on error number -128
	display notification "You did not complete the form, and thus will not share in the advantages of our generous offers." with title "Hi there!"
end try
