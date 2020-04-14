.PHONY: all

all: \
	kx3-dust-cover.stl \
	kx3-dust-cover-logo.stl

# note *.scad to assume complete dependencies (simple and approximately right)
%.stl: *.scad
	openscad -o "$@" "$<"
