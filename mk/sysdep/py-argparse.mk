# robotpkg sysdep/py-argparse.mk
# Created:			Anthony Mallet on Sun Jul 15 2010
#
DEPEND_DEPTH:=		${DEPEND_DEPTH}+
PY_ARGPARSE_DEPEND_MK:=	${PY_ARGPARSE_DEPEND_MK}+

include ../../mk/sysdep/python.mk

ifeq (+,$(DEPEND_DEPTH))
  # argparse was included in python-2.7
  DEPEND_PKG+=$(if $(filter 2.5 2.6,${PYTHON_VERSION}),py-argparse)
endif

ifeq (+,$(PY_ARGPARSE_DEPEND_MK)) # ----------------------------------------

PREFER.py-argparse?=	system

# argparse was included in python-2.7
DEPEND_USE+=$(if $(filter 2.5 2.6,${PYTHON_VERSION}),py-argparse)

DEPEND_ABI.py-argparse?=${PKGTAG.python}-argparse>=1

SYSTEM_SEARCH.py-argparse=\
  '${PYTHON_SYSLIBSEARCH}/argparse.py:/__version__/s/[^0-9.]//gp'

SYSTEM_PKG.Debian.py-argparse=	python-argparse (python-${PYTHON_VERSION})
SYSTEM_PKG.Fedora.py-argparse=	python-argparse (python-${PYTHON_VERSION})
SYSTEM_PKG.NetBSD.py-argparse=	devel/${PKGTAG.python}-argparse
SYSTEM_PKG.Ubuntu.py-argparse=	python-argparse (python-${PYTHON_VERSION})

endif # PY_ARGPARSE_DEPEND_MK ----------------------------------------------

DEPEND_DEPTH:=		${DEPEND_DEPTH:+=}
