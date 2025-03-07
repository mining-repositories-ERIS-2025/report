
BUILDIR:=build
FILENAME:=main

pdf: 
	pandoc ./$(FILENAME).md \
	--citeproc \
	--from=markdown+tex_math_single_backslash+tex_math_dollars+raw_tex \
	--to=latex \
	--template=template.tex \
	--output=./$(BUILDIR)/$(FILENAME).pdf \
	--pdf-engine=xelatex \

html:
	mkdir -p build
	pandoc $(FILENAME).md \
	--citeproc \
	--from=markdown+tex_math_single_backslash+tex_math_dollars \
	--to=html5 \
	--output=./$(BUILDIR)/$(FILENAME).html \
	--mathjax \
	--self-contained

install_linux:
	wget https://github.com/jgm/pandoc/releases/download/3.6.3/pandoc-3.6.3-1-amd64.deb
	sudo dpkg -i pandoc-3.6.3-1-amd64.deb
	sudo apt-get install -y texlive-xetex



