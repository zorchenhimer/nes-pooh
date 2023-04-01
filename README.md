# pooh.nes

Photoshop is for plebs.

## Building

Requirements:
- GNU Make
- [cc65](https://github.com/cc65/cc65)
- [Golang](https://go.dev/) (to build go-nes)
- [Aseprite](https://www.aseprite.org/) (optional)

```
$ git clone --recurse-submodules https://github.com/zorchenhimer/nes-pooh.git
$ cd nes-pooh && make
```

After the above commands you should have `bin/pooh.nes`.  This ROM can then be
loaded up in an emulator or dropped on a romcart to run on hardware.

### Changing the text

Change the text1, text2, text3, and text4 variables in the Makefile then
rebuild with `make clean && make`.  Just running `make` isn't enough.

## Buttons

Swap screens with the A button.  Toggle drawing with the start button.

## Aseprite

The images used were made using Aseprite which a paid program.  The exported
bitmaps have been included in this repository to avoid requiring this program
to build the ROM.  Note that the `make cleanall` command will delete the
bitmaps to trigger re-exporting them using Aseprite.  If this is done in error,
simply use git to restore the images: `git checkout -- *.bmp`.
