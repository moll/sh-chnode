love:
	@echo "Feel like makin' love."

pack:
	npm pack

publish:
	npm publish

tag:
	git tag "v$$(node -e 'console.log(require("./package").version)')"

clean:
	rm -f *.tgz

.PHONY: love
.PHONY: pack publish tag
.PHONY: clean
