# $Id$

WRAPPERS := _emd.so emd.py
LIBS =
INCLUDES := $(shell python2-config --includes)

CC = cc
LD = ld
CFLAGS =

all: $(WRAPPERS)

_%.so: %.o %_wrap.o
	@echo ">>> Linking wrapper library '$(@)'."
	@echo -n "    "
	$(LD) -shared -o $@ $^
	@echo

%.o: %.c
	@echo ">>> Building object file '$(@)'."
	@echo -n "    "
	$(CC) -o $@ -c $< $(CFLAGS) $(INCLUDES) $(LIBS)
	@echo

%_wrap.c %.py: %.i %.h
	@echo ">>> Generating C interface"
	swig -python $<
	@echo
	
.PHONY: clean

clean:
	rm -f $(WRAPPERS) *.o *_wrap.c *.pyc *.pyo
	rm -rf __pycache__ 
	
mrproper: clean
	rm -f *~
