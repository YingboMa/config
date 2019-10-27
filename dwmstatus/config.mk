# dwmstatus version
VERSION = 0.2.1

# paths
PREFIX = ${HOME}/.local
MANPREFIX = ${PREFIX}/share/man

INCS = -I. -I/usr/include
LIBS = -L/usr/lib

LIBS+= -lX11 -lm -lasound

DEBUGLD = -lgcc_s -fsanitize=address -g
DEBUGC  =  -fsanitize=address -g

# flags
CPPFLAGS = -DVERSION=\"${VERSION}\"
CFLAGS += -std=gnu99 -pedantic -Wall -Os ${INCS} ${DEFS} ${CPPFLAGS}
LDFLAGS += ${LIBS}

# Enable debug
#CFLAGS += ${DEBUGC}
#LDFLAGS += ${DEBUGLD}

# compiler and linker
CC = clang
