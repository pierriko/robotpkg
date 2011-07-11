# robotpkg Makefile for:	motion/dynamic-graph-python
# Created:			Florent Lamiraux on Thu, 7 Jul 2011
#

VERSION=		2.5
PKGREVISION=		1
DISTNAME=		dynamic-graph-python-${VERSION}
PKGNAME=		py-dynamic-graph-${VERSION}
MASTER_SITES=		${MASTER_SITE_OPENROBOTS:=dynamic-graph-python/}
MASTER_REPOSITORY=	${MASTER_REPOSITORY_GITHUB_JRL}dynamic-graph-python

MAINTAINER=	gepetto@laas.fr
CATEGORIES=	motion
LICENSE=	gnu-lgpl-v3
COMMENT=	Python bindings for motion/dynamic-graph package

USE_LANGUAGES+=		c c++ python
DOXYGEN_PLIST_DIR+=	share/doc/dynamic-graph-python

include ../../motion/dynamic-graph/depend.mk
include ../../pkgtools/pkg-config/depend.mk
include ../../mk/sysdep/cmake.mk
include ../../mk/sysdep/doxygen.mk
include ../../mk/sysdep/graphviz.mk
include ../../mk/sysdep/pdflatex.mk
include ../../mk/robotpkg.mk