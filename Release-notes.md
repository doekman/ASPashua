Release notes ASPashua
======================

These are the release notes of [ASPashua](https://github.com/doekman/ASPashua).


Installation
------------

To use this library, install it in one of the _Script Libraries_ folders.

To do this:

* In Finder, type command+shift+G (or from the menu: Go > Go to folder...)
* As a value, type `~/Library` and press enter
* Now choose the sub-folder `Script Libraries`
	- if it doesn't exist, you can created it with command+shift+N (or from the menu: Archive > New folder...)
* As a final step, move `ASPashua.scptd` to this folder

Now you can run the supplied examples.


Version 0.5dev
--------------

Unreleased; changes:

* Made a workaround for a bug in Pashua, where you paste multiple lines into a `textfield`.
* Added a PDF version of the release notes to the release zip-file.
* Fixed naming issue with archives:
	- When Safari uncompresses `ASPashua-0.4-embed.zip` or `ASPashua-0.4.zip`, it will name the resulting folder as `ASPashua-0`. The period (`.`) in the version number is replaced by an underscore (`_`), producing `ASPashua-0_5-embed.zip` and `ASPashua-0_5.zip`.


Version 0.4
-----------

Released 2020-03-26; changes:

* multiple line support for `dynamic values`. New lines will automatically be translated to `[return]` and vice versa.
* description in the Dictionary is more detailed now


Version 0.3
-----------

Released 2020-02-12; changes:

* Initial public release

<style>
	code {
		font-size:80%;
	}
</style>
