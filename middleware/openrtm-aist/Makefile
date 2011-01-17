# robotpkg Makefile for:	middleware/openrtm-aist
# Created:			Anthony Mallet on Wed, 23 Jan 2008
#

RTM_VERSION=		0.4.2
DISTNAME=		OpenRTM-aist-${RTM_VERSION}-RELEASE
PKGNAME=		openrtm-aist-${RTM_VERSION}
CATEGORIES=		middleware
MASTER_SITES=		http://www.openrtm.org/pub/OpenRTM-aist/cxx/${RTM_VERSION}/

MAINTAINER=		openrobots@laas.fr
HOMEPAGE=		http://www.is.aist.go.jp/rt/OpenRTM-aist/html-en/FrontPage.html
COMMENT=		Open Robot Technology Middleware from AIST.
LICENSE=		gnu-lgpl-v2.1

USE_LANGUAGES+=		c c++

WRKSRC=			${WRKDIR}/${DISTNAME:-RELEASE=}

GNU_CONFIGURE=		yes
CONFIGURE_ARGS+=	--with-omniorb=${PREFIX.omniORB}


# Use the preferred version of Ace.
#  If not defined, OpenRTM will use the system package even if Ace
#  is installed by RobotPkg which is not what is expected.
CONFIGURE_ARGS+=        --with-ace-includes=${PREFIX.ace} \
                        --with-ace-lib=${PREFIX.ace}

SUBST_CLASSES+=		rtm-python
SUBST_STAGE.rtm-python=	pre-configure
SUBST_MESSAGE.rtm-python=Replacing python interpreter.
SUBST_SED.rtm-python=	'1s@^\\\#![[:space:]]*/usr/bin/env python@\\\#!${PYTHON}@'
SUBST_FILES.rtm-python=\
	build/*.py 				\
	utils/rtc-template/*.py			\
	utils/rtc-template/rtc-template		\
	utils/rtm-skelwrapper/*.py		\
	utils/rtm-skelwrapper/rtm-skelwrapper

include ../../middleware/ace/depend.mk
include ../../middleware/omniORB/depend.mk
include ../../pkgtools/libtool/depend.mk
include ../../mk/sysdep/python2.mk
include ../../mk/robotpkg.mk