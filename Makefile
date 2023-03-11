# Name of the destination rom, minus the extension
NAME = pooh

text1 = Making memes in
text2 = Photoshop
text3 = Making memes in assembly on
text4 = a 40 year old console

# Assembler and linker paths
CA = ca65
LD = ld65

CAFLAGS = -g -t nes  -l bin/$(NAME).lst
LDFLAGS = -C $(NESCFG) -m bin/$(NAME).nes.map -vm --dbgfile bin/$(NAME).dbg

CHRUTIL = ../go-nes/bin/chrutil
TXT2CHR = ../go-nes/bin/text2chr

# Mapper configuration for linker
NESCFG = nes_mmc1.cfg

# any CHR files included
CHR = pooh.chr \
	  pooh_tux.chr \
	  shine.chr \
	  text1.chr \
	  text2.chr \
	  text3.chr \
	  text4.chr

# List of all the sources files
SOURCES = main.asm nes2header.inc \
		  pooh.i pooh_tux.i

.PHONY: clean default chr cleanall

default: all
all: bin/$(NAME).nes

clean:
	-rm bin/* *.chr *.i

cleanall: clean
	-rm *.bmp

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

shine.chr: shine.bmp
	$(CHRUTIL) -o $@ $< --remove-duplicates

%.chr %.i: %.bmp
	$(CHRUTIL) -o $(basename $@).chr $^ --remove-duplicates --nt-ids $(basename $@).i

text1.chr: font.bmp
	$(TXT2CHR) --input "$(text1)" --chr $@ --metadata $(basename $@).i --font $< --background-color 1
text2.chr: font.bmp
	$(TXT2CHR) --input "$(text2)" --chr $@ --metadata $(basename $@).i --font $< --background-color 1
text3.chr: font.bmp
	$(TXT2CHR) --input "$(text3)" --chr $@ --metadata $(basename $@).i --font $< --background-color 1
text4.chr: font.bmp
	$(TXT2CHR) --input "$(text4)" --chr $@ --metadata $(basename $@).i --font $< --background-color 1

font.bmp: font.aseprite
	aseprite -b $^ --save-as $@

text2.txt: text.bmp
	bmp2chr -o text2.chr -debug text.bmp > text2.txt

bin/:
	mkdir bin

bin/$(NAME).o: $(SOURCES) $(CHR) bin/
	$(CA) $(CAFLAGS) -o $@ $<

bin/$(NAME).nes: bin/$(NAME).o $(NESCFG)
	$(LD) $(LDFLAGS) -o $@ $<
