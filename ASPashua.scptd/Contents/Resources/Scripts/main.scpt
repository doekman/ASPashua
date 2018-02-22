#@osa-lang:AppleScript
use AppleScript version "2.4"
use scripting additions
use framework "Foundation"

--» 1. Public handlers

on «event PASHCMPL» new_path
	global pashua_binary

	set new_path to to_alias(new_path)
	tell application "Finder"
		if not (new_path exists) then
			error "New path to Pashua.app does not exist" number 1003 from new_path
		end if
	end tell
	set pashua_binary to (POSIX path of new_path) & "Contents/MacOS/Pashua"
end «event PASHCMPL»

on «event PASHDIDI» config
	local result_lines, record_result

	set result_lines to _call_pashua("display pashua dialog", config)
	set record_result to _ini_to_dictionary(result_lines)
	return record_result as record
end «event PASHDIDI»


--» 2. Private handlers

--| Call to show a Pashua dialog
--| api_name: just a string, used for logging (so the user can see where the call came from)
--| config: text or file/alias
--| returns: a record
on _call_pashua(api_name, config)
	local pashua_cmd, pashua_res, result_lines
	-- Get path to Pashua binary
	set pashua_binary to _get_pashua_posix_path()

	-- Call with either text or alias
	if class of config is text then
		set pashua_cmd to "echo " & quoted form of config & " | " & quoted form of pashua_binary & " -"
	else if class of config is alias then
		set pashua_cmd to quoted form of pashua_binary & space & quoted form of POSIX path of config
	else
		error "Call this method with either 'text' of 'alias', not with '" & (class of config) & "'" number 1000
	end if

	-- Call pashua
	set pashua_res to do_shell_with_log(api_name, pashua_cmd)

	set result_lines to split_string(pashua_res, return)

	-- There was an error in the config (for example the following line: "x=y")
	--or there were no inputs and no buttons defined, and the (implicit defined) default button was pressed
	--or the red [x] close button was pressed with no cancel button was defined
	--or gave up (autoclosetime) without cancel button defined
	if (count of result_lines) is 0 then error "It looks like Pashua.app had some problems using the window configuration (no text lines were returned)." number 1001

	-- User pressed cancel
	-- or only one input/button is defined
	if (count of result_lines) is 1 then error number -128 --user canceled

	return result_lines
end _call_pashua

--| Parses Pashua's output to a NSDictionary (which can be converted to an AppleScript record)
on _ini_to_dictionary(ini_lines as list)
	local result_dictionary, pos, key_string, value_string
	set number_of_lines to count of ini_lines
	set result_dictionary to current application's NSMutableDictionary's dictionaryWithCapacity:number_of_lines
	repeat with text_line in ini_lines
		set {key_string, value_string} to _parse_pashua_result_line(text_line)
		(result_dictionary's setValue:value_string forKey:key_string)
	end repeat
	return result_dictionary
end _ini_to_dictionary

on _parse_pashua_result_line(result_line)
	set pos to offset of "=" in result_line
	set key_string to text 1 thru (pos - 1) of result_line
	if (count of result_line) ≤ pos then
		set value_string to "" --use empty string, because missing value won't show up in record
	else
		set value_string to text (pos + 1) thru (length of result_line) of result_line
	end if
	return {key_string, value_string}
end _parse_pashua_result_line


--» 3. Generic utility handlers (list/string/alias/log

to join_list(aList as list, delimiter as text)
	local sourceList, res
	set the sourceList to current application's NSArray's arrayWithArray:aList
	set res to sourceList's componentsJoinedByString:delimiter
	return res as text
end join_list

to split_string(aString as text, delimiter as text)
	local sourceString, res
	if aString is "" then return {} --special case
	set the sourceList to current application's NSString's stringWithString:aString
	set res to sourceList's componentsSeparatedByString:delimiter
	return res as list
end split_string

on replace_text(searchString as text, replacementString as text, sourceText)
	local sourceString, adjustedString
	if sourceText is missing value then
		return sourceText
	end if
	set the sourceString to current application's NSString's stringWithString:sourceText
	set the adjustedString to the sourceString's stringByReplacingOccurrencesOfString:searchString withString:replacementString
	return adjustedString as text
end replace_text

--| Make sure the argument (file, alias, text) is always returned as an alias.
--| Text can be POSIX format (/Path/to/file.txt) or HFS+ format (Computer:Path:to:file.txt)
on to_alias(file_path)
	if class of file_path is text then
		if file_path starts with "/" then
			set file_path to (POSIX file file_path) as alias
		else
			set file_path to file_path as alias
		end if
	else if class of file_path is file then
		set file_path to file_path as alias
	end if

	return file_path
end to_alias

--| Executes a shell command, and logs before and after
on do_shell_with_log(title, command)
	do_log(title & " COMMAND [" & command & "]")
	try
		set shell_result to do shell script command
		do_log(title & " RESULT [" & shell_result & "]")
	on error err_msg number err_nr
		do_log(title & " RESULT, EXIT CODE " & err_nr & ", error message [" & err_msg & "]")
		error error_msg number err_nr
	end try
	return shell_result
end do_shell_with_log

--| Log a line of text to ~/Library/Logs/Catsdeep/ASPashua.log
on do_log(log_message)
	if _do_log_to_file() then
		set log_folder to "~/Library/Logs/Catsdeep"
		set q_msg to quoted form of log_message
		set cmd to "D=" & log_folder & ";M=" & q_msg & "; [ ! -d $D ] && mkdir -p $D; echo $(date -u): \"$M\" >> $D/ASPashua.log 2>&1"
		do shell script cmd
	end if
end do_log


--» 4. "Property getters" (stored in global variables, with initialization code)

global pashua_binary
global log_to_file

on _get_pashua_posix_path()
	global pashua_binary
	try
		return pashua_binary
	on error number -2753 --The variable <pashua_path> is not defined
		-- look for a reference to the Pashua binary
		try
			--TODO: fix this, depends on "show extension" setting of Finder
			set app_location to path to resource "Pashua.app" in directory "bin" as text
			return (POSIX path of app_location) & "Contents/MacOS/Pashua"
		on error number -192 --A resource wasn’t found.
			repeat with pashua_location in [path to applications folder from user domain, path to applications folder from local domain]
				set app_location to (pashua_location as text) & "Pashua.app:"
				tell application "Finder"
					if alias app_location exists then
						set pashua_binary to (my POSIX path of alias app_location) & "Contents/MacOS/Pashua"
						return pashua_binary
					end if
				end tell
			end repeat
		end try
		error "Can't locate the path of Pashua.app. Download it from http://www.bluem.net/files/Pashua.dmg and save it in the 'Applications' folder." number 1002
	end try
end _get_pashua_posix_path

on _do_log_to_file()
	global log_to_file
	try
		return log_to_file
	on error number -2753 --The variable <log_to_file> is not defined:
		try
			set log_to_file to (do shell script "defaults read com.catsdeep.ASPashua do_log") is "1"
		on error number 1
			set log_to_file to false
		end try
	end try
	return log_to_file
end _do_log_to_file
