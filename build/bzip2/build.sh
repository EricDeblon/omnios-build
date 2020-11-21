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
# Copyright 2011-2012 OmniTI Computer Consulting, Inc.  All rights reserved.
# Copyright 2019 OmniOS Community Edition (OmniOSce) Association.

. ../../lib/functions.sh

PROG=bzip2
VER=1.0.8
PKG=compress/bzip2
SUMMARY="The bzip compression utility"
DESC="A patent free high-quality data compressor"

SKIP_LICENCES=bzip2
XFORM_ARGS="-D VER=$VER"

# We don't use configure, so explicitly export PREFIX
PREFIX=/usr
export PREFIX
export CC

# 32-bit build uses -nostdlib
set_ssp none

base_CFLAGS="$CFLAGS -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -Wall -Winline"

configure32() {
    BINISA=$ISAPART
    LIBISA=""
    CFLAGS="$CFLAGS32 $base_CFLAGS"
    LDFLAGS="$LDFLAGS $LDFLAGS32"
    export BINISA LIBISA CFLAGS LDFLAGS
}

configure64() {
    BINISA=$ISAPART64
    LIBISA=$ISAPART64
    CFLAGS="$CFLAGS64 $base_CFLAGS"
    LDFLAGS="$LDFLAGS $LDFLAGS64"
    export BINISA LIBISA CFLAGS LDFLAGS
}

save_function make_clean _make_clean
make_clean() {
    _make_clean
    logcmd $MAKE -f Makefile-libbz2_so clean
}

# We need to build the shared lib using a second Makefile
make_shlib() {
    logmsg "--- make (shared lib)"
    OLD_CFLAGS=$CFLAGS
    CFLAGS="-fPIC $CFLAGS"
    export CFLAGS
    logcmd $MAKE $MAKE_JOBS -f Makefile-libbz2_so || \
        logerr "--- Make failed (shared lib)"
    CFLAGS=$OLD_CFLAGS
    export CFLAGS
}

make_shlib_install() {
    logmsg "--- make install (shared lib)"
    logcmd $MAKE DESTDIR=${DESTDIR} -f Makefile-libbz2_so install || \
        logerr "--- Make install failed (shared lib)"
}

save_function make_prog32 _make_prog32
make_prog32() {
    make_shlib
    _make_prog32
}

save_function make_prog64 _make_prog64
make_prog64() {
    make_shlib
    _make_prog64
}

TESTSUITE_SED="
    /in business/q
"

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
strip_install
run_testsuite
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
