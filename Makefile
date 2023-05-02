OPENSCAD:=openscad --hardwarnings

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
	phoneclamp.stl \
	popcorncover.stl \
	powerdisk.stl \
	rewind_stand_single.stl \
	rewind_stand_left.stl \
	rewind_stand_middle.stl \
	rewind_stand_right.stl \
	silicaholder.stl \
	tapedispenser.stl \
	trashbagholder.stl \
	wallet.stl \

%.stl: %.scad
	$(OPENSCAD) --export-format binstl -o $@ $<

%_notext.stl: %.scad
	$(OPENSCAD) -D part=1 -D line1='""' -Dline2='""' --export-format binstl -o $@ $<

%_part1.stl: %.scad
	$(OPENSCAD) -D part=1 --export-format binstl -o $@ $<

%_part2.stl: %.scad
	$(OPENSCAD) -D part=2 --export-format binstl -o $@ $<

%_part3.stl: %.scad
	$(OPENSCAD) -D part=3 --export-format binstl -o $@ $<

%_part4.stl: %.scad
	$(OPENSCAD) -D part=4 --export-format binstl -o $@ $<

%_part5.stl: %.scad
	$(OPENSCAD) -D part=5 --export-format binstl -o $@ $<

%_part6.stl: %.scad
	$(OPENSCAD) -D part=6 --export-format binstl -o $@ $<

%_part7.stl: %.scad
	$(OPENSCAD) -D part=7 --export-format binstl -o $@ $<

%_part8.stl: %.scad
	$(OPENSCAD) -D part=8 --export-format binstl -o $@ $<

%_part9.stl: %.scad
	$(OPENSCAD) -D part=9 --export-format binstl -o $@ $<

%_part10.stl: %.scad
	$(OPENSCAD) -D part=10 --export-format binstl -o $@ $<

%_part11.stl: %.scad
	$(OPENSCAD) -D part=11 --export-format binstl -o $@ $<

%_part12.stl: %.scad
	$(OPENSCAD) -D part=12 --export-format binstl -o $@ $<

%_part13.stl: %.scad
	$(OPENSCAD) -D part=13 --export-format binstl -o $@ $<

%_part14.stl: %.scad
	$(OPENSCAD) -D part=14 --export-format binstl -o $@ $<

%_part15.stl: %.scad
	$(OPENSCAD) -D part=15 --export-format binstl -o $@ $<

%_part16.stl: %.scad
	$(OPENSCAD) -D part=16 --export-format binstl -o $@ $<

coins_aed.stl: coins.scad
	$(OPENSCAD) -D currency='"AED"' --export-format binstl -o $@ $<

coins_eur.stl: coins.scad
	$(OPENSCAD) -D currency='"EUR"' --export-format binstl -o $@ $<

rewind_stand_%.stl: rewind_stand.scad
	$(OPENSCAD) -D print='"$*"' --export-format binstl -o $@ $<

.PHONY: clean

clean:
	rm -f *.stl
