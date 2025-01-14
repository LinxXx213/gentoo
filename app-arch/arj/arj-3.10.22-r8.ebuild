# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

PATCH_LEVEL=15
MY_P="${PN}_${PV}"

DESCRIPTION="Utility for opening arj archives"
HOMEPAGE="http://arj.sourceforge.net/"
SRC_URI="
	mirror://debian/pool/main/a/arj/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/a/arj/${MY_P}-${PATCH_LEVEL}.debian.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

PATCHES=(
	"${FILESDIR}/${P}-implicit-declarations.patch"
	"${FILESDIR}/${P}-glibc2.10.patch"
	"${WORKDIR}"/debian/patches/
	"${FILESDIR}/${P}-darwin.patch"
)

DOCS=( doc/compile.txt doc/debug.txt doc/glossary.txt doc/rev_hist.txt doc/xlation.txt )

src_prepare() {
	default
	cd gnu || die 'failed to change to the "gnu" directory'
	echo -n "" > stripgcc.lnk || die "failed to disable stripgcc.lnk"

	eautoreconf
}

src_configure() {
	cd gnu || die 'failed to change to the "gnu" directory'
	tc-export CC # Uses autoconf but not automake.
	econf
}
