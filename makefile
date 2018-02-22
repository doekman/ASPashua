NAME=ASPashua
SCRLIB=$(HOME)/Library/Script Libraries/
.PHONY: install uninstall
install: $(NAME).scptd
	@cp -Rf "${CURDIR}/$(NAME).scptd" "$(SCRLIB)"
uninstall:
	@if [[ -d "$(SCRLIB)/$(NAME).scptd" ]]; then\
		 rm -Rf "$(SCRLIB)/$(NAME).scptd";\
	fi
