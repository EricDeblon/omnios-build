#!/usr/bin/bash
#
# {{{ CDDL HEADER
#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source. A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
# }}}
#
# Copyright 2018 OmniOS Community Edition (OmniOSce) Association.
# Use is subject to license terms.
#
. ../../../lib/functions.sh

PKG=library/python-2/tempora-27
PROG=tempora
VER=1.13
SUMMARY="tempora - Objects and routines pertaining to date and time"
DESC="$SUMMARY"

. $SRCDIR/../common.sh

RUN_DEPENDS_IPS="
    library/python-2/pytz-27
    library/python-2/jaraco.functools-27
"

init
download_source pymodules/$PROG $PROG $VER
patch_source
prep_build
python_build
strip_install
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
