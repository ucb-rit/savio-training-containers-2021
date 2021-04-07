all: containers.html containers_slides.html

intro.html: intro.md
	pandoc -s -o containers.html containers.md

intro_slides.html: intro.md
	pandoc -s --webtex -t slidy -o containers_slides.html containers.md

clean:
	rm -rf containers.html containers_slides.html
