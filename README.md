ASPashua
========

This AppleScript Library tries to make it convenient to use [Pashua][] with AppleScript for enhanced dialogs.


Prerequisites
-------------

**NOTICE**: you need to have [osagitfilter][] installed, before cloning this repository locally.

You need to have [Pashua][] installed on your system, since this library is a wrapper for that application.


Using
-----

To use this AppleScript Library, run `make install` from the command line. After this, you can open and run the included examples.

To create your own code, first you need to create a [form configuration][pashua-config], either as text-string or in a seperate file. Then you can display the form with `display pashua dialog` which returns a `record` with the entered values.


Settings
--------

To enable the logging, run the following on the command line:

	defaults write com.catsdeep.ASPashua do_log -bool TRUE

To instruct `make install` to embed `Pashua.app` into the built target, execute:

	defaults write com.catsdeep.ASPashua embed -bool TRUE

This will log the input and output of the _Pashua.app_-call to the log file `~/Library/Logs/Catsdeep/ASPashua.log`. The file can be easily inspected with macOS' _Console.app_.

Inspect settings:

	defaults read com.catsdeep.ASPashua

Revert settings to default:

	defaults delete com.catsdeep.ASPashua
	

[osagitfilter]: https://github.com/doekman/osagitfilter
[Pashua]: https://www.bluem.net/en/projects/pashua/
[pashua-config]: https://www.bluem.net/pashua-docs-latest.html
