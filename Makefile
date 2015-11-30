#
# Makefile for LArSoft architecture document
#
# Currently compiles from a text file using pandoc
#

#######################################################################
TARGETS:=LArSoftArchitecture

FORMATS:=pdf html textile # tex odt doc

IMAGEFORMATS:=pdf png
IMAGESOURCEFORMATS=dot neato
IMAGES:=$(foreach Format,$(IMAGESOURCEFORMATS),$(patsubst %.$(Format),%,$(wildcard *.$(Format))))

#######################################################################
### program paths
PANDOC:=pandoc
PANDOCOPT:=--standalone --table-of-contents

#######################################################################
### Supporting variables

ALLIMAGES:=$(foreach Format,$(IMAGEFORMATS),$(IMAGES:%=%.$(Format)))

#######################################################################
.PHONY: all $(FORMATS) pics debug clean distclean cleanpics # $(IMAGEFORMATS:%=%.pics)

all: $(FORMATS) pics

# this is getting complicate...
# there are multiple targets here; for each of the FORMATS,
# the rule is that to make it (plain) we need all targets with that format;
# so "pdf" will become $(TARGETS:=.pdf); it would be like % : $(TARGETS:=.$(@)),
# but the substitution of $@ does not work in this context
$(FORMATS) : % : $(TARGETS:=.%)

clean: $(TARGETS:=.clean) cleanpics

distclean: $(TARGETS:=.distclean) cleanpics

cleanpics:
	$(RM) $(ALLIMAGES)

# this is getting even more complicate...
# there are multiple targets here; for each of the FORMATS, build a %.ext target
$(FORMATS:%=\%.%) : %.txt pics
	$(PANDOC) $(PANDOCOPT) -o "$@" "$<"

$(IMAGEFORMATS:=.pics): %.pics: $(IMAGES:=.%)

pics: $(IMAGEFORMATS:%=%.pics)

%.clean: cleanpics
	$(RM) "$(*).log" "$(*).aux"

%.cleanpics:
	$(RM) $(IMAGES:=.$(*))

%.distclean: %.clean
	$(RM) $(FORMATS:%=$(*).%)

%.pdf: %.dot
	dot -Tpdf -o"$@" "$<"

%.png: %.dot
	dot -Tpng -o"$@" "$<"

%.pdf: %.neato
	neato -Tpdf -o"$@" "$<"

%.png: %.neato
	neato -Tpng -o"$@" "$<"

LArSoftArchitecture.pdf: pdf.pics

debug:
	@echo "Images: $(IMAGES)"
