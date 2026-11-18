#!/bin/sh
# LZRBRWSR installer.
#
# It runs from a file and never from a pipe, so that what runs is something
# you can read and check first. In Terminal:
#
#     curl -fsSLO https://lzrbrwsr.com/install.sh &&
#     curl -fsSL https://raw.githubusercontent.com/henryverlin/lzrprf/main/install.sh | cmp - install.sh &&
#     sh install.sh
#
# The first line saves this file. The second compares it, byte for byte, with
# the copy in a second place: lzrprf's public repository on GitHub, where
# every change to it is on record. It prints nothing when the two are the
# same, and the third line runs only then. Your own shell makes that
# comparison, before a byte of this file has run; this file cannot make it for
# you, because a changed file would simply say yes. Then this file asks you,
# on your terminal, whether to print the whole script here first, and then
# whether to run it.
#
# What it does, in order:
#   1. asks you the two questions;
#   2. stops if the LZRBRWSR that is installed is a newer release than this one;
#   3. downloads lzrprf, the open container, from its public repository at one
#      fixed commit, and checks its two files against the checksums below;
#   4. downloads LZRBRWSR and checks it against the checksum below;
#   5. checks what the icon will run: the download must hold exactly the six
#      files named below, and its launcher, its property list and its release
#      file must be, byte for byte, the three texts written out in this script;
#   6. when this release would replace the lzrprf that is installed with
#      another one, says so and asks: the container is never changed silently;
#   7. runs lzrprf's own self-test on this computer, and stops if one line fails;
#   8. only then puts lzrprf into ~/.lzrprf and LZRBRWSR.app into Applications.
#      Each new file is first written beside the one it replaces and takes its
#      name in one step, so an older copy stays whole until the new one is;
#   9. asks whether to put LZRBRWSR in the Dock, and does so only on a yes.
# If a step before step 8 fails, nothing was changed. It never runs the closed
# program, asks for no password, reports nothing back, installs no updater and
# leaves nothing running. LZRBRWSR never updates itself: when you allowed it,
# lzrprf looks whether a newer release is published, and offers to fetch this
# installer into a file and run it in Terminal, with the same steps and the
# same questions.
#
# For tests, five variables change what it does: LZRBRWSR_BASE and LZRPRF_BASE
# (where the files come from; the checksums below must still match),
# LZRBRWSR_DEST (the folder the app is put in), LZRBRWSR_DOCK (a file that
# stands for the Dock's settings) and LZRBRWSR_UNATTENDED (ask nothing, and
# leave the Dock alone). It says so when one of them is set.
#
# lzrprf is open source: https://github.com/henryverlin/lzrprf
# LZRBRWSR is proprietary software: free to use, never to resell or pass on.
# All rights reserved. The licence: https://lzrbrwsr.com/terms.html
set -eu
PATH=/usr/bin:/bin:/usr/sbin:/sbin	# the system's own tools, whatever your shell was set to find first
export PATH
umask 022

BASE="${LZRBRWSR_BASE:-https://lzrbrwsr.com}"
FILE="lzrbrwsr-macos-arm64.tar.gz"
SHA256="67c57f0cc2a686ee52f343694414d2b894b157f7eff45dee2d6e8aa6351756b5"
RELEASE="5"
LZRPRF_COMMIT="4b7e66f464cd338d17422b68f564e0e50e3089e5"
LZRPRF_BASE="${LZRPRF_BASE:-https://raw.githubusercontent.com/henryverlin/lzrprf/$LZRPRF_COMMIT}"
LZRPRF_SHA256="2cbe0f655c777dd186b0304681b6ffc5a18e69b4c4bfb2d1b8b64a9661ec60f6"
SELFTEST_SHA256="c6a3c585ac159cb0b81a3852dce52ff277ece72e0b292e0dafc8f06fe7e8e607"

# Outside the tests, files come over https and nothing else, also when an
# address sends on to another. curl reads no settings file of yours (-q).
if [ -z "${LZRBRWSR_BASE:-}${LZRPRF_BASE:-}" ]; then
	fetch() { curl -q -fsSL --proto '=https' --proto-redir '=https' --tlsv1.2 --connect-timeout 30 --max-time 900 --max-filesize 209715200 "$1" -o "$2"; }
else
	fetch() { curl -q -fsSL --connect-timeout 30 --max-time 900 "$1" -o "$2"; }
fi

# From a pipe there is no file that could be shown to you or checked. So
# nothing runs, and it says how to get the file.
if [ ! -f "$0" ] || [ "$(sed -n 2p "$0" 2>/dev/null)" != "# LZRBRWSR installer." ]; then
	cat >/dev/null 2>&1 || true	# what is left of the pipe is not read as a script
	printf '\n  LZRBRWSR: this installer runs from a file, not from a pipe, so that you can\n  read and check what runs. Nothing was installed. In Terminal:\n\n      curl -fsSLO https://lzrbrwsr.com/install.sh &&\n      curl -fsSL https://raw.githubusercontent.com/henryverlin/lzrprf/main/install.sh | cmp - install.sh &&\n      sh install.sh\n\n  What the middle line checks: https://github.com/henryverlin/lzrprf#the-installer\n\n' >&2
	exit 1
fi

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
 ${G}┃${B}  OTHER BROWSERS PROTECT YOU FROM THE WEB.  NOT FROM THEMSELVES.            ${N}${G}┃${N}
 ${G}┃${B}  THIS ONE PROTECTS YOU FROM ITSELF, TOO.  AND GIVES YOU THE PROOF.         ${N}${G}┃${N}
 ${G}┃${N}                                                                            ${G}┃${N}
 ${G}┃${N}  Your browser sees everything: what you read, what you type, where         ${G}┃${N}
 ${G}┃${N}  you go. Until now you could only believe what it does with that.          ${G}┃${N}
 ${G}┃${N}                                                                            ${G}┃${N}
 ${G}┃${N}  LZRBRWSR runs locked inside lzrprf, an open container that you or         ${G}┃${N}
 ${G}┃${N}  an AI can audit. The browser is closed to protect our innovations.        ${G}┃${N}
 ${G}┃${N}  The cage is open so you can verify its safety.                            ${G}┃${N}
 ${G}┃${N}                                                                            ${G}┃${N}
 ${G}┃${N}   ▸ The browser has no network and no window. lzrprf owns the one          ${G}┃${N}
 ${G}┃${N}     window, and fetches the address you type into its bar. Only that.      ${G}┃${N}
 ${G}┃${N}   ▸ Every address is written down before it is fetched, in a log           ${G}┃${N}
 ${G}┃${N}     the browser cannot touch and only you can clear.                       ${G}┃${N}
 ${G}┃${N}   ▸ It cannot read your files or your clipboard, cannot write a            ${G}┃${N}
 ${G}┃${N}     file, cannot start a program.                                          ${G}┃${N}
 ${G}┃${N}   ▸ Every page is treated as hostile: each is read in a sealed             ${G}┃${N}
 ${G}┃${N}     box of its own, and the box is thrown away.                            ${G}┃${N}
 ${G}┃${N}   ▸ The browser keeps nothing: no cookies, no account, no                  ${G}┃${N}
 ${G}┃${N}     telemetry. The one record is that log, on your computer.               ${G}┃${N}
 ${G}┃${N}   ▸ Version one lays a page out as text, with a grey box where             ${G}┃${N}
 ${G}┃${N}     a picture stands. Nothing a page sends is ever run.                    ${G}┃${N}
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

[ -z "${LZRBRWSR_BASE:-}${LZRPRF_BASE:-}${LZRBRWSR_DEST:-}${LZRBRWSR_DOCK:-}${LZRBRWSR_UNATTENDED:-}" ] || step "test settings are in use: files from $BASE and $LZRPRF_BASE, the app into ${LZRBRWSR_DEST:-Applications}${LZRBRWSR_UNATTENDED:+, and no question is asked}"
[ ! -L "$HOME/.lzrprf" ] || stop ".lzrprf in your home folder is a link to somewhere else, and lzrprf keeps its files in a folder of its own."

sum() { shasum -a 256 "$1" | cut -d' ' -f1; }

# The two questions. They are asked on your terminal and answered from it, so
# nothing that was piped into this script can answer for you.
ask() {
	while :; do
		printf '  %s [y/n] ' "$1" >/dev/tty
		read -r answer </dev/tty || stop "no answer came from the terminal."
		case "$answer" in
		y | Y | yes | Yes | YES) return 0 ;;
		n | N | no | No | NO) return 1 ;;
		esac
	done
}
if [ -z "${LZRBRWSR_UNATTENDED:-}" ]; then
	(: >/dev/tty) 2>/dev/null || stop "there is no terminal to ask you on, and this script runs only after you said so."
	printf '  This installer is the file %s\n  Its SHA-256 is %s\n  The published one: install.sh and release.txt at https://github.com/henryverlin/lzrprf\n  Only your own comparison counts: a changed installer could print anything here.\n\n' "$0" "$(sum "$0")" >/dev/tty
	if ask "Print the whole script here, before anything runs?"; then
		# Every byte of the file, except control characters, which could hide a line from you. It holds none.
		LC_ALL=C tr -d '\000-\010\013-\037\177' <"$0" >/dev/tty
		printf '\n' >/dev/tty
		ask "That was all of it. Run it now?" || stop "you said no."
	fi
fi

# Where the app goes: Applications, or your own Applications folder when that one is not yours to
# write. LZRBRWSR_DEST names another folder, for tests.
dest="${LZRBRWSR_DEST:-/Applications}"
[ -w "$dest" ] || dest="$HOME/Applications"

# An older release is never put over a newer one: not by a mistake, and not by somebody who serves
# you an old installer on purpose. The release that is installed says its number in a plain file.
installed="$(sed -n 's/^release \([0-9]\{1,6\}\)$/\1/p' "$dest/LZRBRWSR.app/Contents/Resources/release" 2>/dev/null | sed -n 1p)"
if [ -n "$installed" ] && [ "$installed" -gt "$RELEASE" ]; then
	stop "the LZRBRWSR that is installed is release $installed, and this installer holds the older release $RELEASE. To go back on purpose, move LZRBRWSR.app to the Trash first."
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# get <address> <file> <checksum> <what it is>
get() {
	fetch "$1" "$tmp/$2" || stop "could not download $4."
	[ "$(sum "$tmp/$2")" = "$3" ] || stop "$4 does not match its checksum."
}

get "$LZRPRF_BASE/lzrprf" lzrprf "$LZRPRF_SHA256" "lzrprf"
get "$LZRPRF_BASE/selftest" selftest "$SELFTEST_SHA256" "lzrprf's self-test"
step "lzrprf downloaded, and it is the published one (commit $(printf %.12s "$LZRPRF_COMMIT"))"
get "$BASE/$FILE" "$FILE" "$SHA256" "the download"
step "LZRBRWSR downloaded, and it matches its checksum"

# What the icon will run is checked before anything is put in place. The
# download must name these six files, the four folders they are in, and
# nothing else. It is unpacked into an empty folder of its own, so that nothing
# in it can take the place of a file that was checked above.
names="$(tar -tzf "$tmp/$FILE" | LC_ALL=C sort | tr '\n' ' ')"
[ "$names" = "LZRBRWSR.app/ LZRBRWSR.app/Contents/ LZRBRWSR.app/Contents/Info.plist LZRBRWSR.app/Contents/MacOS/ LZRBRWSR.app/Contents/MacOS/lzrbrwsr LZRBRWSR.app/Contents/MacOS/lzrbrwsr-bin LZRBRWSR.app/Contents/Resources/ LZRBRWSR.app/Contents/Resources/LICENSE.txt LZRBRWSR.app/Contents/Resources/lzrbrwsr.icns LZRBRWSR.app/Contents/Resources/release " ] || stop "the download holds files that do not belong in it."
[ -z "$(tar -tvzf "$tmp/$FILE" | grep -v '^[-d]')" ] || stop "the download holds a link."
mkdir "$tmp/unpacked"
tar -xzf "$tmp/$FILE" -C "$tmp/unpacked"
[ "$(cd "$tmp/unpacked" && find . ! -type d | LC_ALL=C sort | tr '\n' ' ')" = "./LZRBRWSR.app/Contents/Info.plist ./LZRBRWSR.app/Contents/MacOS/lzrbrwsr ./LZRBRWSR.app/Contents/MacOS/lzrbrwsr-bin ./LZRBRWSR.app/Contents/Resources/LICENSE.txt ./LZRBRWSR.app/Contents/Resources/lzrbrwsr.icns ./LZRBRWSR.app/Contents/Resources/release " ] || stop "the download holds files that do not belong in it."
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
# The window you see is lzrprf's, under the name LZRBRWSR. The program has
# no window and no network. The address you type into the bar of that window
# is fetched by lzrprf itself, and written down first:
#
#     perl ~/.lzrprf/lzrprf log
#
# Without lzrprf the program is not started at all.
here="$(cd "$(dirname "$0")" && pwd -P)"
lzrprf="$HOME/.lzrprf/lzrprf"
if [ ! -f "$lzrprf" ]; then
	/usr/bin/osascript -e 'display alert "LZRBRWSR needs lzrprf" message "lzrprf, the open container LZRBRWSR runs in, is not on this computer, and LZRBRWSR does not start without it. Install it again: how is on https://lzrbrwsr.com"' >/dev/null 2>&1
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
# The release file is what lzrprf reads beside the program: the number of this release, and the two
# fixed addresses of the update check. This is all of it: lzrprf fetches the first only after you
# said yes in its window, and the second is this installer's own public copy.
cat >"$tmp/release" <<'RELEASEFILE'
release 5
newest https://raw.githubusercontent.com/henryverlin/lzrprf/main/latest
installer https://raw.githubusercontent.com/henryverlin/lzrprf/main/install.sh
RELEASEFILE
cmp -s "$tmp/release" "$tmp/unpacked/LZRBRWSR.app/Contents/Resources/release" || stop "the app's release file is not the one written out in the installer."
step "the icon runs one thing: lzrprf, and inside it LZRBRWSR (release $RELEASE)"

# lzrprf is what holds LZRBRWSR in. A release of the browser never changes its own container
# silently: when the lzrprf this installer carries is not the one that is installed, that is
# said, with both checksums and where every change to it can be read, and it is your decision.
if [ -f "$HOME/.lzrprf/lzrprf" ] && [ "$(sum "$HOME/.lzrprf/lzrprf")" != "$LZRPRF_SHA256" ]; then
	step "this release replaces lzrprf, the container itself"
	step "  installed  $(sum "$HOME/.lzrprf/lzrprf")"
	step "  new        $LZRPRF_SHA256"
	step "  every change to it: https://github.com/henryverlin/lzrprf/commits/main"
	if [ -z "${LZRBRWSR_UNATTENDED:-}" ]; then
		ask "Replace lzrprf with the new one? It is attacked on this Mac first." || stop "you said no to the new lzrprf."
	fi
fi

# The container proves itself on this computer before anything is put in place:
# a hostile program is run inside it and every one of its attempts must be refused.
# It also leaves the mark of what it tested (this build of macOS, this lzrprf)
# in ~/.lzrprf/proven: lzrprf starts nothing without that mark, and asks to be
# tested again when macOS has changed.
step "Validating the safety of lzrprf on this computer, about half a minute"
if /usr/bin/perl "$tmp/selftest" >"$tmp/selftest.out" 2>&1; then
	untested="$(grep -c '^UNTESTED' "$tmp/selftest.out" || true)"
	step "lzrprf self-test on this computer: all $(grep -c '^held' "$tmp/selftest.out") attacks held"
	[ "$untested" = 0 ] || step "$untested could not be tried on this Mac; why is in: perl ~/.lzrprf/selftest"
else
	grep '^FAILED' "$tmp/selftest.out" >&2 || true
	stop "lzrprf's self-test did not hold on this computer."
fi

# What is put in place carries no attribute from the download and exactly these rights.
xattr -cr "$tmp/unpacked" 2>/dev/null || true
find "$tmp/unpacked" -type d -exec chmod 755 {} +
find "$tmp/unpacked" -type f -exec chmod 644 {} +
chmod 755 "$tmp/unpacked/LZRBRWSR.app/Contents/MacOS/lzrbrwsr-bin" "$tmp/unpacked/LZRBRWSR.app/Contents/MacOS/lzrbrwsr"

# Putting in place. Every new file is first written beside the one it replaces;
# until all of them are there, nothing that is installed has changed.
[ "$(sum "$tmp/lzrprf")" = "$LZRPRF_SHA256" ] && [ "$(sum "$tmp/selftest")" = "$SELFTEST_SHA256" ] || stop "lzrprf changed while it was being installed."
mkdir -p "$HOME/.lzrprf" "$dest"
chmod 700 "$HOME/.lzrprf"
new="$dest/.LZRBRWSR.app.new.$$"
old="$dest/.LZRBRWSR.app.old.$$"
beside() { rm -rf "$new" "$HOME/.lzrprf/lzrprf.new" "$HOME/.lzrprf/selftest.new"; }
{ cp "$tmp/lzrprf" "$HOME/.lzrprf/lzrprf.new" && cp "$tmp/selftest" "$HOME/.lzrprf/selftest.new" && chmod 644 "$HOME/.lzrprf/lzrprf.new" "$HOME/.lzrprf/selftest.new" && mv "$tmp/unpacked/LZRBRWSR.app" "$new"; } || {
	beside
	stop "the new files could not be written."
}
# Now each takes its name, in one step each. The older app is kept until the new one stands.
if [ -e "$dest/LZRBRWSR.app" ] && ! mv "$dest/LZRBRWSR.app" "$old"; then
	beside
	stop "the LZRBRWSR.app that is installed could not be moved aside."
fi
if ! mv "$new" "$dest/LZRBRWSR.app"; then
	[ ! -e "$old" ] || mv "$old" "$dest/LZRBRWSR.app"
	beside
	stop "the new LZRBRWSR.app could not be put in place; the older one is back."
fi
if ! { mv -f "$HOME/.lzrprf/lzrprf.new" "$HOME/.lzrprf/lzrprf" && mv -f "$HOME/.lzrprf/selftest.new" "$HOME/.lzrprf/selftest"; }; then
	printf '\n  LZRBRWSR: the new LZRBRWSR.app is in place, but lzrprf could not be replaced. Run the installer again.\n\n' >&2
	exit 1
fi
rm -rf "$old"
rm -f "$HOME/.lzrprf/rules" "$HOME/.lzrprf/refused"	# kept by an earlier lzrprf; this one keeps neither
step "lzrprf is installed:    $HOME/.lzrprf/lzrprf"
step "LZRBRWSR is installed:  $dest/LZRBRWSR.app"

# The Dock, if you say so. It is the one setting of yours this script can change,
# and only after a yes: one entry is added to the Dock's list of applications,
# and the Dock is started again so that it shows.
dock="${LZRBRWSR_DOCK:-com.apple.dock}"
case "$dest" in *[\&\<\>]*) dock="" ;; esac
if [ -n "$dock" ] && [ -z "${LZRBRWSR_UNATTENDED:-}" ]; then
	if defaults read "$dock" persistent-apps 2>/dev/null | grep -qF "$dest/LZRBRWSR.app"; then
		step "LZRBRWSR is in the Dock already"
	elif ask "Put LZRBRWSR in the Dock?"; then
		if defaults write "$dock" persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$dest/LZRBRWSR.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>" && { [ -n "${LZRBRWSR_DOCK:-}" ] || killall Dock; }; then
			step "LZRBRWSR is in the Dock"
		else
			step "the Dock could not be changed; drag LZRBRWSR there from Applications"
		fi
	fi
fi

cat <<DONE

  Open LZRBRWSR from Applications. It is one window. The window, its address
  bar and the words under the bar are lzrprf's: the browser has no window and
  no network. Type an address into the bar. lzrprf writes it down, fetches
  it, and only then hands the answer to the browser, in its container. To
  read the log, press Log in the window, or:

      ${B}perl ~/.lzrprf/lzrprf log${N}

  At its first start it asks once whether it may look for a newer release.
  It never updates itself: a newer release is offered, and then this
  installer runs again, in front of you.

  LZRBRWSR is not signed by an Apple developer identity and not notarized,
  and that is on purpose. A signature says who made a program, not what it
  does, and the one who gives it can take it back. What vouches here is
  lzrprf: you can read it, and it was just attacked on this Mac. After an
  update of macOS it asks to be tested again before it starts anything.
  To have your own AI check that all of this is true, copy the prompt from
  https://github.com/henryverlin/lzrprf

DONE
