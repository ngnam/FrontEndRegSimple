build:
	npm run server-build
	npm run client-build
	mv client/build dist/client
	cp -r server/src/html-templates dist/server/html-templates
