NAME=ASPashua
SCRLIB=$(HOME)/Library/Script Libraries/
BUILD=$(CURDIR)/build
PASHUA=/Applications/Pashua.app
LIBSOURCE=$(CURDIR)/$(NAME).scptd
LIBTARGET=$(BUILD)/$(NAME).scptd
BINTARGET=$(LIBTARGET)/Contents/Resources/bin/
EMBED:=$(shell defaults read com.catsdeep.ASPashua embed 2> /dev/null  || echo "0")
build:
	@echo "Building..."
	@if [[ -d "${LIBTARGET}" ]]; then rm -Rf "${LIBTARGET}"; fi
	@if [[ ! -d "${BUILD}" ]]; then mkdir "${BUILD}"; fi
	@cp -Rf "${LIBSOURCE}" "${BUILD}"
	@if [[ ${EMBED} = "1" ]]; then \
		if [[ -d "${PASHUA}" ]]; then \
			echo "Embedding Pashua.app...";\
			mkdir -p "${BINTARGET}";\
			cp -Rf "${PASHUA}" "${BINTARGET}";\
		else \
			echo "Can't find /Applications/Pashua.app";\
			exit 1;\
		fi \
	fi
clean:
	@echo "Cleaning..."
	@if [[ -d "${BUILD}" ]]; then rm -Rf "${BUILD}"; fi
install: build uninstall
	@echo "Installing..."
	@cp -Rf "${LIBTARGET}" "${SCRLIB}"
uninstall:
	@echo "Uninstalling..."
	@if [[ -d "${SCRLIB}/${NAME}.scptd" ]]; then rm -Rf "${SCRLIB}/${NAME}.scptd"; fi
.PHONY: build clean install uninstall
