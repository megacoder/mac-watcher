TARGETS=all check clean clobber distclean install uninstall
TARGET=all

PREFIX=${DESTDIR}/opt
BINDIR=${PREFIX}/bin
SUBDIRS=

ifeq	(${MAKE},gmake)
	INSTALL=ginstall
else
	INSTALL=install
endif

.PHONY: ${TARGETS} ${SUBDIRS}

all::	mac-watcher.zsh

${TARGETS}::

clobber distclean:: clean

check::	mac-watcher.zsh
	./mac-watcher.zsh ${ARGS}

install:: mac-watcher.zsh
	${INSTALL} -D mac-watcher.zsh ${BINDIR}/mac-watcher

uninstall::
	${RM} ${BINDIR}/mac-watcher

ifneq	(,${SUBDIRS})
${TARGETS}::
	${MAKE} TARGET=$@ ${SUBDIRS}
${SUBDIRS}::
	${MAKE} -C $@ ${TARGET}
endif
