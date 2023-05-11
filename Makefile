watch:
	npx tailwindcss -o static/tailwind.css -i src/style.css --watch

release:
	mkdir -p public
	cp -r static public
	npx tailwindcss -o public/tailwind.css -i src/style.css --minify
