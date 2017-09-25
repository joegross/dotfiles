SOURCES=brew-head.txt brew-packages.txt brew-cask-packages.txt
BREWFILE=Brewfile

$(BREWFILE): $(SOURCES) Makefile
	cat brew-head.txt > $(BREWFILE)
	for i in $(shell cat brew-packages.txt); do echo brew \"$$i\"; done >> $(BREWFILE)
	for i in $(shell cat brew-cask-packages.txt); do echo cask \"$$i\"; done >> $(BREWFILE)