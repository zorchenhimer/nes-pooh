export PATH := $(PATH):../tools/cc65/bin:/c/code/golang/src/github.com/zorchenhimer/bmp2chr/cmd:/c/Program Files/Aseprite/

# Assembler and linker paths
CA = ca65
LD = ld65

# Mapper configuration for linker
NESCFG = nes_000.cfg

# any CHR files included
CHR = pooh.chr pooh_tux.chr

# Name of the destination rom, minus the extension
NAME = pooh

# List of all the sources files
SOURCES = main.asm nes2header.inc \
		  pooh.chr \
		  pooh_tux.chr \
		  text.asm \
		  text.chr.ids.asm \
		  font.asm

# misc
RM = rm

.PHONY: clean default chr

default: all
all: bin/$(NAME).nes

clean:
	-$(RM) bin/*.*
	-$(RM) *.chr
	-$(RM) font.chr.bin.asm
	-$(RM) tux_shine.txt

pooh.chr: pooh_color.bmp
	bmp2chr -o pooh.chr pooh_color.bmp

pooh_tux.chr: pooh_tux.bmp
	bmp2chr -o pooh_tux.chr pooh_tux.bmp

tux_shine.txt: tux_shine.bmp
	bmp2chr -o shine.chr -debug tux_shine.bmp > tux_shine.txt

text2.txt: text.bmp
	bmp2chr -o text2.chr -debug text.bmp > text2.txt

bin/:
	mkdir bin

bin/$(NAME).o: bin/ $(SOURCES) $(CHR)
	$(CA) -g \
		-t nes \
		-o bin/$(NAME).o\
		-l bin/$(NAME).lst \
		main.asm

bin/$(NAME).nes: bin/$(NAME).o $(NESCFG)
	$(LD) -o bin/$(NAME).nes \
		-C $(NESCFG) \
		-m bin/$(NAME).nes.map -vm \
		-Ln bin/$(NAME).labels \
		--dbgfile bin/$(NAME).dbg \
		bin/$(NAME).o
