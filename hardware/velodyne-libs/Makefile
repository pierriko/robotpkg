# robotpkg Makefile for:	hardware/velodyne-libs
# Created:			Matthieu Herrb on Fri, 25 Jun 2010
#
NAME=			velodyne-libs
VERSION=		0.8
CATEGORIES=		hardware
DISTNAME=		${NAME}-${VERSION}
MASTER_SITES=		${MASTER_SITE_OPENROBOTS:=velodyne/}
MASTER_REPOSITORY=	${MASTER_REPOSITORY_OPENROBOTS_TRAC}${NAME}

MAINTAINER=	openrobots@laas.fr
COMMENT=	interface library for the Velodyne Lidar sensor

LICENSE=	isc
NOT_FOR_PLATFORM=	# empty

GNU_CONFIGURE=	yes
CONFIGURE_ARGS+=--with-tclsh=${TCLSH}

DEPEND_METHOD.tcl=	build
DEPEND_METHOD.tdom=	build

INCLUDE_DIRS.libpcap=	include
LIBRARY_DIRS.libpcap=	lib
RPATH_DIRS.libpcap=	lib

# for checkout target
AUTORECONF_SCRIPT=	${MKDIR} ${WRKSRC}/m4 && ${AUTORECONF}

include ../../middleware/pocolibs/depend.mk
include ../../pkgtools/libtool/depend.mk
include ../../pkgtools/pkg-config/depend.mk
include ../../mk/sysdep/tcl.mk
include ../../mk/sysdep/tdom.mk
include ../../mk/sysdep/libpcap.mk
include ../../mk/language/c.mk
include ../../mk/robotpkg.mk
