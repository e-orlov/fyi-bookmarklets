#!/usr/bin/make -f

##
# FYI PROJECT
PROJ := fyi-bookmarklets

# directories/paths
BUILD := build
LOCALLIB := lib
COMMONLIB := $$HOME/common/lib
VPATH := web:$(BUILD)

# files
PROJWEB := web/fyi-firefox.js web/fyi-ie.js web/fyi-webkit.js
README = README.md
VERSIONTXT = src/VERSION.txt

# macros/utils
YUILCOMPRESSORPATH := $(shell [ 'cygwin' = "$$OSTYPE" ] &&  echo "`cygpath -w $(COMMONLIB)`\\" || echo "$(COMMONLIB)/")
YUICOMPRESSOR := $(shell type -p yuicompressor || echo "java -jar '$(YUILCOMPRESSORPATH)yuicompressor-2.4.7.jar'")
COMPRESSOPTIONS := --type js --nomunge --disable-optimizations
MAKEBOOKMARK := $(LOCALLIB)/process-js2bookmarkURI.js
VERSION := $(shell head -n 1 $(VERSIONTXT))

.PHONY: $(BUILD) web deploy clean

default: $(PROJWEB) $(README) | $(BUILD) web
	@echo 'make $(PROJ): Done.'; echo

# update README with pastelet URLS just built
$(README): $(VERSIONTXT) | $(PROJWEB)
	@echo 'Updating README...'
	@perl -pi -e 'BEGIN{open F,"web/fyi-webkit.js";@f=<F>}s#javascript:.*(?=\" title=\"fyi-webkit( |\"))#@f#g;' $@
	@perl -pi -e 'BEGIN{open F,"web/fyi-firefox.js";@f=<F>}s#javascript:.*(?=\" title=\"fyi-firefox\")#@f#g;' $@
	@perl -pi -e 'BEGIN{open F,"web/fyi-ie.js";@f=<F>}s#javascript:.*(?=\" title=\"fyi-ie\")#@f#g;' $@
	@perl -pi -e 's/&body/&amp;body/g;s/&&/&amp;&amp;/g;' $@

# run jshint then prepend with 'javascript:' and encodeURI (preserving Firefox '%s' token)
web/%.js: $(BUILD)/%.js | $(BUILD) web
	@echo "Make bookmark  $(notdir $@)"
	@node $(MAKEBOOKMARK) $^ | perl -pe "s/\%22/'/g;s/void%20/void/g;s/;$$//g;" | tr -d "\n" > $@
ifeq ($(@F),fyi-firefox.js)
	@perl -pe 's/:\%25s\?/:%s?/;' < $@ > $@
endif
	@echo

# uncomment '.SECONDARY' rule below to retain contents of $(BUILD)
#.SECONDARY: $(BUILD)/fyi-firefox.js $(BUILD)/fyi-ie.js $(BUILD)/fyi-webkit.js

# replace tokens & minify JavaScript
$(BUILD)/%.js: src/%.js $(VERSIONTXT) | $(BUILD)
	@echo "Check source   $(notdir $<)"
	@jshint $<
	@echo "Replace tokens $(notdir $<)"
	@perl -pe "s/void'/void'$(VERSION)/g;" < $< > $@.tmp
	@echo "Compress code  $(notdir $@)"
	@$(YUICOMPRESSOR) $(COMPRESSOPTIONS) -o $@ $@.tmp
	@jshint $@
	@rm -f $@.tmp

# make directories
$(BUILD) web:
	@[ -d $@ ] || mkdir -m 744 $@

deploy: default
	@echo 'make $(PROJ): Commit changes. Then do- git checkout gh-pages && make deploy && git checkout master'

clean:
	@echo 'make $(PROJ): Cleaning build directory and web directory...'
	@rm -Rf $(BUILD) web
