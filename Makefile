build:
	tailwindcss -o src/tailwind.css -i src/style.css --watch

release:
	tailwindcss -o src/tailwind.css -i src/style.css --minify
