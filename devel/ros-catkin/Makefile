# robotpkg Makefile for:	devel/catkin
# Created:			Anthony Mallet on Sun, 15 Jul 2012
#

ROS_PKG=	catkin
ROS_VERSION=	0.6.9

CATEGORIES=	devel
ROS_COMMENT=	low-level build system macros and infrastructure

include ../../meta-pkgs/ros-base/Makefile.common

DEPEND_ABI.cmake+= cmake>=2.8.3

CMAKE_ARGS+=-DGTEST_ROOT=${PREFIX.googletest}
CMAKE_ARGS+=-DNOSETESTS=${NOSETESTS}
CMAKE_ARGS+=-DCMAKE_PREFIX_PATH=${PREFIX}
CMAKE_ARGS+=-DSETUPTOOLS_DEB_LAYOUT=OFF

SUBST_CLASSES+=			catkin
SUBST_STAGE.catkin=		pre-configure
SUBST_MESSAGE.catkin=		Replacing installation prefix
SUBST_SED.catkin+=		-e 's|@PREFIX@|${PREFIX}|'
SUBST_FILES.catkin+=		python/catkin/workspace.py

SUBST_CLASSES+=			py-interp
SUBST_FILES.py-interp+=		bin/catkin_*
SUBST_FILES.py-interp+=		cmake/*.py cmake/*/*.py cmake/*/*.py.in
SUBST_FILES.py-interp+=		doc/*.py
SUBST_FILES.py-interp+=		test/*/*.py

SUBST_CLASSES+=			bash-interp
SUBST_FILES.bash-interp+=	cmake/templates/*.bash.in

include ../../sysutils/py-catkin-pkg/depend.mk
include ../../mk/sysdep/bash.mk
include ../../mk/sysdep/cmake.mk
include ../../mk/sysdep/googletest.mk
include ../../mk/sysdep/py-argparse.mk
include ../../mk/sysdep/py-empy.mk
include ../../mk/sysdep/py-nose.mk
include ../../mk/robotpkg.mk
