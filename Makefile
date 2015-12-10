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

###############################################################################

TARGETS=LArSoftArchitecture

###############################################################################
### Program paths
###
LATEXMK:=latexmk

LATEXMK_BASEOPT=--recorder --outdir="$(OutDir)"

TEXINPUTS+=classes/:sources/:

###############################################################################
### Targets
###

.PHONY: all pdf html clean distclean preview FORCE

all: pdf

pdf: $(TARGETS:%=$(OutDir)%.pdf)

clean: $(TARGETS:%=%.clean)
	$(RM) "$(TmpDir)"*

distclean: $(TARGETS:%=%.distclean)

%.distclean:
	$(LATEXMK) -C $(LATEXMK_BASEOPT) "$(SrcDir)/$(*).tex"
	$(RM) "$(OutDir)$(*).pdf"

%.clean:
	$(LATEXMK) -c $(LATEXMK_BASEOPT) "$(SrcDir)/$(*).tex"

$(OutDir)%.pdf: FORCE
	$(LATEXMK) $(LATEXMK_BASEOPT) --pdf "$(SrcDir)/$(*).tex"

FORCE:

debug:
	@echo "Targets: $(TARGETS)"
