# robotpkg Makefile for:	graphics/gepetto-viewer
# Created:			Florent Lamiraux on Sun, 8 Mar 2015
#

HPP_PACKAGE=		gepetto-viewer
HPP_VERSION=		1.0.0
PKGREVISION=

CATEGORIES=		graphics
HPP_COMMENT=		Simple viewer based on OpenSceneGraph
LICENSE=		gnu-lgpl-v3

CONFIGURE_DIRS=		build
CMAKE_ARG_PATH=		..

HPP_BUILD_SYSTEM=	cmake
include ../../meta-pkgs/hpp/Makefile.common

CMAKE_ARGS+=		-DCXX_DISABLE_WERROR=yes

DEPEND_ABI.openthreads+= openthreads>=2
DEPEND_ABI.openscenegraph+= openscenegraph>=3.2

include ../../graphics/ros-robot-model/depend.mk
include ../../mk/language/c.mk
include ../../mk/sysdep/openscenegraph.mk
include ../../mk/sysdep/openthreads.mk
include ../../mk/robotpkg.mk

# create the build directory
pre-configure:
	${RUN}${MKDIR} ${WRKSRC}/build
