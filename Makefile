.PHONY: all

all: \
	kx3-dust-cover.stl \
	kx3-dust-cover-logo.stl

%.stl: %.scad
	openscad -o "$@" "$<"
