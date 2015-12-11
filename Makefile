###############################################################################
#
# Manages the production of output from LaTeX sources
# using latexmk .
#

###############################################################################
### Directories
###
SrcDir:=sources/
TmpDir:=tmp/
OutDir:=output/
FigDir:=figures/

###############################################################################

TARGETS=LArSoftArchitecture

FIGURESOURCEFORMATS=dot neato
FIGURES=$(foreach Format,$(FIGURESOURCEFORMATS),$(patsubst $(SrcDir)figures/%.$(Format),%,$(wildcard $(SrcDir)figures/*.$(Format))))

FigureFormats:=pdf

###############################################################################
### Program paths
###
LATEXMK:=latexmk

LATEXMK_BASEOPT=--recorder --outdir="$(OutDir)"

TEXINPUTS+=classes/:sources/:

DOT=dot
NEATO=neato

###############################################################################
### Targets
###

.PHONY: all pdf html clean distclean preview figures FORCE

all: pdf

pdf: pdf.figures $(TARGETS:%=$(OutDir)%.pdf)

clean: $(TARGETS:%=%.clean)
	$(RM) "$(TmpDir)"*

figures: $(FigureFormats:%=%.figures)

distclean: $(TARGETS:%=%.distclean)

%.distclean:
	$(LATEXMK) -C $(LATEXMK_BASEOPT) "$(SrcDir)/$(*).tex"
	$(RM) "$(OutDir)$(*).pdf"

%.clean:
	$(LATEXMK) -c $(LATEXMK_BASEOPT) "$(SrcDir)/$(*).tex"

$(FigureFormats:%=%.figures): %.figures: $(FIGURES:%=$(FigDir)%.%)

# figures
$(FigDir)%.pdf: $(SrcDir)figures/%.dot
	$(DOT) -Tpdf -o"$@" "$^"

$(FigDir)%.pdf: $(SrcDir)figures/%.neato
	$(NEATO) -Tpdf -o"$@" "$^"

# documents
$(OutDir)%.pdf: FORCE
	$(LATEXMK) $(LATEXMK_BASEOPT) --pdf "$(SrcDir)/$(*).tex"

FORCE:

debug:
	@echo "Targets: $(TARGETS)"
	@echo "Figures: $(FIGURES)"

latexdep:
	@echo "An incomplete list of packaged used by this document:"
	@find -name "*.sty" -or -name "*.cls" -or -name "*.tex" | xargs grep -h -F '\usepackage' | sed -e 's/.*\usepackage *\(\[.*\]\)\? *{\(.*\)}.*/\2/' | grep -v usepackage | sort -u