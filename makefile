
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
