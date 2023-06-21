create-public-dir:
	mkdir -p public

watch: create-public-dir
	npx tailwindcss -o public/tailwind.css -i src/style.css --watch=always &
	ls static/* | entr make static

.PHONY: static
static: create-public-dir
	cp -r static/* public

release: static
	npx tailwindcss -o public/tailwind.css -i src/style.css --minify
