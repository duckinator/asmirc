all: asmirc

asmirc: asmirc.o
	ld -melf_i386 -ggdb -O0 -s asmirc.o -o asmirc

asmirc.o: asmirc.asm
	nasm -f elf32 asmirc.asm

clean:
	rm asmirc.o asmirc

.PHONY: all clean
