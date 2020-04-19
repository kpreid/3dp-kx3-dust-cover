.PHONY: all

all: \
	kx3-dust-cover.stl \
	kx3-dust-cover-mm-body.stl \
	kx3-dust-cover-mm-label.stl

# note *.scad to assume complete dependencies (simple and approximately right)
%.stl: %.scad *.scad
	openscad -o "$@" "$<"
