SOURCES = graphics.ml problem.ml ihm.ml rrt.ml main.ml
TARGET = prog
OCAMLC = ocamlc
OCAMLDOC = ocamldoc
CDEP = ocamldep
OBJS = $(SOURCES:.ml=.cmo)
LIBS = unix.cma graphics.cma

all: $(TARGET) doc

doc:
	mkdir doc;$(OCAMLDOC) -html -t "RRT" -d doc -intro Intro.txt *.mli

$(TARGET) : $(OBJS)
	$(OCAMLC) -o $@ $(LIBS) $^

%.cmo : %.ml
	$(OCAMLC) -c $<

%.cmi : %.mli
	$(OCAMLC) $<

clean: cleanfile cleandoc

cleanfile :
	rm -f *.cmo *.cmi .depend $(TARGET)

cleandoc :
	rm -r doc

.depend:
	$(CDEP) *.mli *.ml >.depend

include .depend