all: index.html #index.pdf

index.html: index.md
	pandoc -t revealjs index.md -o index.html -s --slide-level 2 --template=pandoc-templates/default.revealjs --highlight-style=zenburn --self-contained

index.pdf: index.md
	pandoc -t beamer index.md -o index.pdf -s --self-contained
