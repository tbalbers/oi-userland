#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL)". You may
# only use this file in accordance with the terms of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source. A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
#

#
# Copyright 2014 (c) Aurelien Larcher. All rights reserved.
#
include ../../../make-rules/shared-macros.mk

COMPONENT_NAME=           hdf5
COMPONENT_VERSION=        1.8.20
COMPONENT_FMRI=           library/c++/hdf5
COMPONENT_SUMMARY= \
  HDF5 - Data model, library, and file format for storing and managing data
COMPONENT_PROJECT_URL=    http://www.hdfgroup.org
COMPONENT_CLASSIFICATION= System/Libraries
COMPONENT_SRC=            $(COMPONENT_NAME)-$(COMPONENT_VERSION)
COMPONENT_ARCHIVE=        $(COMPONENT_SRC).tar.gz
COMPONENT_ARCHIVE_HASH=	\
  sha256:6ed660ccd2bc45aa808ea72e08f33cc64009e9dd4e3a372b53438b210312e8d9
COMPONENT_ARCHIVE_URL= \
  https://support.hdfgroup.org/ftp/HDF5/current18/src/$(COMPONENT_ARCHIVE)
COMPONENT_LICENSE=        NCSA

include $(WS_MAKE_RULES)/prep.mk
include $(WS_MAKE_RULES)/configure.mk
include $(WS_MAKE_RULES)/ips.mk

CONFIGURE_OPTIONS  +=		CFLAGS="$(CFLAGS) -D_LARGEFILE_SOURCE -D__EXTENSIONS__"
CONFIGURE_OPTIONS  +=		--includedir=$(CONFIGURE_PREFIX)/include/hdf5
CONFIGURE_OPTIONS  +=		--disable-static
CONFIGURE_OPTIONS  +=		--enable-fortran
CONFIGURE_OPTIONS  +=		--enable-cxx

build:		$(BUILD_32_and_64)

install:	$(INSTALL_32_and_64)

REQUIRED_PACKAGES += library/zlib
REQUIRED_PACKAGES += system/library
REQUIRED_PACKAGES += $(GXX_RUNTIME_PKG)
REQUIRED_PACKAGES += $(GCC_RUNTIME_PKG)
REQUIRED_PACKAGES += $(GFORTRAN_RUNTIME_PKG)
REQUIRED_PACKAGES += system/library/math
