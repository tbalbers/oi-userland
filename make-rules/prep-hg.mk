#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#

#
# Copyright (c) 2010, 2016, Oracle and/or its affiliates. All rights reserved.
#

HG =		/usr/bin/hg

#
# Anything that we pull from a Mercurial repo must have a HG_REPO{_[0-9]+} and
# HG_REV{_[0-9]+} to match.
#

HG_SUFFIXES = $(subst HG_REPO_,, $(filter HG_REPO_%, $(.VARIABLES)))

define mercurial-rules
ifdef HG_REPO$(1)
ifdef HG_REV$(1)

COMPONENT_SRC$(1) = $$(COMPONENT_NAME$(1))-$(COMPONENT_VERSION)-$$(HG_REV$(1))
COMPONENT_ARCHIVE$(1) = $$(COMPONENT_SRC$(1)).tar.bz2
COMPONENT_ARCHIVE_SRC$(1) = hg

CLEAN_PATHS += $$(COMPONENT_SRC$(1))
CLOBBER_PATHS += $$(COMPONENT_ARCHIVE$(1))
SOURCE_DIR$(1) = $$(COMPONENT_DIR)/$(COMPONENT_SRC$(1))

download::	$$(USERLAND_ARCHIVES)$$(COMPONENT_ARCHIVE$(1))

# First attempt to download a cached archive of the SCM repo at the proper
# changeset ID.  If that fails, create an archive by cloning the SCM repo,
# updating to the selected changeset, archiving that directory, and cleaning up
# when complete.
$$(USERLAND_ARCHIVES)$$(COMPONENT_ARCHIVE$(1)):	$(MAKEFILE_PREREQ)
	$$(FETCH) --file $$@ $$(HG_HASH$(1):%=--hash %) || \
	(TMP_REPO=$$$$(mktemp --directory) && \
	 $(HG) clone $$(HG_REPO$(1)) $$(HG_REV$(1):%=--rev %) \
		 $$(HG_REV$(1):%=--updaterev %) \
		 $$(HG_BRANCH$(1):%=--branch %) \
		    $$$${TMP_REPO} && \
	 $(HG) -R $$$${TMP_REPO} archive --prefix $$(COMPONENT_SRC$(1)) $$@ && \
	 $(RM) -rf $${TMP_REPO} && \
	 HG_HASH=$$$$(digest -a sha256 $$@) && \
	 $(GSED) -i \
		-e "s/^HG_HASH$(1)=.*/HG_HASH$(1)=	sha256:$$$${HG_HASH}/" \
		Makefile)

REQUIRED_PACKAGES += developer/versioning/mercurial

endif
endif
endef

#
# Define the rules required to download any source archives and augment any
# cleanup macros.
#
$(eval $(call mercurial-rules,))
$(foreach suffix, $(HG_SUFFIXES), $(eval $(call mercurial-rules,_$(suffix))))
