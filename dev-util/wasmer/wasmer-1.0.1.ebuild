# Copyright 2017-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# rq -tJ <Cargo.lock | jq -r '.package[] | "\(.name)-\(.version)"'
# Not sure if all of these are required
CRATES="
abort_on_panic-2.0.0
addr2line-0.14.0
adler-0.2.3
ahash-0.3.8
ahash-0.4.6
aho-corasick-0.7.15
ansi_term-0.11.0
anyhow-1.0.35
arrayref-0.3.6
arrayvec-0.5.2
assert_cmd-1.0.2
atty-0.2.14
autocfg-0.1.7
autocfg-1.0.1
backtrace-0.3.55
base64-0.13.0
bincode-1.3.1
bitflags-1.2.1
blake2b_simd-0.5.11
blake3-0.3.7
bstr-0.2.14
build-deps-0.1.4
bumpalo-3.4.0
byteorder-1.3.4
bytesize-1.0.1
cast-0.2.3
cbindgen-0.15.0
cc-1.0.66
cfg-if-0.1.10
cfg-if-1.0.0
clap-2.33.3
cloudabi-0.0.3
colored-1.9.3
colored-2.0.0
compiletest_rs-0.5.0
const_fn-0.4.3
constant_time_eq-0.1.5
cranelift-bforest-0.67.0
cranelift-bforest-0.68.0
cranelift-codegen-0.67.0
cranelift-codegen-0.68.0
cranelift-codegen-meta-0.67.0
cranelift-codegen-meta-0.68.0
cranelift-codegen-shared-0.67.0
cranelift-codegen-shared-0.68.0
cranelift-entity-0.67.0
cranelift-entity-0.68.0
cranelift-frontend-0.68.0
crc32fast-1.2.1
criterion-0.3.3
criterion-plot-0.4.3
crossbeam-channel-0.5.0
crossbeam-deque-0.8.0
crossbeam-epoch-0.9.1
crossbeam-utils-0.8.1
crypto-mac-0.8.0
csv-1.1.5
csv-core-0.1.10
ctor-0.1.16
darling-0.10.2
darling_core-0.10.2
darling_macro-0.10.2
diff-0.1.12
difference-2.0.0
digest-0.9.0
dirs-2.0.2
dirs-sys-0.3.5
distance-0.4.0
doc-comment-0.3.3
downcast-rs-1.2.0
dynasm-1.0.0
dynasmrt-1.0.0
either-1.6.1
erased-serde-0.3.12
fallible-iterator-0.2.0
fern-0.6.0
filetime-0.2.13
float-cmp-0.8.0
fnv-1.0.7
fuchsia-cprng-0.1.1
generational-arena-0.2.8
generic-array-0.14.4
getopts-0.2.21
getrandom-0.1.15
getrandom-0.2.0
ghost-0.1.2
gimli-0.21.0
gimli-0.22.0
gimli-0.23.0
glob-0.3.0
goblin-0.2.3
half-1.6.0
hashbrown-0.7.2
hashbrown-0.9.1
heck-0.3.1
hermit-abi-0.1.17
hex-0.4.2
ident_case-1.0.1
indexmap-1.6.0
inkwell-0.1.0-llvm10sample
inkwell_internals-0.2.0
inline-c-0.1.4
inline-c-macro-0.1.0
instant-0.1.9
inventory-0.1.9
inventory-impl-0.1.9
itertools-0.9.0
itoa-0.4.6
js-sys-0.3.46
lazy_static-1.4.0
leb128-0.2.4
libc-0.2.81
libffi-1.0.0
libffi-sys-1.1.0
libloading-0.6.6
llvm-sys-100.2.0
lock_api-0.4.2
log-0.4.11
mach-0.3.2
make-cmd-0.1.0
maybe-uninit-2.0.0
memchr-2.3.4
memmap-0.7.0
memmap2-0.2.0
memoffset-0.6.1
minifb-0.19.1
miniz_oxide-0.4.3
miow-0.3.6
more-asserts-0.2.1
nix-0.17.0
nom-6.0.1
normalize-line-endings-0.3.0
num-0.1.42
num-integer-0.1.44
num-iter-0.1.42
num-traits-0.2.14
num_cpus-1.13.0
object-0.22.0
once_cell-1.5.2
oorandom-11.1.3
orbclient-0.3.27
parking_lot-0.11.1
parking_lot_core-0.8.1
paste-1.0.4
pest-2.1.3
pin-project-lite-0.2.0
pkg-config-0.3.19
plain-0.2.3
plotters-0.2.15
ppv-lite86-0.2.10
predicates-1.0.5
predicates-core-1.0.0
predicates-tree-1.0.0
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro2-1.0.24
quote-1.0.7
rand-0.6.5
rand-0.7.3
rand_chacha-0.1.1
rand_chacha-0.2.2
rand_core-0.3.1
rand_core-0.4.2
rand_core-0.5.1
rand_hc-0.1.0
rand_hc-0.2.0
rand_isaac-0.1.1
rand_jitter-0.1.4
rand_os-0.1.3
rand_pcg-0.1.2
rand_xorshift-0.1.1
raw-cpuid-7.0.3
raw-window-handle-0.3.3
rayon-1.5.0
rayon-core-1.9.0
rdrand-0.4.0
redox_syscall-0.1.57
redox_users-0.3.5
ref_thread_local-0.0.0
regalloc-0.0.30
regalloc-0.0.31
regex-1.4.2
regex-automata-0.1.9
regex-syntax-0.6.21
region-2.2.0
remove_dir_all-0.5.3
rust-argon2-0.8.3
rustc-demangle-0.1.18
rustc-hash-1.1.0
rustc_version-0.2.3
rustc_version-0.3.0
rustfix-0.5.1
ryu-1.0.5
same-file-1.0.6
scopeguard-1.1.0
scroll-0.10.2
scroll_derive-0.10.4
sdl2-0.32.2
sdl2-sys-0.32.6
semver-0.9.0
semver-0.11.0
semver-parser-0.7.0
semver-parser-0.10.1
serde-1.0.118
serde_bytes-0.11.5
serde_cbor-0.11.1
serde_derive-1.0.118
serde_json-1.0.60
smallvec-1.6.1
socket2-0.3.17
stable_deref_trait-1.2.0
strsim-0.8.0
strsim-0.9.3
structopt-0.3.21
structopt-derive-0.4.14
subtle-2.3.0
syn-1.0.54
target-lexicon-0.11.1
tempfile-3.1.0
term-0.6.1
test-generator-0.1.0
tester-0.7.0
textwrap-0.11.0
thiserror-1.0.22
thiserror-impl-1.0.22
thread_local-1.0.1
time-0.1.44
tinytemplate-1.1.0
toml-0.5.7
tracing-0.1.22
tracing-attributes-0.1.11
tracing-core-0.1.17
treeline-0.1.0
typenum-1.12.0
typetag-0.1.6
typetag-impl-0.1.6
ucd-trie-0.1.3
unicode-segmentation-1.7.1
unicode-width-0.1.8
unicode-xid-0.2.1
vec_map-0.8.2
version_check-0.9.2
void-1.0.2
wait-timeout-0.2.0
walkdir-2.3.1
wasi-0.9.0+wasi-snapshot-preview1
wasi-0.10.0+wasi-snapshot-preview1
wasm-bindgen-0.2.69
wasm-bindgen-backend-0.2.69
wasm-bindgen-macro-0.2.69
wasm-bindgen-macro-support-0.2.69
wasm-bindgen-shared-0.2.69
wasmer-1.0.1
wasmer-c-api-1.0.1
wasmer-cache-1.0.1
wasmer-compiler-1.0.1
wasmer-compiler-cranelift-1.0.1
wasmer-compiler-llvm-1.0.1
wasmer-compiler-singlepass-1.0.1
wasmer-derive-1.0.1
wasmer-emscripten-1.0.1
wasmer-engine-1.0.1
wasmer-engine-jit-1.0.1
wasmer-engine-native-1.0.1
wasmer-engine-object-file-1.0.1
wasmer-middlewares-1.0.1
wasmer-object-1.0.1
wasmer-types-1.0.1
wasmer-vm-1.0.1
wasmer-wasi-1.0.1
wasmer-wasi-experimental-io-devices-1.0.1
wasmer_enumset-1.0.1
wasmer_enumset_derive-0.5.0
wasmparser-0.65.0
wast-24.0.0
wast-28.0.0
wat-1.0.29
wayland-client-0.27.0
wayland-commons-0.27.0
wayland-cursor-0.27.0
wayland-protocols-0.27.0
wayland-scanner-0.27.0
wayland-sys-0.27.0
web-sys-0.3.46
which-4.0.2
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
x11-dl-2.18.5
xcursor-0.3.3
xkb-0.2.1
xkbcommon-sys-0.7.4
xml-rs-0.8.3
"

inherit cargo

DESCRIPTION="universal web assembly runtime"
HOMEPAGE="https://wasmer.io"
SRC_URI="https://github.com/wasmerio/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="MIT Apache-2.0 BSD-2 ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="llvm +cranelift +singlepass debug-wasm"
REQUIRED_USE=""

BDEPEND="
	dev-util/cmake
	>=virtual/rust-1.37.0
	llvm? ( || (
		sys-devel/llvm:10[llvm_targets_X86,llvm_targets_AArch64]
		sys-devel/llvm:11[llvm_targets_X86,llvm_targets_AArch64]
	) )
"
# rust version is probably not sufficient, but wasmer doesn't indicate a minimum
# inkwell seems to have some odd link dependencies on llvm.

src_prepare() {
	[[ "${PV}" == *9999* ]] || ln -s ../${P}-git-deps "${ECARGO_HOME}"/git
	default
}

cargo_do() {
	if use llvm; then
		export RUSTFLAGS="$(echo "$RUSTFLAGS" $(llvm-config --ldflags) $(llvm-config --libs engine))"
		# For some reason, inkwell doesn't pick up the llvm link flags correctly
	fi
	cmd=$1
	shift
	RUSTFLAGS="$RUSTFLAGS" \
		cargo_$cmd \
		--bin wasmer \
		--features "
			$(usex cranelift cranelift "")
			$(usex llvm llvm "")
			$(usex singlepass singlepass "")
			$(usex debug-wasm debug "")
		" "$@"
}

src_compile() {
	cargo_do src_compile --manifest-path lib/cli/Cargo.toml
}

src_install() {
	cargo_do src_install --path lib/cli/
	einstalldocs
}
