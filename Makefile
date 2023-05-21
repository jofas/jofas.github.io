watch:
	npx tailwindcss -o static/tailwind.css -i src/style.css --watch

.PHONY: static
static:
	mkdir -p public
	cp -r static/* public

release: static
	npx tailwindcss -o public/tailwind.css -i src/style.css --minify
