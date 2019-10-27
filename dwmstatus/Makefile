include config.mk

SRC = dwmstatus.c
OBJ = ${SRC:.c=.o}

all: options dwmstatus

options:
	@echo dwmstatus build options:
	@echo "CFLAGS  = ${CFLAGS}"
	@echo "LDFLAGS = ${LDFLAGS}"
	@echo "CC      = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk dwmstatus.h

config.h:
	@echo creating $@ from config.def.h
	@cp config.def.h $@

dwmstatus: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f ${SRC:.c=} ${OBJ} dwmstatus-${VERSION}.tar.xz

dist: clean
	@echo creating dist tarball
	@mkdir -p dwmstatus-${VERSION}
	@cp -R Makefile ${OBJ} ${SRC} dwmstatus-${VERSION}
	@tar -cf dwmstatus-${VERSION}.tar dwmstatus-${VERSION}
	@xz dwmstatus-${VERSION}.tar
	@rm -rf dwmstatus-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f dwmstatus ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dwmstatus

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/dwmstatus

.PHONY: all options clean dist install uninstall
