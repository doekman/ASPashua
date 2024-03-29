NAME=ASPashua
REL_NOT=Release-notes
EXAMPLES=examples
SCRLIB=$(HOME)/Library/Script Libraries/
BUILD=$(CURDIR)/build
PASHUA=/Applications/Pashua.app
LIBSOURCE=$(CURDIR)/$(NAME).scptd
LIBTARGET=$(BUILD)/$(NAME).scptd
BINTARGET=$(LIBTARGET)/Contents/Resources/bin/
embed:=$(shell echo "$${EMBED_PASHUA:-0}")
embed_suffix:=$(shell if [[ $$EMBED_PASHUA = 1 ]]; then echo "-embed"; else echo ""; fi)
lib_ver:=$(shell defaults read "$(LIBSOURCE)/Contents/Info.plist" "CFBundleShortVersionString" | sed 's/[.]/_/g')
zip_file:="$(BUILD)/ASPashua-$(lib_ver)$(embed_suffix).zip"
help:
	@echo "Targets: build, sign, zip, clean, install, uninstall."
	@echo "Setting: embed=${embed}; version=${lib_ver}."
	@echo "Zip-file: $(zip_file)"
build:
	@echo "Building..."
	@if [[ -d "${LIBTARGET}" ]]; then rm -Rf "${LIBTARGET}"; fi
	@cp -Rf "${LIBSOURCE}" "${BUILD}"
	@if [[ ${embed} = "1" ]]; then \
		if [[ -d "${PASHUA}" ]]; then \
			echo "Embedding Pashua.app...";\
			mkdir -p "${BINTARGET}";\
			cp -Rf "${PASHUA}" "${BINTARGET}";\
		else \
			>&2 echo "Can't find /Applications/Pashua.app";\
			exit 1;\
		fi \
	fi
sign: build
	@echo "Signing..."
	@rm "${LIBTARGET}/Contents/Script Debugger.plist"
	@xattr -cr "${LIBTARGET}"
	@codesign --sign "Developer ID Application: D Zanstra (6FMXG4C59Y)" "${LIBTARGET}"
doc: #install requirements via: brew install pandoc; pip3 install weasyprint
	@echo "Building documentation..."
	@cp "${CURDIR}/${REL_NOT}.md" "$(BUILD)"
#@pandoc "${CURDIR}/${REL_NOT}.md" --from=markdown --to=html --standalone --output="$(BUILD)/${REL_NOT}.html"
	@pandoc "${CURDIR}/${REL_NOT}.md" --from=markdown --to=pdf --standalone --output="$(BUILD)/${REL_NOT}.pdf" --pdf-engine=weasyprint
zip: sign
	@echo "Zipping..."
	@cp -R "$(CURDIR)/$(EXAMPLES)" "$(BUILD)"
	@if [[ -f $(zip_file) ]]; then \
		echo "- removing old zip-file";\
		rm -f $(zip_file);\
	fi
	@cd build;zip -r "$(zip_file)" "./$(NAME).scptd" "./$(REL_NOT)".pdf "./$(EXAMPLES)"
clean:
	@echo "Cleaning..."
	@if [[ -d "${BUILD}" ]]; then rm -Rf "${BUILD}"; fi
	@if [[ ! -d "${BUILD}" ]]; then mkdir "${BUILD}"; fi
install: sign uninstall
	@echo "Installing..."
	@cp -Rf "${LIBTARGET}" "${SCRLIB}"
uninstall:
	@echo "Uninstalling..."
	@if [[ -d "${SCRLIB}/${NAME}.scptd" ]]; then rm -Rf "${SCRLIB}/${NAME}.scptd"; fi
.PHONY: help build clean install uninstall
