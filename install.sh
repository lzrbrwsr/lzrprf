#!/bin/sh
# LZRBRWSR installer.
#
#     curl -fsSL https://lzrbrwsr.com/install.sh | sh
#
# Or read it first. The same file, with its SHA-256 and the SHA-256 of
# everything it installs, is published at https://github.com/henryverlin/lzrprf
# (install.sh and release.txt):
#
#     curl -fsSL https://lzrbrwsr.com/install.sh -o install.sh
#     shasum -a 256 install.sh
#     sh install.sh
#
# What it does, in order:
#   1. downloads lzrprf, the open container, from its public repository at one
#      fixed commit, and checks its two files against the checksums below;
#   2. downloads LZRBRWSR and checks it against the checksum below;
#   3. runs lzrprf's own self-test on this computer, and stops if one line fails;
#   4. checks what the icon will run: the download must hold exactly the five
#      files named below, and its launcher and its property list must be, byte
#      for byte, the two texts written out in this script;
#   5. puts lzrprf into ~/.lzrprf and LZRBRWSR.app into Applications, in place
#      of an older copy of either.
# If any step fails, nothing is installed. It never runs the closed program,
# asks for no password, reports nothing back, installs no updater and leaves
# nothing running. Updating is running it again.
#
# For tests, three variables change where it reads and writes: LZRBRWSR_BASE
# and LZRPRF_BASE (where the files come from; the checksums below must still
# match) and LZRBRWSR_DEST (the folder the app is put in). It says so when one
# of them is set.
#
# lzrprf is open source: https://github.com/henryverlin/lzrprf
# LZRBRWSR is proprietary software: free to use, never to resell or pass on.
# All rights reserved. The licence: https://lzrbrwsr.com/terms.html
set -eu

BASE="${LZRBRWSR_BASE:-https://lzrbrwsr.com}"
FILE="lzrbrwsr-macos-arm64.tar.gz"
SHA256="7ff04fb4d3ecf6afeddb5a59659d9691e8bb975da2930358316cb0d69e40774f"
LZRPRF_COMMIT="580ef5d3af4163c2978b67da7e010c1a3d206402"
LZRPRF_BASE="${LZRPRF_BASE:-https://raw.githubusercontent.com/henryverlin/lzrprf/$LZRPRF_COMMIT}"
LZRPRF_SHA256="c43a20dde491c9df450d19bec343dd9e1294b8640cb73d5e80ebfd50a2a4d3d7"
SELFTEST_SHA256="dcfb6799b566c4b837c338d156ca71c773f6e9c16cf7a133e9b41c00392e9937"

# Colour only when a person is looking at a terminal.
if [ -t 1 ]; then
	G="$(printf '\033[38;5;46m')" B="$(printf '\033[1;97m')" N="$(printf '\033[0m')"
else
	G="" B="" N=""
fi

cat <<ART

 ${G}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${N}
 ${G}┃${N}                                                                            ${G}┃${N}
 ${G}┃     ██╗     ███████╗██████╗ ██████╗ ██████╗ ██╗    ██╗███████╗██████╗      ┃${N}
 ${G}┃     ██║     ╚══███╔╝██╔══██╗██╔══██╗██╔══██╗██║    ██║██╔════╝██╔══██╗     ┃${N}
 ${G}┃ ▒▓█ ██║       ███╔╝ ██████╔╝██████╔╝██████╔╝██║ █╗ ██║███████╗██████╔╝ ▒▓█ ┃${N}
 ${G}┃     ██║      ███╔╝  ██╔══██╗██╔══██╗██╔══██╗██║███╗██║╚════██║██╔══██╗     ┃${N}
 ${G}┃     ███████╗███████╗██║  ██║██████╔╝██║  ██║╚███╔███╔╝███████║██║  ██║     ┃${N}
 ${G}┃     ╚══════╝╚══════╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝     ┃${N}
 ${G}┃${N}                                                                            ${G}┃${N}
 ${G}┃  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  ┃${N}
 ${G}┃${N}                                                                            ${G}┃${N}
 ${G}┃${B}  EVERY BROWSER ASKS FOR YOUR TRUST.  THIS ONE HANDS YOU THE PROOF.         ${N}${G}┃${N}
 ${G}┃${N}                                                                            ${G}┃${N}
 ${G}┃${N}  Your browser sees everything: what you read, what you type, where         ${G}┃${N}
 ${G}┃${N}  you go. Until now you could only believe what it does with that.          ${G}┃${N}
 ${G}┃${N}                                                                            ${G}┃${N}
 ${G}┃${N}  LZRBRWSR runs locked inside lzrprf, a small open container that           ${G}┃${N}
 ${G}┃${N}  anyone can read and any AI can audit in minutes. The browser is           ${G}┃${N}
 ${G}┃${N}  closed. Its cage is not.                                                  ${G}┃${N}
 ${G}┃${N}                                                                            ${G}┃${N}
 ${G}┃${N}   ▸ The browser has no network at all. lzrprf fetches the address          ${G}┃${N}
 ${G}┃${N}     you type into a window of its own, and only that.                      ${G}┃${N}
 ${G}┃${N}   ▸ Every address is written down before it is fetched, in a log           ${G}┃${N}
 ${G}┃${N}     the browser cannot touch and only you can clear.                       ${G}┃${N}
 ${G}┃${N}   ▸ It cannot read your files or your clipboard, cannot write a            ${G}┃${N}
 ${G}┃${N}     file, cannot start a program.                                          ${G}┃${N}
 ${G}┃${N}   ▸ Every page is treated as hostile: each is read in a sealed             ${G}┃${N}
 ${G}┃${N}     box of its own, and the box is thrown away.                            ${G}┃${N}
 ${G}┃${N}   ▸ The browser keeps nothing: no cookies, no account, no                  ${G}┃${N}
 ${G}┃${N}     telemetry. The one record is that log, on your computer.               ${G}┃${N}
 ${G}┃${N}   ▸ Version one shows a page as its source text. Nothing a page            ${G}┃${N}
 ${G}┃${N}     sends is ever run.                                                     ${G}┃${N}
 ${G}┃${N}                                                                            ${G}┃${N}
 ${G}┃${N}  You do not have to take our word for any of it.                           ${G}┃${N}
 ${G}┃${N}                                                                            ${G}┃${N}
 ${G}┃${N}  Read the container   https://github.com/henryverlin/lzrprf                ${G}┃${N}
 ${G}┃${N}  Get the browser      https://lzrbrwsr.com                                 ${G}┃${N}
 ${G}┃${N}                                                                            ${G}┃${N}
 ${G}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${N}

ART

step() { printf '  %s▸%s %s\n' "$G" "$N" "$1"; }
stop() {
	printf '\n  LZRBRWSR: %s Nothing was installed.\n\n' "$1" >&2
	exit 1
}

[ "$(uname -s)" = "Darwin" ] && [ "$(uname -m)" = "arm64" ] || stop "so far only macOS on Apple silicon is built."
for part in perl sandbox-exec curl osascript openssl; do
	[ -x "/usr/bin/$part" ] || stop "this Mac lacks /usr/bin/$part, which lzrprf or its self-test is made of."
done

[ -z "${LZRBRWSR_BASE:-}${LZRPRF_BASE:-}${LZRBRWSR_DEST:-}" ] || step "test settings are in use: files from $BASE and $LZRPRF_BASE, the app into ${LZRBRWSR_DEST:-Applications}"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
sum() { shasum -a 256 "$1" | cut -d' ' -f1; }

# get <address> <file> <checksum> <what it is>
get() {
	curl -fsSL "$1" -o "$tmp/$2" || stop "could not download $4."
	[ "$(sum "$tmp/$2")" = "$3" ] || stop "$4 does not match its checksum."
}

get "$LZRPRF_BASE/lzrprf" lzrprf "$LZRPRF_SHA256" "lzrprf"
get "$LZRPRF_BASE/selftest" selftest "$SELFTEST_SHA256" "lzrprf's self-test"
step "lzrprf downloaded, and it is the published one (commit $(printf %.12s "$LZRPRF_COMMIT"))"
get "$BASE/$FILE" "$FILE" "$SHA256" "the download"
step "LZRBRWSR downloaded, and it matches its checksum"

# The container proves itself on this computer before anything is put in place:
# a hostile program is run inside it and every one of its attempts must be refused.
step "attacking lzrprf on this computer, about a minute"
if /usr/bin/perl "$tmp/selftest" >"$tmp/selftest.out" 2>&1; then
	step "lzrprf self-test on this computer: all $(grep -c '^held' "$tmp/selftest.out") attacks held"
else
	grep '^FAILED' "$tmp/selftest.out" >&2 || true
	stop "lzrprf's self-test did not hold on this computer."
fi

# LZRBRWSR_DEST names another folder to install into; the default is Applications.
dest="${LZRBRWSR_DEST:-/Applications}"
if [ ! -w "$dest" ]; then
	dest="$HOME/Applications"
	mkdir -p "$dest"
fi

# What the icon will run is checked before anything is put in place. The
# download must name these five files, the four folders they are in, and
# nothing else. It is unpacked into an empty folder of its own, so that nothing
# in it can take the place of a file that was checked above.
names="$(tar -tzf "$tmp/$FILE" | LC_ALL=C sort | tr '\n' ' ')"
[ "$names" = "LZRBRWSR.app/ LZRBRWSR.app/Contents/ LZRBRWSR.app/Contents/Info.plist LZRBRWSR.app/Contents/MacOS/ LZRBRWSR.app/Contents/MacOS/lzrbrwsr LZRBRWSR.app/Contents/MacOS/lzrbrwsr-bin LZRBRWSR.app/Contents/Resources/ LZRBRWSR.app/Contents/Resources/LICENSE.txt LZRBRWSR.app/Contents/Resources/lzrbrwsr.icns " ] || stop "the download holds files that do not belong in it."
mkdir "$tmp/unpacked"
tar -xzf "$tmp/$FILE" -C "$tmp/unpacked"
[ "$(cd "$tmp/unpacked" && find . ! -type d | LC_ALL=C sort | tr '\n' ' ')" = "./LZRBRWSR.app/Contents/Info.plist ./LZRBRWSR.app/Contents/MacOS/lzrbrwsr ./LZRBRWSR.app/Contents/MacOS/lzrbrwsr-bin ./LZRBRWSR.app/Contents/Resources/LICENSE.txt ./LZRBRWSR.app/Contents/Resources/lzrbrwsr.icns " ] || stop "the download holds files that do not belong in it."
[ -z "$(find "$tmp/unpacked" ! -type d ! -type f)" ] || stop "the download holds a link."
# The launcher is the file the icon runs. This is all of it: it starts lzrprf,
# and lzrprf starts the program. The one in the download must be the same.
cat >"$tmp/launcher" <<'LAUNCHER'
#!/bin/sh
# LZRBRWSR starts here, and only here. This file is plain text so that you
# can read what the icon runs: lzrprf, the open container
# (https://github.com/henryverlin/lzrprf), and inside it the program,
# lzrbrwsr-bin, which stands beside this file.
#
# lzrprf gives the program no network. The address you type into lzrprf's
# own window is fetched by lzrprf itself, and written down first:
#
#     perl ~/.lzrprf/lzrprf log
#
# Without lzrprf the program is not started at all.
here="$(cd "$(dirname "$0")" && pwd -P)"
lzrprf="$HOME/.lzrprf/lzrprf"
if [ ! -f "$lzrprf" ]; then
	/usr/bin/osascript -e 'display alert "LZRBRWSR needs lzrprf" message "lzrprf, the open container LZRBRWSR runs in, is not on this computer, and LZRBRWSR does not start without it. Run the install line again: it is on https://lzrbrwsr.com"' >/dev/null 2>&1
	exit 1
fi
exec /usr/bin/perl "$lzrprf" run "$here/lzrbrwsr-bin" "$@"
LAUNCHER
cmp -s "$tmp/launcher" "$tmp/unpacked/LZRBRWSR.app/Contents/MacOS/lzrbrwsr" || stop "the icon would not start LZRBRWSR through lzrprf."
# The property list tells macOS which file the icon runs, and it could also set
# variables for it. This is all of it: it names the launcher and sets none.
cat >"$tmp/plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleExecutable</key>
	<string>lzrbrwsr</string>
	<key>CFBundleIdentifier</key>
	<string>com.lzrbrwsr.browser</string>
	<key>CFBundleName</key>
	<string>LZRBRWSR</string>
	<key>CFBundleDisplayName</key>
	<string>LZRBRWSR</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleShortVersionString</key>
	<string>0.1.0</string>
	<key>CFBundleVersion</key>
	<string>1</string>
	<key>CFBundleIconFile</key>
	<string>lzrbrwsr</string>
	<key>LSArchitecturePriority</key>
	<array>
		<string>arm64</string>
	</array>
	<key>LSMinimumSystemVersion</key>
	<string>11.0</string>
	<key>NSHighResolutionCapable</key>
	<true/>
	<key>NSPrincipalClass</key>
	<string>NSApplication</string>
	<key>NSHumanReadableCopyright</key>
	<string>Proprietary. All rights reserved. No licence is granted.</string>
</dict>
</plist>
PLIST
cmp -s "$tmp/plist" "$tmp/unpacked/LZRBRWSR.app/Contents/Info.plist" || stop "the app's property list is not the one written out in the installer."
step "the icon runs one thing: lzrprf, and inside it LZRBRWSR"

# lzrprf is checked once more, at the moment it is put in place.
[ "$(sum "$tmp/lzrprf")" = "$LZRPRF_SHA256" ] && [ "$(sum "$tmp/selftest")" = "$SELFTEST_SHA256" ] || stop "lzrprf changed while it was being installed."
mkdir -p "$HOME/.lzrprf"
chmod 700 "$HOME/.lzrprf"
cp "$tmp/lzrprf" "$tmp/selftest" "$HOME/.lzrprf/"
rm -f "$HOME/.lzrprf/rules"	# a list of allowed hosts, kept by an earlier lzrprf; this one keeps none
rm -rf "$dest/LZRBRWSR.app"
mv "$tmp/unpacked/LZRBRWSR.app" "$dest/LZRBRWSR.app"
step "lzrprf is installed:    $HOME/.lzrprf/lzrprf"
step "LZRBRWSR is installed:  $dest/LZRBRWSR.app"

cat <<DONE

  Open LZRBRWSR from Applications. To go somewhere, press its address line:
  lzrprf opens a window of its own, and you type the address there. The
  browser cannot type, press or read in that window, and it has no network:
  lzrprf fetches what you typed, and writes it down first. To read that log:

      ${B}perl ~/.lzrprf/lzrprf log${N}

  LZRBRWSR is not signed by an Apple developer identity and not notarized.
  What vouches for it is lzrprf, which you can read. To have your own AI
  check that all of this is true, copy the prompt from
  https://github.com/henryverlin/lzrprf

DONE
