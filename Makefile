PREFIX = /usr/local

love:
	@echo "Feel like makin' love."

install:
	mkdir -p "$(PREFIX)/bin"
	install -m 755 chnode.sh "$(PREFIX)/bin/chnode"

pack:
	@file=$$(npm pack); echo "$$file"; tar tf "$$file"

publish:
	npm publish

tag:
	git tag "v$$(node -e 'console.log(require("./package").version)')"

clean:
	rm -f *.tgz

.PHONY: love
.PHONY: install pack publish tag
.PHONY: clean
