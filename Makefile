all: containers.html containers_slides.html

containers.html: containers.md
	pandoc -s -o containers.html containers.md

containers_slides.html: containers.md
	pandoc -s --webtex -t slidy -o containers_slides.html containers.md

clean:
	rm -rf containers.html containers_slides.html
