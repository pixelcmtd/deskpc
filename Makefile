SCAD = $(wildcard *.scad)
STL = $(patsubst %.scad,build/%.stl,$(SCAD))
CSG = $(patsubst %.scad,build/%.csg,$(SCAD))
PNG = $(patsubst %.scad,preview/%.png,$(SCAD))

$(shell mkdir -p build preview)

all: $(CSG) $(STL) $(PNG)

build/%.stl: build/%.csg
	openscad $< --backend=manifold -o $@

build/%.csg: %.scad
	openscad $< --backend=manifold -o $@

preview/%.png: build/%.csg
	openscad $< --backend=manifold --render --imgsize 1024,1024 --colorscheme BeforeDawn -o $@

clean:
	rm -f $(STL) $(CSG) $(PNG)

.PHONY: all clean
