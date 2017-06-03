CONV = convert
CONV_FLAGS = -verbose ppm:-
PPMTOBMP = ppmtobmp
PPMTOBMP_FLAGS = -bpp=4

SVG_IMAGES = $(shell ls *.svg)
BMP_IMAGES = $(SVG_IMAGES:.svg=.bmp)

OUT_DIR = "../sd/IMAGES/"

all: outdir ${BMP_IMAGES}

outdir:
	mkdir -p $(OUT_DIR)

%.bmp: %.svg
	$(CONV) "$<" $(CONV_FLAGS) | $(PPMTOBMP) $(PPMTOBMP_FLAGS) > "$(OUT_DIR)/$@"

