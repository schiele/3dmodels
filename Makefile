%.stl: %.scad
	openscad --export-format binstl -o $@ $<

%_part1.stl: %.scad
	openscad -D part=1 --export-format binstl -o $@ $<

%_part2.stl: %.scad
	openscad -D part=2 --export-format binstl -o $@ $<

all: \
	cardholder_part1.stl \
	cardholder_part2.stl \
	keychain_cart_coin_part1.stl \
	keychain_cart_coin_part2.stl \

.PHONY: clean

clean:
	rm -f *.stl
