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
# Copyright 2017 OmniTI Computer Consulting, Inc.  All rights reserved.
# Copyright 2022 OmniOS Community Edition (OmniOSce) Association.

. ../../lib/build.sh

PROG=dbus
VER=1.12.22
PKG=dbus ##IGNORE##
SUMMARY="filled in below"
DESC="$SUMMARY"

set_standard XPG6
CPPFLAGS+=" -D_REENTRANT"

CONFIGURE_OPTS="
    --with-dbus-daemondir=/usr/lib
    --bindir=/usr/bin
    --localstatedir=/var
    --libexecdir=/usr/libexec
    --with-x=no
    --with-dbus-user=root
    --disable-static
    --disable-inotify
"

export MAKE

build_manifests() {
    manifest_start $TMPDIR/manifest.dbus
    manifest_add_dir $PREFIX/bin
    manifest_add_dir etc/dbus-1
    manifest_add_dir lib/svc manifest/system method
    manifest_add $PREFIX/lib dbus-daemon
    manifest_add_dir $PREFIX/libexec
    manifest_add_dir $PREFIX/share xml/dbus-1
    manifest_add_dir $PREFIX/share/dbus-1 \
        services session.d system-services system.d
    manifest_add_dir var/lib dbus
    manifest_finalise $TMPDIR/manifest.dbus $PREFIX

    manifest_uniq $TMPDIR/manifest.{libdbus,dbus}
    manifest_finalise $TMPDIR/manifest.libdbus $PREFIX
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
run_testsuite check
make_isa_stub
install_smf system dbus.xml svc-dbus
build_manifests

PKG=system/library/dbus
SUMMARY="Simple IPC library based on messages"
DESC="A simple system for interprocess communication and coordination"
make_package -seed $TMPDIR/manifest.dbus dbus.mog

PKG=system/library/libdbus
SUMMARY+=" - client libraries"
DESC+=" - client libraries"
make_package -seed $TMPDIR/manifest.libdbus

clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
