export PATH := $(PATH):../tools/cc65/bin:/c/code/golang/src/github.com/zorchenhimer/bmp2chr/cmd:/c/Program Files/Aseprite/

# Name of the destination rom, minus the extension
NAME = pooh

# Assembler and linker paths
CA = ca65
LD = ld65

CAFLAGS = -g -t nes  -l bin/$(NAME).lst
LDFLAGS = -C $(NESCFG) -m bin/$(NAME).nes.map -vm --dbgfile bin/$(NAME).dbg

CHRUTIL = ../go-nes/bin/chrutil

# Mapper configuration for linker
NESCFG = nes_mmc1.cfg

# any CHR files included
CHR = pooh.chr \
	  pooh_tux.chr \
	  shine.chr \
	  meme-text.chr

# List of all the sources files
SOURCES = main.asm nes2header.inc \
		  pooh.chr \
		  pooh_tux.chr \
		  text.asm \
		  text.chr.ids.asm \
		  font.asm

.PHONY: clean default chr cleanall

default: all
all: bin/$(NAME).nes

clean:
	-rm bin/* *.chr *.i

cleanall: clean
	-rm *.bmp

#pooh.chr: pooh_color.bmp
#	bmp2chr -o pooh.chr pooh_color.bmp
#
#pooh_tux.chr: pooh_tux.bmp
#	bmp2chr -o pooh_tux.chr pooh_tux.bmp

shine.bmp: pooh.aseprite
	aseprite -b $< \
		--layer Tux_Sprite \
		--save-as $@

pooh_tux.bmp: pooh.aseprite
	aseprite -b $< \
		--layer Tux_Color \
		--layer Tux_Lines \
		--save-as $@

pooh.bmp: pooh.aseprite
	aseprite -b $< \
		--layer NoTux_Color \
		--layer NoTux_Lines \
		--save-as $@

meme-text.chr: meme-text.bmp
	$(CHRUTIL) -o $@ $<

shine.chr: shine.bmp
	$(CHRUTIL) -o $@ $< --remove-duplicates

%.chr %.i: %.bmp
	$(CHRUTIL) -o $(basename $@).chr $^ --remove-duplicates --write-ids $(basename $@).i

#shine.i: shine.chr
#shine.chr: tux_shine.bmp
#	$(CHRUTIL) -o $@ $^ --remove-empty --remove-duplicates --write-ids $(basename $@).i

#tux_shine.txt: tux_shine.bmp
#	bmp2chr -o shine.chr -debug tux_shine.bmp > tux_shine.txt

meme-text.bmp: meme-text.aseprite
	aseprite -b $^ --crop 0,0,128,32 --save-as $@

text2.txt: text.bmp
	bmp2chr -o text2.chr -debug text.bmp > text2.txt

bin/:
	mkdir bin

bin/$(NAME).o: $(SOURCES) $(CHR) bin/
	$(CA) $(CAFLAGS) -o $@ $<

bin/$(NAME).nes: bin/$(NAME).o $(NESCFG)
	$(LD) $(LDFLAGS) -o $@ $<
