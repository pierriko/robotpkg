# robotpkg depend.mk for:	sysutils/ros-console-bridge
# Created:			Anthony Mallet on Thu, 27 Jun 2013
#

DEPEND_DEPTH:=			${DEPEND_DEPTH}+
ROS_CONSOLE_BRIDGE_DEPEND_MK:=	${ROS_CONSOLE_BRIDGE_DEPEND_MK}+

ifeq (+,$(DEPEND_DEPTH))
DEPEND_PKG+=		ros-console-bridge
endif

ifeq (+,$(ROS_CONSOLE_BRIDGE_DEPEND_MK)) # ---------------------------------

include ../../meta-pkgs/ros-base/depend.common
PREFER.ros-console-bridge?=		${PREFER.ros-base}
SYSTEM_PREFIX.ros-console-bridge?=	${SYSTEM_PREFIX.ros-base}

DEPEND_USE+=		ros-console-bridge

DEPEND_ABI.ros-console-bridge?=	ros-console-bridge>=0.2
DEPEND_DIR.ros-console-bridge?=	../../sysutils/ros-console-bridge

SYSTEM_SEARCH.ros-console-bridge=\
  include/console_bridge/console.h				\
  lib/libconsole_bridge.so					\
  'share/console_bridge/package.xml:/<version>/s/[^0-9.]//gp'	\
  'lib/pkgconfig/console_bridge.pc:/Version/s/[^0-9.]//gp'

endif # ROS_CONSOLE_BRIDGE_DEPEND_MK ---------------------------------------

DEPEND_DEPTH:=		${DEPEND_DEPTH:+=}
