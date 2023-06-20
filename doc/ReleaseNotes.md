<a href="https://omnios.org">
<img src="https://omnios.org/OmniOSce_logo.svg" height="128">
</a>

# Release Notes for OmniOSce v11 r151046

## r151046h (2023-06-20)
Weekly release for w/c 19th of June 2023.
> This update requires a reboot

### Security Fixes

* Python has been updated to version 3.11.4;

* Vim has been updated to version 9.0.1443.

### Other Changes

* SMB NetLogon Client Seal support;

* Windows clients could get disconnected when copying files to an SMB share;

* %ymm registers were not correctly restored after signal handler;

* The `svccfg` command now supports a `-z` flag to manage services within
  zones;

* The startup timeout for the `system/zones` service has been increased to
  resolve problems when starting a large number of bhyve zones in parallel in
  conjunction with a memory reservoir configuration;

* Use automatic IBRS when available;

* `blkdev` and `lofi` did not properly initialise cmlb minor nodes;

* The ping command would fail when invoked with `-I 0.01`;

* In exceptional circumstances, a zone could become stuck during halt due to
  lingering IP references;

* An issue with resolving DNS names which have only multiple AAAA records
  has been resolved;

* Improvements within the `nvme` driver to resolve a race and allow it to bind
  to devices that are under a legacy PCI root;

* In exception circumstances, the system could panic when dumping a userland
  process core.

<br>

---

## r151046e (2023-05-31)
Weekly release for w/c 29th of May 2023.
> This is a non-reboot update

### Security Fixes

* Curl has been updated to version 8.1.2, fixing
  [CVE-2023-28319](https://curl.se/docs/CVE-2023-28319.html),
  [CVE-2023-28320](https://curl.se/docs/CVE-2023-28320.html),
  [CVE-2023-28321](https://curl.se/docs/CVE-2023-28321.html),
  [CVE-2023-28322](https://curl.se/docs/CVE-2023-28322.html).

* OpenSSL has been updated to versions 1.1.1u and 3.0.9, fixing
  [CVE-2023-2650](https://www.openssl.org/news/secadv/20230530.txt).
  OpenSSL 1.0.2 has also been patched against this.

### Other Changes

<br>

---

Stable and Long-Term-Supported (LTS) Release, 1st of May 2023

`uname -a` shows `omnios-r151046-82ebda23c9`

r151046 release repository: https://pkg.omnios.org/r151046/core

## Upgrade Notes

Upgrades are supported from the r151038, r151040, r151042 and r151044 releases
only. If upgrading from an earlier version, upgrade in stages, referring to the
table at <https://omnios.org/upgrade>.

## New features since r151044

### System Features

* Python has been upgraded to version 3.11, replacing version 3.10 used in the
  previous release.

* NVMe devices are now identified using their namespace GUID, if supported.
  This may result in the device ID of any NVMe drives changing on the first
  boot into this release, with accompanying messages on the console.

* Joining a windows domain via `smbadm join` now automatically updates
  the local administrators group to include domain administrators. If
  necessary, `smbadm remove-member` can be used to adjust membership.

* SMB now supports 256-bit ciphers.

* SMB now has a new configuration option to enable support for short names.
  Only very old applications on old clients need short names, however it is
  necessary to support running the Windows Protocol Test Suites.

* The [omnios-build](https://github.com/omniosorg/omnios-build) framework has
  seen extensive changes as a result of introducing support for building
  packages for different architectures. Many packages can now be built for
  64-bit ARM by passing `-a aarch64` to the build script, and a regularly
  updated testing image is maintained at
  <https://downloads.omnios.org/media/braich/>.

### Commands and Command Options

* The `which` command has been replaced. The new version fixes a number of
  issues with the old but will no-longer show aliases when invoked from the
  csh.

* `csh` itself is now mediated and will automatically be replaced by `tcsh`
  if that package is installed. To switch /usr/bin/csh back to the illumos
  version, invoke:
  ```
  pfexec pkg set-mediator -I illumos csh
  ```

* `nvmeadm` has been updated to show and refer to namespaces by their
  namespace IDs, rather than an index. There have also been changes in the
  `list` sub-command to better support namespaces.

* `smbadm` has been enhanced with the ability to read credentials from stdin.

* The `ls` command can now show SIDs instead of ephemeral IDs. Refer to
  [ls(1)](https://man.omnios.org/ls), in particular the section that discusses
  the `-n` option.

* `pcieadm` has been updated so that its help messages include the list of
  available fields.

* `find`'s -useracl and -groupacl options could produce false positive matches
  due to ignoring an ACL entry's type.

* The `cxgbetool` command now accepts instance names rather than device paths,
  making it easier to use.

* The `media/cdrtools` package has been replaced by `media/xorriso` which
  provides compatible `cdrecord` and `mkisofs` utilities.

### Libraries and Library Functions

* The `isatty()` function has been updated so that it always sets `errno`
  when returning 0. Although both behaviours are compliant with the POSIX
  standard, some third party software incorrectly expects errno to be set.

* When retrieving a list of interface addresses via the `SIOCGLIFCONF` ioctl,
  the `sin6_scope_id` field is now filled in.

* libpcre2 now includes 16 and 32-bit character support.

### Zones

* There have been several improvements to zone networking so that links
  created directly within a zone are now properly cleaned up. In general,
  cleaning up links on zone halt is much improved.

### Bhyve

* The `virtio-viona` network driver now supports a control queue and
  promiscuous mode.

* A new `kstat` has been added to show details of the vmm reservoir.

* The virtio 9p buffers have been expanded to improve performance.

* bhyve supports more customisation of `smbios` data via the `-B` option
  and via configuration file directives.

* The emulated `nvme` driver has been updated as a result of additional
  compliance testing.

### ZFS

* The ZFS `autoexpand` property now works for root pools.

* It is now possible to directly import a root pool from a `/devices` path.

* `zpool list` no longer truncates long device names to 64 characters.

* `zfs allow` could display incorrect information for filesystems which had
  `allow -c` set but not `allow -s`.

### Package Management

* The `snoop` command has been split into its own package.

### Drivers

* The bundled firmware in the `cxgbe` driver has been updated to version
  1.27.1.0.

### Developer Features

* `ctfdump` now additionally displays bitfield member offsets in bytes and
  fractions of bytes.

* `errc`, `verrc`, `warnc` and `vwarnc` functions have been added to libc.

* `ld` now fills out more of the `PT_DYNAMIC` section which resolves
  inter-operability problems with recently released `binutils`.

* [intro(9F)](https://man.omnios.org/intro.9f) has been rewritten and
  extended to better introduce kernel programming topics.

* The `gcc12` compiler has a new `-fforce-omit-frame-pointer` that can be used
  for building things that absolutely require the frame pointer to be omitted.
  This hinders the debugability of the generated artefacts with tools such as
  `mdb` and `dtrace`.

* `gcc` has been updated to allow the `%h` and `%hh` length modifiers in
  kernel code.

### Deprecated features

* The `grub` boot loader is deprecated and is scheduled for removal in
  the r151048 release. It will be supported in r151046 for the full LTS time
  frame, up to May 2026. If you have not yet migrated to the new boot loader,
  and would like assistance, please
  [get in touch](https://omnios.org/about/contact).

* The Service Location Protocol (SLP) service that was provided by the
  `service/network/slp` package is no longer shipped with OmniOS. SLP is a
  legacy protocol that has a number of known security problems, such as
  [CVE-2023-29552](https://nvd.nist.gov/vuln/detail/CVE-2023-29552).

* OpenSSH in OmniOS no longer provides support for GSSAPI key exchange.
  This was removed in release r151038.

* Python 2 is now end-of-life and will not receive any further updates. The
  `python-27` package is still available for backwards compatibility but will
  be maintained only on a best-efforts basis.

* OpenSSL 1.0.x is deprecated and reached end-of-support at the end of 2019.
  OpenSSL 1.1.1 will reach end-of-support in September 2023.
  OmniOS has transitioned to OpenSSL 3 and still ships OpenSSL 1.1.1 for
  compatibility. The OpenSSL 1.0.2 libraries are also retained for
  backwards compatibility but are maintained solely on a best-efforts basis.

### Package changes

| Package | Old Version | New Version |
| :------ | :---------- | :---------- |
| compress/xz | 5.2.6 | 5.4.2
| data/iso-codes | 4.11.0 | 4.13.0
| database/sqlite-3 | 3.39.4 | 3.41.2
| developer/build/gnu-make | 4.3 | 4.4.1
| developer/gnu-binutils | 2.39 | 2.40
| developer/nasm | 2.15.5 | 2.16.1
| developer/swig | 4.0.2 | 4.1.1
| developer/versioning/git | 2.37.7 | 2.40.1
| developer/versioning/mercurial | 6.2.2 | 6.3.3
| file/gnu-coreutils | 9.1 | 9.3
| library/c++/sigcpp | 3.2.0 | 3.4.0
| library/expat | 2.4.9 | 2.5.0
| library/glib2 | 2.74.0 | 2.74.6
| library/libffi | 3.4.3 | 3.4.4
| library/mpc | 1.2.1 | 1.3.1
| library/mpfr | 4.1.0 | 4.2.0
| library/ncurses | 6.3 | 6.4
| library/nghttp2 | 1.50.0 | 1.52.0
| library/nspr | 4.34.1 | 4.35
| library/nspr/header-nspr | 4.34.1 | 4.35
| library/pcre2 | 10.40 | 10.42
| library/python-3/attrs-311 | 22.1.0 | 22.2.0
| library/python-3/coverage-311 | 6.4.4 | 7.2.2
| **library/python-3/crossenv-311** | _New_ | 1.4.0
| library/python-3/cryptography-311 | 38.0.1 | 39.0.2
| library/python-3/jsonschema-311 | 4.16.0 | 4.17.3
| library/python-3/meson-311 | 0.63.2 | 1.0.1
| library/python-3/orjson-311 | 3.8.0 | 3.8.8
| library/python-3/pip-311 | 22.2.2 | 23.0.1
| library/python-3/pycodestyle-311 | 2.9.1 | 2.10.0
| library/python-3/pyopenssl-311 | 22.0.0 | 23.0.0
| library/python-3/pyrsistent-311 | 0.18.1 | 0.19.3
| library/python-3/rapidjson-311 | 1.8 | 1.10
| library/python-3/setuptools-311 | 65.3.0 | 67.6.0
| library/python-3/typing-extensions-311 | 4.3.0 | 4.5.0
| library/readline | 8.1.2 | 8.2
| ~~media/cdrtools~~ | 3.1 | _Removed_
| **media/xorriso** | _New_ | 1.5.4.2
| network/dns/bind | 9.18.7 | 9.18.14
| network/openssh | 9.0.1 | 9.3.1
| network/openssh-server | 9.0.1 | 9.3.1
| network/rsync | 3.2.6 | 3.2.7
| network/service/isc-dhcp | 4.4.3 | 4.4.3.1
| **network/snoop** | _New_ | 0.5.11
| network/socat | 1.7.4.3 | 1.7.4.4
| ~~runtime/python-310~~ | 3.10.11 | _Removed_
| **runtime/python-311** | _New_ | 3.11.3
| security/sudo | 1.9.12.2 | 1.9.13.3
| service/network/ntpsec | 1.2.1 | 1.2.2
| ~~service/network/slp~~ | 0.5.11 | _Removed_
| shell/bash | 5.1.16 | 5.2.15
| shell/tcsh | 6.24.1 | 6.24.7
| system/bhyve/firmware | 20220329 | 20230201
| system/data/hardware-registry | 2022.9.9 | 2023.2.23
| system/data/urxvt-terminfo | 9.30 | 9.31
| system/library/dbus | 1.14.2 | 1.14.6
| system/library/libdbus | 1.14.2 | 1.14.6
| system/library/mozilla-nss | 3.83 | 3.89
| system/library/mozilla-nss/header-nss | 3.83 | 3.89
| system/library/pcap | 1.10.1 | 1.10.3
| system/management/cloud-init | 22.3 | 23.1.1
| system/pciutils | 3.8.0 | 3.9.0
| system/pciutils/pci.ids | 2.2.20220909 | 2.2.20230223
| system/rsyslog | 8.2208.0 | 8.2302.0
| system/test/fio | 3.32 | 3.34
| system/virtualization/open-vm-tools | 12.1.0 | 12.2.0
| text/gawk | 5.2.0 | 5.2.1
| text/gnu-diffutils | 3.8 | 3.9
| text/gnu-gettext | 0.21 | 0.21.1
| text/gnu-grep | 3.8 | 3.10
| text/gnu-sed | 4.8 | 4.9

