# $LAAS: robotpkg.mk 2009/03/02 01:23:53 tho $
#
# Copyright (c) 2006-2009 LAAS/CNRS
# All rights reserved.
#
# This project includes software developed by the NetBSD Foundation, Inc.
# and its contributors. It is derived from the 'pkgsrc' project
# (http://www.pkgsrc.org).
#
# Redistribution and use  in source  and binary  forms,  with or without
# modification, are permitted provided that the following conditions are
# met:
#
#   1. Redistributions of  source  code must retain the  above copyright
#      notice, this list of conditions and the following disclaimer.
#   2. Redistributions in binary form must reproduce the above copyright
#      notice,  this list of  conditions and the following disclaimer in
#      the  documentation  and/or  other   materials provided  with  the
#      distribution.
#
# THIS  SOFTWARE IS PROVIDED BY  THE  COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND  ANY  EXPRESS OR IMPLIED  WARRANTIES,  INCLUDING,  BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES  OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR  PURPOSE ARE DISCLAIMED. IN  NO EVENT SHALL THE COPYRIGHT
# HOLDERS OR      CONTRIBUTORS  BE LIABLE FOR   ANY    DIRECT, INDIRECT,
# INCIDENTAL,  SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF  SUBSTITUTE GOODS OR SERVICES; LOSS
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR
# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
# USE   OF THIS SOFTWARE, EVEN   IF ADVISED OF   THE POSSIBILITY OF SUCH
# DAMAGE.
#
# From $NetBSD: bsd.pkg.mk,v 1.1892 2006/10/23 14:40:14 rillig Exp $
#
#                                      Anthony Mallet on Wed Nov  8 2006
#

# Please see the pkgsrc/doc/guide manual for details on the
# variables used in this make file template.

# Make sure the default target is "all", which defaults to
#
#    bootstrap-depends
#    fetch
#    checksum
#    depends
#    tools
#    extract
#    patch
#    configure
#    build
#
.DEFAULT_GOAL:=all
.PHONY: all
all: build


# Include any preferences, if not already included, and common
# definitions. The file robotpkg.prefs.mk is protected against double
# inclusion, but checking the flag here avoids loading and parsing it.
#
ifndef MK_ROBOTPKG_PREFS
  include ../../mk/robotpkg.prefs.mk
endif

$(call require,${ROBOTPKG_DIR}/mk/internal/utils.mk)


# --- Transform package Makefile variables and set defaults ----------
#

# PKGBASE, PKGNAME[_NOREV], PKGVERSION
#
ifneq (,${PKGREVISION})
  ifneq (0,${PKGREVISION})
    ifdef PKGNAME
      PKGNAME_NOREV:=	${PKGNAME}
      PKGNAME:=		${PKGNAME}r${PKGREVISION}
    else
      PKGNAME?=		${DISTNAME}r${PKGREVISION}
      PKGNAME_NOREV=	${DISTNAME}
    endif
  else
    PKGNAME?=		${DISTNAME}
    PKGNAME_NOREV=	${PKGNAME}
  endif
else
  PKGNAME?=		${DISTNAME}
  PKGNAME_NOREV=	${PKGNAME}
endif

PKGVERSION?=		$(lastword $(subst -, ,${PKGNAME}))
PKGBASE?=		$(patsubst %-${PKGVERSION},%,${PKGNAME})
PKGVERSION_NOREV:=	$(patsubst ${PKGBASE}-%,%,${PKGNAME_NOREV})

# Others
#
BUILD_DEPENDS?=#	empty
COMMENT?=		(no description)
DEPENDS?=#		empty
DESCR_SRC?=		${PKGDIR}/DESCR
INTERACTIVE_STAGE?=	none
MAINTAINER?=		openrobots@laas.fr
PKGWILDCARD?=		${PKGBASE}-[0-9]*
WRKSRC?=		${WRKDIR}/${DISTNAME}
PREFIX?=		${LOCALBASE}

ifneq (,$(or $(call isyes,$(INSTALL_UNSTRIPPED)), $(DEBUG_FLAGS)))
_INSTALL_UNSTRIPPED=	# set (flag used by platform/*.mk)
endif


# --- Sanity checks --------------------------------------------------

# Fail-safe in the case of circular dependencies
ifdef _PKGSRC_DEPS
ifdef PKGNAME
ifneq (,$(filter $(PKGNAME), $(_PKGSRC_DEPS)))
PKG_FAIL_REASON+=	"Circular dependency detected"
endif
endif
endif

ifeq (,$(CATEGORIES))
PKG_FAIL_REASON+='CATEGORIES are mandatory.'
endif
ifeq (,$(DISTNAME))
PKG_FAIL_REASON+='DISTNAME are mandatory.'
endif


CPPFLAGS+=	${CPP_PRECOMP_FLAGS}

ALL_ENV+=	CC=$(call quote,${CC})
ALL_ENV+=	CFLAGS=$(call quote,${CFLAGS})
ALL_ENV+=	CPPFLAGS=$(call quote,${CPPFLAGS})
ALL_ENV+=	CXX=$(call quote,${CXX})
ALL_ENV+=	CXXFLAGS=$(call quote,${CXXFLAGS})
ALL_ENV+=	COMPILER_RPATH_FLAG=$(call quote,${COMPILER_RPATH_FLAG})
ALL_ENV+=	F77=$(call quote,${FC})
ALL_ENV+=	FC=$(call quote,${FC})
ALL_ENV+=	FFLAGS=$(call quote,${FFLAGS})
ALL_ENV+=	LANG=C
ALL_ENV+=	LC_COLLATE=C
ALL_ENV+=	LC_CTYPE=C
ALL_ENV+=	LC_MESSAGES=C
ALL_ENV+=	LC_MONETARY=C
ALL_ENV+=	LC_NUMERIC=C
ALL_ENV+=	LC_TIME=C
ALL_ENV+=	LDFLAGS=$(call quote,${LDFLAGS})
ALL_ENV+=	LINKER_RPATH_FLAG=$(call quote,${LINKER_RPATH_FLAG})
ALL_ENV+=	PATH=${PATH}:${LOCALBASE}/bin
ALL_ENV+=	PREFIX=${PREFIX}

_BUILD_DEFS=		${BUILD_DEFS}
_BUILD_DEFS+=		LOCALBASE
_BUILD_DEFS+=		PKGINFODIR
_BUILD_DEFS+=		PKGMANDIR

ifndef DEPOT_SUBDIR
PKG_FAIL_REASON+=	"DEPOT_SUBDIR may not be empty."
endif

_INTERACTIVE_COOKIE=	${.CURDIR}/.interactive_stage

# Miscellaneous overridable commands:
SHCOMMENT?=		${ECHO_MSG} >/dev/null '***'


# Debugging levels for this file, dependent on PKG_DEBUG_LEVEL definition
# 0 == normal, default, quiet operation
# 1 == all shell commands echoed before invocation
# 2 == shell "set -x" operation
PKG_DEBUG_LEVEL?=	0
_PKG_SILENT=		@
_PKG_DEBUG=#		empty
_PKG_DEBUG_SCRIPT=#	empty
_PKG_DISCARD_STDERR=	2>/dev/null

ifeq (1,${PKG_DEBUG_LEVEL})
_PKG_SILENT=#		empty
_PKG_DISCARD_STDERR=#	empty
endif

ifeq (2,${PKG_DEBUG_LEVEL})
_PKG_SILENT=#		empty
_PKG_DEBUG=		set -x;
_PKG_DEBUG_SCRIPT=	${SH} -x
_PKG_DISCARD_STDERR=#	empty
endif

# This variable can be prepended to all shell commands that should not
# be printed by default, but when PKGSRC_DEBUG_LEVEL is non-zero.
# It also adds error checking.
#
RUN=			${_PKG_SILENT}${_PKG_DEBUG} set -e;


# A few aliases for *-install targets
INSTALL=		${TOOLS_INSTALL}
INSTALL_PROGRAM?= 	\
	${INSTALL} ${COPY} ${_STRIPFLAG_INSTALL} -o ${BINOWN} -g ${BINGRP} -m ${BINMODE}
INSTALL_SCRIPT?= 	\
	${INSTALL} ${COPY} -o ${BINOWN} -g ${BINGRP} -m ${BINMODE}
INSTALL_LIB?= 		\
	${INSTALL} ${COPY} -o ${BINOWN} -g ${BINGRP} -m ${BINMODE}
INSTALL_DATA?= 		\
	${INSTALL} ${COPY} -o ${SHAREOWN} -g ${SHAREGRP} -m ${SHAREMODE}
INSTALL_MAN?= 		\
	${INSTALL} ${COPY} -o ${MANOWN} -g ${MANGRP} -m ${MANMODE}
INSTALL_PROGRAM_DIR?= 	\
	${INSTALL} -d -o ${BINOWN} -g ${BINGRP} -m ${PKGDIRMODE}
INSTALL_SCRIPT_DIR?= 	\
	${INSTALL_PROGRAM_DIR}
INSTALL_LIB_DIR?= 	\
	${INSTALL_PROGRAM_DIR}
INSTALL_DATA_DIR?= 	\
	${INSTALL} -d -o ${SHAREOWN} -g ${SHAREGRP} -m ${PKGDIRMODE}
INSTALL_MAN_DIR?= 	\
	${INSTALL} -d -o ${MANOWN} -g ${MANGRP} -m ${PKGDIRMODE}

INSTALL_MACROS=	BSD_INSTALL_PROGRAM=$(call quote,${INSTALL_PROGRAM})		\
		BSD_INSTALL_SCRIPT=$(call quote,${INSTALL_SCRIPT})		\
		BSD_INSTALL_LIB=$(call quote,${INSTALL_LIB})			\
		BSD_INSTALL_DATA=$(call quote,${INSTALL_DATA})			\
		BSD_INSTALL_MAN=$(call quote,${INSTALL_MAN})			\
		BSD_INSTALL=$(call quote,${INSTALL})				\
		BSD_INSTALL_PROGRAM_DIR=$(call quote,${INSTALL_PROGRAM_DIR})	\
		BSD_INSTALL_SCRIPT_DIR=$(call quote,${INSTALL_SCRIPT_DIR})	\
		BSD_INSTALL_LIB_DIR=$(call quote,${INSTALL_LIB_DIR})		\
		BSD_INSTALL_DATA_DIR=$(call quote,${INSTALL_DATA_DIR})		\
		BSD_INSTALL_MAN_DIR=$(call quote,${INSTALL_MAN_DIR})		\
		BSD_INSTALL_GAME=$(call quote,${INSTALL_GAME})			\
		BSD_INSTALL_GAME_DATA=$(call quote,${INSTALL_GAME_DATA})	\
		BSD_INSTALL_GAME_DIR=$(call quote,${INSTALL_GAME_DIR})
MAKE_ENV+=	${INSTALL_MACROS}
SCRIPTS_ENV+=	${INSTALL_MACROS}

# Used to print all the '===>' style prompts - override this to turn them off.
ECHO_MSG?=		${ECHO}
PHASE_MSG?=		_bf() { ${ECHO_MSG} "${bf}===>" $$@ "${rm}"; }; _bf
STEP_MSG?=		${ECHO_MSG} "=>"
WARNING_MSG?=		${ECHO_MSG} 1>&2 "WARNING:"
ERROR_MSG?=		${ECHO_MSG} 1>&2 "ERROR:"
FAIL_MSG?=		${FAIL} ${ERROR_MSG}

WARNING_CAT?=		${SED} -e "s|^|WARNING: |" 1>&2
ERROR_CAT?=		${SED} -e "s|^|ERROR: |" 1>&2

# How to do nothing.  Override if you, for some strange reason, would rather
# do something.
DO_NADA?=		${TRUE}

# the FAIL command executes its arguments and then exits with a non-zero
# status.
FAIL?=                  ${SH} ${ROBOTPKG_DIR}/mk/internal/fail

#
# Config file related settings - see doc/pkgsrc.txt
#
PKG_SYSCONFVAR?=	${PKGBASE}
PKG_SYSCONFSUBDIR?=	# empty
PKG_SYSCONFDEPOTBASE=	# empty
PKG_SYSCONFBASEDIR=	${PKG_SYSCONFBASE}
ifdef PKG_SYSCONFSUBDIR
DFLT_PKG_SYSCONFDIR:=	${PKG_SYSCONFBASEDIR}/${PKG_SYSCONFSUBDIR}
else
DFLT_PKG_SYSCONFDIR:=	${PKG_SYSCONFBASEDIR}
endif
PKG_SYSCONFDIR=		${DFLT_PKG_SYSCONFDIR}

ALL_ENV+=		PKG_SYSCONFDIR=${PKG_SYSCONFDIR}
_BUILD_DEFS+=		PKG_SYSCONFBASEDIR PKG_SYSCONFDIR

ifndef NO_CHECKSUM
USE_TOOLS+=		digest:bootstrap
endif

# Pkg
include ${ROBOTPKG_DIR}/mk/pkg/pkg-vars.mk

# Get the proper dependencies and set the PATH to use the compiler
# named in PKGSRC_COMPILER.
include ${ROBOTPKG_DIR}/mk/compiler/compiler-vars.mk

# Tools
include ${ROBOTPKG_DIR}/mk/tools/tools-vars.mk

# Locking
include ${ROBOTPKG_DIR}/mk/internal/locking.mk

# Barriers
include ${ROBOTPKG_DIR}/mk/internal/barrier.mk

# Process user build options
include ${ROBOTPKG_DIR}/mk/robotpkg.options.mk


# --------------------------------------------------------------------
# Many ways to disable a package.
#
# Don't build a package if it's restricted and we don't want to
# get into that.
#
# --------------------------------------------------------------------

ifdef RESTRICTED
ifdef NO_RESTRICTED
PKG_FAIL_REASON+= "${PKGNAME} is restricted: ${RESTRICTED}"
endif
endif

ifdef LICENSE
  ifeq (,$(filter ${LICENSE},${ACCEPTABLE_LICENSES}))
PKG_FAIL_REASON+= ${hline}
PKG_FAIL_REASON+= "${PKGNAME} has an unacceptable license: ${LICENSE}."
PKG_FAIL_REASON+= ""
PKG_FAIL_REASON+= " . To view the license, enter \"${MAKE} show-license\"."
PKG_FAIL_REASON+= " . To indicate acceptance, add this line:"
PKG_FAIL_REASON+= ""
PKG_FAIL_REASON+= "    ACCEPTABLE_LICENSES+=${LICENSE}"
PKG_FAIL_REASON+= ""
PKG_FAIL_REASON+= "   to ${MAKECONF}"
PKG_FAIL_REASON+= ""
PKG_FAIL_REASON+= ${hline}
  endif
endif

#
# Now print some error messages that we know we should ignore the pkg
#
ifdef PKG_FAIL_REASON

fetch checksum extract patch configure all build install package \
update depends: do-check-pkg-fail-or-skip-reason

.PHONY: do-check-pkg-fail-or-skip-reason
do-check-pkg-fail-or-skip-reason:
     ifdef SKIP_SILENT
	@${DO_NADA}
     else
       ifdef PKG_FAIL_REASON
	@for str in ${PKG_FAIL_REASON}; do				\
		${ERROR_MSG} "$$str";					\
	done
       endif
     endif
     ifdef PKG_FAIL_REASON
	@${FAIL}
     endif
endif

.PHONY: do-check-pkg-fail-reason
do-check-pkg-fail-reason:
	@${DO_NADA}

# This target should appear as a dependency of every top level target that
# is intended to be called by the user or by a package different from the
# current package.
ifdef PKG_FAIL_REASON
do-check-pkg-fail-reason: do-check-pkg-fail-or-skip-reason
endif


# Add these defs to the ones dumped into +BUILD_DEFS
_BUILD_DEFS+=	PKGPATH
_BUILD_DEFS+=	OPSYS OS_VERSION MACHINE_ARCH MACHINE_GNU_ARCH
_BUILD_DEFS+=	CPPFLAGS CFLAGS FFLAGS LDFLAGS
_BUILD_DEFS+=	LICENSE RESTRICTED NO_PUBLIC_BIN NO_PUBLIC_SRC


################################################################
# More standard targets start here.
#
# These are the body of the build/install framework.  If you are
# not happy with the default actions, and you can't solve it by
# adding pre-* or post-* targets/scripts, override these.
################################################################

# Check
#include "${ROBOTPKG_DIR}/mk/check/bsd.check.mk"

# Clean
include ${ROBOTPKG_DIR}/mk/clean.mk

# Fetch
$(call require,${ROBOTPKG_DIR}/mk/fetch/fetch-vars.mk)

# Checksum
include ${ROBOTPKG_DIR}/mk/checksum/checksum-vars.mk

# Extract
$(call require,${ROBOTPKG_DIR}/mk/extract/extract-vars.mk)

# Patch
include ${ROBOTPKG_DIR}/mk/patch/patch-vars.mk

# Configure
include ${ROBOTPKG_DIR}/mk/configure/configure-vars.mk

# Build
include ${ROBOTPKG_DIR}/mk/build/build-vars.mk

# Install
include ${ROBOTPKG_DIR}/mk/install/install-vars.mk

# Package
include ${ROBOTPKG_DIR}/mk/package/package-vars.mk

# Dependencies
include ${ROBOTPKG_DIR}/mk/depends/depends-vars.mk

# Update
include ${ROBOTPKG_DIR}/mk/update/update-vars.mk

# --------------------------------------------------------------------
#
# Some more targets supplied for users' convenience
#

# Run pkglint:
.PHONY: lint
lint:
	${_PKG_SILENT}${_PKG_DEBUG}${LOCALBASE}/bin/pkglint

# List of flags to pass to pkg_add(1) for bin-install:

BIN_INSTALL_FLAGS?= 	# -v
_BIN_INSTALL_FLAGS=	${BIN_INSTALL_FLAGS}
ifneq (,$(isyes _AUTOMATIC))
_BIN_INSTALL_FLAGS+=	-A
endif
_BIN_INSTALL_FLAGS+=	${PKG_ARGS_ADD}

#include "${ROBOTPKG_DIR}/mk/install/bin-install.mk"


################################################################
# Everything after here are internal targets and really
# shouldn't be touched by anybody but the release engineers.
################################################################

include ../../mk/plist/plist-vars.mk

include ${ROBOTPKG_DIR}/mk/internal/can-be-built-here.mk
include ${ROBOTPKG_DIR}/mk/internal/subst.mk
include ${ROBOTPKG_DIR}/mk/internal/su-target.mk

#include "${ROBOTPKG_DIR}/mk/internal/build-defs-message.mk"
#if make(debug) || make(build-env)
#.include "${ROBOTPKG_DIR}/mk/bsd.pkg.debug.mk"
#.endif
#.if make(help)
#.include "${ROBOTPKG_DIR}/mk/help/help.mk"
#.endif

# For bulk build targets (bulk-install, bulk-package), the
# BATCH variable must be set in /etc/mk.conf:
ifdef BATCH
 include ${ROBOTPKG_DIR}/mk/bulk/bulk.mk
endif

# index.html generation code.
include ${ROBOTPKG_DIR}/mk/internal/index.mk

# Tell 'make' not to try to rebuild any Makefile by specifing a
# double-colon target with no dependencies.
#
${MAKEFILE_LIST}::
	@${DO_NADA}
