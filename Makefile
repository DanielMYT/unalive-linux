all:
	@echo "Run 'make install' to install Unalive Linux."

install:
	install -t "$(DESTDIR)/etc/profile.d" -Dm644 unalive-linux.sh
	install -t "$(DESTDIR)/etc/polkit-1/rules.d" -Dm644 99-unalive-linux.rules
	@echo "WARNING: UNALIVE LINUX HAS NOW BEEN INSTALLED!"
	@echo "WARNING: YOUR SYSTEM MAY BECOME TOTALLY DESTROYED!"
	@echo "WARNING: TO UNDO THIS ACTION, RUN 'make uninstall' RIGHT NOW!"
	@echo "WARNING: UNALIVE LINUX WILL BE ACTIVE ON NEXT LOGIN!"
	@echo "WARNING: YOU HAVE BEEN WARNED!!!"

uninstall:
	rm -f "$(DESTDIR)/etc/profile.d/unalive-linux.sh"
	rm -f "$(DESTDIR)/etc/polkit-1/rules.d/99-unalive-linux.rules"
	@echo "WARNING: UNALIVE LINUX HAS BEEN UNINSTALLED!"
	@echo "WARNING: YOU MUST LOG BACK IN TO ENSURE IT'S NO LONGER ACTIVE!"
	@echo "WARNING: UNTIL THEN, UNALIVE LINUX MAY STILL DESTROY YOUR OS!"
	@echo "WARNING: YOU HAVE BEEN WARNED!!!"
