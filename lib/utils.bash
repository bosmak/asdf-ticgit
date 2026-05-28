#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/schacon/ticgit"
TOOL_NAME="ticgit"
TOOL_TEST="ti --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//'
}

list_all_versions() {
	# ticgit publishes all releases as GitHub tags (e.g. v0.3.1).
	list_github_tags
}

get_platform() {
	local os arch
	os=$(uname -s | tr '[:upper:]' '[:lower:]')
	arch=$(uname -m)

	# Normalize architecture to match Rust target triples.
	case "$arch" in
	x86_64 | amd64) arch="x86_64" ;;
	aarch64 | arm64) arch="aarch64" ;;
	*) fail "Unsupported architecture: $arch" ;;
	esac

	# Normalize OS to match Rust target triples.
	case "$os" in
	linux) os="unknown-linux-gnu" ;;
	darwin) os="apple-darwin" ;;
	mingw* | msys* | cygwin*) os="pc-windows-msvc" ;;
	*) fail "Unsupported OS: $os" ;;
	esac

	echo "${arch}-${os}"
}

get_download_url() {
	local version platform ext
	version="$1"
	platform="$2"

	case "$platform" in
	*windows*) ext="zip" ;;
	*) ext="tar.gz" ;;
	esac

	echo "$GH_REPO/releases/download/v${version}/${TOOL_NAME}-${platform}.${ext}"
}

download_release() {
	local version filename platform url
	version="$1"
	filename="$2"
	platform=$(get_platform)
	url=$(get_download_url "$version" "$platform")

	echo "* Downloading $TOOL_NAME release $version for $platform..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"

		# The tarball/zip contains a single binary named 'ti' (or 'ti.exe' on Windows).
		if [ -f "$ASDF_DOWNLOAD_PATH/ti" ]; then
			cp "$ASDF_DOWNLOAD_PATH/ti" "$install_path/ti"
		elif [ -f "$ASDF_DOWNLOAD_PATH/ti.exe" ]; then
			cp "$ASDF_DOWNLOAD_PATH/ti.exe" "$install_path/ti.exe"
		else
			fail "Could not find ti binary in download"
		fi

		chmod +x "$install_path/ti" 2>/dev/null || chmod +x "$install_path/ti.exe" 2>/dev/null || true

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
