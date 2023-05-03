OPENSCAD=openscad --hardwarnings --export-format binstl -d $@.dep -o $@ $<

all: \
	airfit.stl \
	backscratcher.stl \
	baggagewheel.stl \
	cableclip.stl \
	cardholder_notext.stl \
	cardholder_part1.stl \
	cardholder_part2.stl \
	cardholder2.stl \
	coins_aed.stl \
	coins_eur.stl \
	geberit.stl \
	hoseclip.stl \
	joycase.stl \
	keychain_cart_coin_notext.stl \
	keychain_cart_coin_part1.stl \
	keychain_cart_coin_part2.stl \
	mixer_opener.stl \
	phoneclamp.stl \
	popcorncover.stl \
	powerdisk.stl \
	rewind_stand_single.stl \
	rewind_stand_left.stl \
	rewind_stand_middle.stl \
	rewind_stand_right.stl \
	silicaholder.stl \
	sodastreamstand.stl \
	tapedispenser.stl \
	trashbagholder.stl \
	wallet.stl \

%.stl: %.scad
	$(OPENSCAD)

%_notext.stl: %.scad
	$(OPENSCAD) -D part=1 -D line1='""' -Dline2='""'

%_part1.stl: %.scad
	$(OPENSCAD) -D part=1

%_part2.stl: %.scad
	$(OPENSCAD) -D part=2

%_part3.stl: %.scad
	$(OPENSCAD) -D part=3

%_part4.stl: %.scad
	$(OPENSCAD) -D part=4

%_part5.stl: %.scad
	$(OPENSCAD) -D part=5

%_part6.stl: %.scad
	$(OPENSCAD) -D part=6

%_part7.stl: %.scad
	$(OPENSCAD) -D part=7

%_part8.stl: %.scad
	$(OPENSCAD) -D part=8

%_part9.stl: %.scad
	$(OPENSCAD) -D part=9

%_part10.stl: %.scad
	$(OPENSCAD) -D part=10

%_part11.stl: %.scad
	$(OPENSCAD) -D part=11

%_part12.stl: %.scad
	$(OPENSCAD) -D part=12

%_part13.stl: %.scad
	$(OPENSCAD) -D part=13

%_part14.stl: %.scad
	$(OPENSCAD) -D part=14

%_part15.stl: %.scad
	$(OPENSCAD) -D part=15

%_part16.stl: %.scad
	$(OPENSCAD) -D part=16

coins_aed.stl: coins.scad
	$(OPENSCAD) -D currency='"AED"'

coins_eur.stl: coins.scad
	$(OPENSCAD) -D currency='"EUR"'

rewind_stand_%.stl: rewind_stand.scad
	$(OPENSCAD) -D print='"$*"'

.PHONY: clean

clean:
	rm -f *.stl
