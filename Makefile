create-public-dir:
	mkdir -p public

watch: create-public-dir
	npx tailwindcss -i src/style.css -o public/tailwind.css --watch &
	ls static/* | entr make static

.PHONY: static
static: create-public-dir
	cp -r static/* public

release: static
	npx tailwindcss -i src/style.css -o public/tailwind.css --minify