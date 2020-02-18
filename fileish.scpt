#@osa-lang:AppleScript
use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions


script Fileish
	-- Current working folder, used to resolve relative path's like "./file.ext"
	property working_folder : POSIX path of (path to home folder)

	on get_type(fileish_specifier)
		if class of fileish_specifier is text then
			if fileish_specifier starts with "/" then
				return "posix_abs_path"
			else if fileish_specifier starts with "./" or fileish_specifier starts with "~/" then
				return "posix_rel_path"
			end if
		else if class of fileish_specifier is alias then
			return "alias"
		else if class of fileish_specifier is file then
			return "file"
		else if class of fileish_specifier is «class furl» then
			return "posix_file"
		end if
		log "Unknown fileish type: " & class of fileish_specifier
		return "unknown"
	end get_type

	on to_posix(fileish_specifier)
		local fileish_type
		set fileish_type to fileish_get_type(fileish_specifier)

	end to_posix

	on is_fileish(fileish_specifier)
		return fileish_get_type(fileish_specifier) ≠ "unknown"
	end is_fileish

end script
--set ding to choose file
--set ding to POSIX file "/Users/doeke/prj/GitHub/ASPashua/makefile"
--set ding to "~/prj/GitHub/ASPashua/makefile"
set ding to "./prj/GitHub/ASPashua/makefile"
--set ding to "/Users/doekman/prj/GitHub/ASPashua/makefile"
--get is_fileish(ding)
set working_folder of Fileish to "/Users/doeke/Downloads/intranet"
get working_folder of Fileish
