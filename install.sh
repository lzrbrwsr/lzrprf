#!/bin/sh
# LZRBRWSR installer.
#
# It runs from a file and never from a pipe, so that what runs is something
# you can read and check first. In Terminal:
#
#     curl -q -fsSO https://lzrbrwsr.com/install.sh &&
#     curl -q -fsS https://raw.githubusercontent.com/lzrbrwsr/lzrprf/main/install.sh | cmp - install.sh &&
#     sh install.sh
#
# The first line saves this file. The second compares it, byte for byte, with
# the copy in a second place: lzrprf's public repository on GitHub, where
# every change to it is on record. It prints nothing when the two are the
# same, and the third line runs only then. Your own shell makes that
# comparison, before a byte of this file has run; this file cannot make it for
# you, because a changed file would simply say yes. curl is given -q first, so
# it reads no settings file of yours that could switch off its checking of the
# two sites. Then this file asks you, on your terminal, whether to print the
# whole script here first, and, whatever you answered, whether to run it.
# Each question takes y (yes, and the next question is asked too), n (no), or
# a (auto: yes to this question and to every one after it, each printed with
# its answer). "sh install.sh auto" starts in auto: that is how "Install it" in
# lzrprf's window runs it, so a newer release installs with no key pressed and
# every step stays in the Terminal window to read. Started in auto, it shows no
# question and no answer at all, because nobody is there making the choices:
# each step is said as what it does, and on an update the Dock is left as it is.
#
# What it does, in order:
#   1. asks you the two questions (none when started in auto);
#   2. stops if an LZRBRWSR that is installed, in Applications or in your own
#      Applications folder, is a newer release than this one;
#   3. downloads lzrprf, the open container, from its public repository at one
#      fixed commit, and checks its two files against the checksums below;
#   4. downloads LZRBRWSR from two places, this site and lzrprf's public
#      repository, checks it against the checksum below, and stops unless the
#      two copies are the same file;
#   5. checks what the icon will run: the download must hold exactly the six
#      files named below, and its launcher, its property list and its release
#      file must be, byte for byte, the three texts written out in this script;
#   6. when this release would replace the lzrprf that is installed with
#      another one, says so and asks: the container is never changed silently;
#   7. runs lzrprf's own self-test on this computer: hostile tries we made
#      ourselves, just to be sure. It stops if one was not deflected (a line FAILED). A line UNTESTED, something this Mac gave
#      no way to try, does not stop it: each is printed again with its reason.
#      When all held, the test writes its mark, those checks named in it;
#   8. only then puts lzrprf into ~/.lzrprf and LZRBRWSR.app into Applications,
#      or into your own Applications folder when that one is not yours to write.
#      Both new parts are first written whole beside the ones they replace and
#      checked there; then they take their names by renames, back to back, and
#      if one fails or Ctrl-C comes, the older app and the older lzrprf are put
#      back as a pair. An older part that cannot be put back is never removed:
#      it is kept, and the installer says where it is and that the pair is not
#      whole. A power failure or a kill in that second can also leave a mixed
#      pair. Installing again mends it. Two files an earlier lzrprf kept and
#      this one does not (rules, refused) are removed;
#   9. asks whether to put LZRBRWSR in the Dock, and only on a yes adds it and
#      starts the Dock again so that it shows.
# Only one installer places files at a time: right after its two questions it takes a
# lock, the link ~/.lzrprf/.installing, and takes it away once the new parts stand at their names.
# If a step before step 8 fails, what changed is in ~/.lzrprf alone: step 7
# (the mark, the self-test's lock file) and that folder's rights. It never runs the closed program, asks for no password, reports
# nothing back, installs no updater and leaves nothing running. LZRBRWSR never
# updates itself: when you allowed it, lzrprf looks whether a newer release is
# published, and offers to fetch that release's installer into a file and run
# it in Terminal, with the same steps and the same questions.
#
# It hands no variable of your shell on: it goes on only when what it would give to a program it
# starts is nothing but your home folder (as this Mac's list of accounts gives it), the system's
# PATH, the kind of terminal and a few names a shell sets for itself, and otherwise starts itself
# once more through env -i with those three, so nothing
# set in your shell reaches curl, perl or lzrprf's self-test. It follows no redirect: each file
# comes from the address written in this file, or not at all.
#
# For tests, six variables change what it does: LZRBRWSR_BASE, LZRBRWSR_SECOND
# and LZRPRF_BASE (where the files come from; the checksums below must still match),
# LZRBRWSR_DEST (the folder the app is put in), LZRBRWSR_DOCK (a file that
# stands for the Dock's settings) and LZRBRWSR_UNATTENDED (ask nothing, and
# leave the Dock alone). They are taken only when every file comes from this
# computer itself (file:///...), which is what a test does. With one of them
# set and a file that would come from the internet, nothing runs: so a
# variable left in your shell cannot quietly change an install from the site.
#
# lzrprf is open source: https://github.com/lzrbrwsr/lzrprf
# LZRBRWSR is proprietary software: free to use, never to resell or pass on.
# All rights reserved. The licence: https://lzrbrwsr.com/terms.html
set -eu
unset IFS ARGV0	# two names a shell may have read for itself at its start; see the lines before the first case below
AUTO=; GIVEN=; for word in "$@"; do case "$word" in auto) AUTO=auto GIVEN=auto ;; esac; done	# "auto": every question answered yes; kept through the start again below. GIVEN: started in auto, so no question is shown
PATH=/usr/bin:/bin:/usr/sbin:/sbin	# the system's own tools, whatever your shell was set to find first
export PATH

# Is one of the tests' six variables set? This is asked before any of them is given its usual value.
TESTING="${LZRBRWSR_BASE:-}${LZRBRWSR_SECOND:-}${LZRPRF_BASE:-}${LZRBRWSR_DEST:-}${LZRBRWSR_DOCK:-}${LZRBRWSR_UNATTENDED:-}"

# This script, curl and lzrprf's self-test take no variable of your shell: a variable can change
# what perl loads (PERL5OPT, PERL5LIB), which certificates curl trusts (SSL_CERT_FILE), or even
# what a command name means to the shell. So before anything else the script looks at what it
# would hand on to a program it starts (what /usr/bin/env prints), and goes on only when that
# is these and nothing else: your home folder as this Mac's list of accounts gives it for you
# (not as the shell says), the system's own PATH, the kind of terminal as one plain word, and
# names a shell sets for itself, each in its plain shape only (PWD, SHLVL, _; zsh also OLDPWD,
# the same folder, and LOGNAME, your account's name). With anything else there, the script
# starts itself once more through env -i with the first three (a kind of terminal that is not
# one plain word is left out; a test keeps its six settings and its home folder). No mark says
# "already clean" that a starter could set: what counts is what is there. It is read line by
# line by a perl that is itself started through env -i, and a line break or another control
# character in the value of one of these names counts as something else before that (the first
# case below), so one value cannot pass for several lines. The lines up to there name their
# tools by full path and use words of the shell that no function can give another meaning
# (case, set, unset, exec, exit, eval, for, export).
# What this cannot see or undo is what /bin/sh took in for itself at its own start and does
# not hand on. On macOS /bin/sh is bash: it reads SHELLOPTS and PS4, and with those a command
# written into PS4 runs before each of these lines, as the starter's own program; the second
# start has neither. Where an administrator made zsh the /bin/sh, it reads more for itself:
# the one found to act here (ARGV0, the name it gives the programs it starts) is unset at the
# top, and IFS with it. (With System Integrity Protection switched off, a DYLD_ variable would
# reach that first env and perl too.) What stays from the starter to the end and is no
# variable: the current folder, open files, limits, and signals set to be ignored.
case "${PATH-}${TERM-}${SHLVL-}${LOGNAME-}${HOME-}${OLDPWD-}${PWD-}${_-}" in *[[:cntrl:]]*) plain= ;; *) plain=one ;; esac
case "$plain$(/usr/bin/env | /usr/bin/env -i /usr/bin/perl -e '
	my ($testing) = @ARGV; my ($user, $home) = (getpwuid $<)[0, 7]; my $login = getlogin; my ($seen, %at) = (0);
	while (defined(my $line = <STDIN>)) {
		chomp $line;
		next if $line eq "PATH=/usr/bin:/bin:/usr/sbin:/sbin" || $line =~ m{^(?:TERM=[A-Za-z0-9._+-]+|SHLVL=[0-9]+|_=/[A-Za-z0-9._/+-]*)\z};
		if ($line =~ m{^(PWD|OLDPWD)=(/.*)\z}) { $at{$1} = $2; next }
		next if grep { defined($_) && $line eq "LOGNAME=$_" } $user, $login;
		if ($testing ne "") { next if $line =~ /^(?:HOME|LZRBRWSR_BASE|LZRBRWSR_SECOND|LZRPRF_BASE|LZRBRWSR_DEST|LZRBRWSR_DOCK|LZRBRWSR_UNATTENDED)=/ }
		elsif (defined $home && length $home && $line eq "HOME=$home") { $seen = 1; next }
		print "other"; exit;
	}
	print exists $at{OLDPWD} && $at{OLDPWD} ne ($at{PWD} // "") ? "other" : $testing ne "" || $seen ? "only" : "other";
' "$TESTING")" in
oneonly) ;;
*)
	case "$(/usr/bin/sed -n 2p "$0" 2>/dev/null)" in
	"# LZRBRWSR installer.")	# from a pipe there is no file to start again: nothing runs, as the lines further down say
		case "${1:-}" in
		again)
			/usr/bin/printf '\n  LZRBRWSR: this installer could not be started with only your home folder, the PATH of the system\n  and the kind of terminal. Nothing was installed. Start it from a folder with a plain name.\n\n' >&2
			exit 1 ;;
		esac
		case "$TESTING" in
		'') home="$(/usr/bin/env -i /usr/bin/perl -e 'print((getpwuid $<)[7])')" ;;
		*) home="${HOME:-}" ;;
		esac
		/bin/test -n "$home" && /bin/test -d "$home" || {
			/usr/bin/printf '\n  LZRBRWSR: this Mac gives no home folder for your account, and lzrprf keeps its files there. Nothing was installed.\n\n' >&2
			exit 1
		}
		set -- HOME="$home" PATH="$PATH"
		case "${TERM:-}" in '' | *[!A-Za-z0-9._+-]*) ;; *) set -- "$@" TERM="$TERM" ;; esac
		for name in LZRBRWSR_BASE LZRBRWSR_SECOND LZRPRF_BASE LZRBRWSR_DEST LZRBRWSR_DOCK LZRBRWSR_UNATTENDED; do
			eval "value=\${$name:-}"
			case "$value" in '') ;; *) set -- "$@" "$name=$value" ;; esac
		done
		exec /usr/bin/env -i "$@" /bin/sh "$0" again ${AUTO:+auto} ;;
	esac ;;
esac
set --
umask 022
BASE="${LZRBRWSR_BASE:-https://lzrbrwsr.com}"
SECOND="${LZRBRWSR_SECOND:-${LZRBRWSR_BASE:-https://raw.githubusercontent.com/lzrbrwsr/lzrprf/main}}"
FILE="lzrbrwsr-macos-arm64.tar.gz"
SHA256="318580236ad5e00be0cba04958550fa442146f35a9b57c5c3890c27675632dd4"
RELEASE="42"
LZRPRF_COMMIT="d041405199ac2e62f1b2609a89eb7e5858557421"
LZRPRF_BASE="${LZRPRF_BASE:-https://raw.githubusercontent.com/lzrbrwsr/lzrprf/$LZRPRF_COMMIT}"
LZRPRF_SHA256="744974775c254f8445af956e08e34dec29644c88777e21348ea54fa59379c489"
SELFTEST_SHA256="6ef4695822e3120a079b16cd2c9ee6d14f2391b66c2cd1be59f7b62c89d8d760"

# Outside the tests, files come over https and nothing else, and an address
# that sends on to another is not followed. In a test they come from files on
# this computer and nothing else. curl reads no settings file of yours (-q).
if [ -z "$TESTING" ]; then
	fetch() { /usr/bin/curl -q -fsS --proto '=https' --tlsv1.2 --connect-timeout 30 --max-time 900 --max-filesize 209715200 "$1" -o "$2"; }
else
	fetch() { /usr/bin/curl -q -fsS --proto '=file' --max-time 900 "$1" -o "$2"; }
fi

# From a pipe there is no file that could be shown to you or checked. So
# nothing runs, and it says how to get the file.
if [ ! -f "$0" ] || [ "$(/usr/bin/sed -n 2p "$0" 2>/dev/null)" != "# LZRBRWSR installer." ]; then
	/bin/cat >/dev/null 2>&1 || true	# what is left of the pipe is not read as a script
	printf '\n  LZRBRWSR: this installer runs from a file, not from a pipe, so that you can\n  read and check what runs. Nothing was installed. In Terminal:\n\n      curl -q -fsSO https://lzrbrwsr.com/install.sh &&\n      curl -q -fsS https://raw.githubusercontent.com/lzrbrwsr/lzrprf/main/install.sh | cmp - install.sh &&\n      sh install.sh\n\n  What the middle line checks: https://github.com/lzrbrwsr/lzrprf#the-installer\n\n' >&2
	exit 1
fi

# Colour only when a person is looking at a terminal.
if [ -t 1 ]; then
	G="$(printf '\033[38;5;46m')" B="$(printf '\033[1;97m')" Y="$(printf '\033[1;93m')" N="$(printf '\033[0m')"
else
	G="" B="" Y="" N=""
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
 ${G}┃${B}  BROWSE WITH ZERO TRUST.                                                   ${N}${G}┃${N}
 ${G}┃${B}  PROOF OVER PROMISES.                                                      ${N}${G}┃${N}
 ${G}┃${N}                                                                            ${G}┃${N}
 ${G}┃${N}  Your browser sees everything: what you read, what you type, where         ${G}┃${N}
 ${G}┃${N}  you go. Until now you could only believe what it does with that.          ${G}┃${N}
 ${G}┃${N}                                                                            ${G}┃${N}
 ${G}┃${N}  LZRBRWSR runs inside lzrprf, an open-source security container you or     ${G}┃${N}
 ${G}┃${N}  an AI can audit. Built for clean, minimal and transparent browsing.       ${G}┃${N}
 ${G}┃${N}  No bloatware. No spyware. No telemetry. No hidden background processes.   ${G}┃${N}
 ${G}┃${N}                                                                            ${G}┃${N}
 ${G}┃${N}   ▸ The browser has no network and no window. lzrprf owns the one          ${G}┃${N}
 ${G}┃${N}     window, and fetches the address you type into its bar.                 ${G}┃${N}
 ${G}┃${N}   ▸ Every address is written down before it is fetched, in a log           ${G}┃${N}
 ${G}┃${N}     the browser cannot touch and only you can clear.                       ${G}┃${N}
 ${G}┃${N}   ▸ It cannot read your files or your clipboard, cannot write a            ${G}┃${N}
 ${G}┃${N}     file, cannot start a program.                                          ${G}┃${N}
 ${G}┃${N}   ▸ Every page is treated as hostile: each is read in a sealed             ${G}┃${N}
 ${G}┃${N}     box of its own, and the box is thrown away.                            ${G}┃${N}
 ${G}┃${N}   ▸ The browser keeps nothing: no cookies, no account. Nothing is          ${G}┃${N}
 ${G}┃${N}     reported unless you press Send. The one record is that log.            ${G}┃${N}
 ${G}┃${N}   ▸ Our own engines lay each page out with its own styles, with            ${G}┃${N}
 ${G}┃${N}     a grey box where a picture stands. Nothing a page sends is run.        ${G}┃${N}
 ${G}┃${N}                                                                            ${G}┃${N}
 ${G}┃${N}  You do not have to take our word for any of it.                           ${G}┃${N}
 ${G}┃${N}                                                                            ${G}┃${N}
 ${G}┃${N}  Read the container   https://github.com/lzrbrwsr/lzrprf                   ${G}┃${N}
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

# The six variables of the tests count only when every file comes from this computer.
if [ -n "$TESTING" ]; then
	for place in "$BASE" "$SECOND" "$LZRPRF_BASE"; do
		case "$place" in
		file:///*) ;;
		*) stop "a test setting is set in this shell (a variable whose name begins LZRBRWSR_ or LZRPRF_), and test settings are taken only when every file comes from this computer. Take the variable away (unset) and run the installer again." ;;
		esac
	done
fi
[ -z "$TESTING" ] || step "test settings are in use: files from $BASE, $SECOND and $LZRPRF_BASE, the app into ${LZRBRWSR_DEST:-Applications}${LZRBRWSR_UNATTENDED:+, and no question is asked}"
[ ! -L "$HOME/.lzrprf" ] || stop ".lzrprf in your home folder is a link to somewhere else, and lzrprf keeps its files in a folder of its own."

sum() { shasum -a 256 "$1" | cut -d' ' -f1; }

# The questions. They are asked on your terminal and answered from it, so
# nothing that was piped into this script can answer for you. y is yes and the
# next question is asked too; a is auto: yes to this one and to every one after
# it, each printed with its answer, and nothing waits again.
ask() {
	if [ -n "$GIVEN" ]; then
		# Started in auto (lzrprf's update, or "sh install.sh auto"): nobody is there to choose, so no choice is shown;
		# what the yes does is said as a plain step instead, when the caller gave one.
		[ -z "${2:-}" ] || step "$2"
		return 0
	fi
	if [ -n "$AUTO" ]; then
		printf '  %s [a/y/n] a (auto)\n' "$1" >/dev/tty
		return 0
	fi
	while :; do
		printf '  %s [a/y/n] ' "$1" >/dev/tty
		read -r answer </dev/tty || stop "no answer came from the terminal."
		case "$answer" in
		a | A | auto | Auto | AUTO)
			AUTO=auto
			printf '  auto: this question and every one after it are answered yes\n' >/dev/tty
			return 0 ;;
		y | Y | yes | Yes | YES) return 0 ;;
		n | N | no | No | NO) return 1 ;;
		esac
	done
}
if [ -z "${LZRBRWSR_UNATTENDED:-}" ]; then
	# Started in auto it asks nothing, so it needs no terminal: lzrprf's window runs it after "Install it" was pressed
	# there, and shows every line it prints. By hand, the questions are asked on your terminal or not at all.
	[ -n "$GIVEN" ] || (: >/dev/tty) 2>/dev/null || stop "there is no terminal to ask you on, and this script runs only after you said so."
	if [ -n "$GIVEN" ]; then
		step "started in auto: no question is asked, and each step is printed here as it runs"
	else
	printf '  This installer is the file %s\n  Its SHA-256 is %s\n  The published one: install.sh and release.txt at https://github.com/lzrbrwsr/lzrprf\n  Only your own comparison counts: a changed installer could print anything here.\n\n' "$0" "$(sum "$0")" >/dev/tty
	if ask "Print the whole script here, before anything runs?"; then
		# Every byte of the file, except control characters, which could hide a line from you. It holds none.
		LC_ALL=C tr -d '\000-\010\013-\037\177' <"$0" >/dev/tty
		printf '\n' >/dev/tty
		ask "That was all of it. Run it now?" || stop "you said no."
	else
		ask "Run it now?" || stop "you said no."
	fi
	fi
fi

# One installer at a time, from here until the files are placed: two of them would each pass the checks below
# against what the other is about to replace, and each undo the other's renames. The lock is a
# link and not a file: making a link is one act, and what it points at is its text, so the lock and
# the name of its holder appear together. The text is this process's number and the moment it
# started, as the system says it (ps), so a later process that was given the same number is not
# taken for the holder.
# A lock whose holder is gone was left by an installer that was killed. It is taken away only by
# the installer that first makes a second link beside it (.installing.over), so two installers that
# find the same dead lock cannot take each other's new lock away.
lock="$HOME/.lzrprf/.installing" locked=""
started() { LC_ALL=C TZ=UTC /bin/ps -o lstart= -p "$1" 2>/dev/null || true; }	# in one zone and one language, so it reads the same when the Mac's are changed
lives() {	# lives <text of a lock>: is the process that wrote it still running, and still that process?
	case "${1%% *}" in '' | *[!0-9]*) return 1 ;; esac
	[ -n "$(started "${1%% *}")" ] && [ "${1%% *} $(started "${1%% *}")" = "$1" ]
}
take_lock() {
	[ -n "$(started "$$")" ] || stop "this Mac did not say when this process started (ps), so the installer cannot mark its lock as its own."
	me="$$ $(started "$$")"
	[ ! -e "$lock" ] || stop "$lock is not a lock of this installer. Look at it, move it away, and run this again."
	if ! ln -s "$me" "$lock" 2>/dev/null; then
		if [ ! -L "$lock" ]; then	# no lock stands: an installer that just ended took the folder it had made away
			[ -d "$HOME/.lzrprf" ] || made=1
			mkdir -p "$HOME/.lzrprf" && ln -s "$me" "$lock" 2>/dev/null || stop "the lock $lock could not be made. Run this again."
			locked=1
			return 0
		fi
		held="$(readlink "$lock" 2>/dev/null || true)"
		! lives "$held" || stop "another installer of LZRBRWSR is running on this Mac (process ${held%% *}). When it has ended, run this one again."
		ln -s "$me" "$lock.over" 2>/dev/null || stop "another installer is taking over the lock of one that was killed, or was killed itself while it did. If no installer is running, remove $lock.over and run this one again."
		[ "$(readlink "$lock" 2>/dev/null || true)" != "$held" ] || rm -f "$lock"
		if ln -s "$me" "$lock" 2>/dev/null; then
			rm -f "$lock.over"
		else
			rm -f "$lock.over"
			stop "another installer took the lock first. When it has ended, run this one again."
		fi
	fi
	locked=1
}
unlock() {	# takes the lock away when it is this process's own
	[ -z "$locked" ] || [ "$(readlink "$lock" 2>/dev/null || true)" != "$me" ] || rm -f "$lock"
	locked=""
}
# (the end of the lock's own lines)
# lzrprf's folder is made here when this Mac has none, for the lock to stand in. An installer that
# stops before it installs anything takes the folder away again, when it made it and it is empty.
made=""
[ -d "$HOME/.lzrprf" ] || made=1
mkdir -p "$HOME/.lzrprf"
tmp="" me="" testing=""
trap '[ -z "$testing" ] || { kill "$testing" 2>/dev/null; wait "$testing" 2>/dev/null; } || true; unlock; [ -z "$tmp" ] || rm -rf "$tmp"; [ -z "$made" ] || rmdir "$HOME/.lzrprf" 2>/dev/null || true' EXIT
trap 'exit 130' INT TERM HUP QUIT
take_lock
chmod 700 "$HOME/.lzrprf"

# Where the app goes: Applications, or your own Applications folder when that one is not yours to
# write. LZRBRWSR_DEST names another folder, for tests.
dest="${LZRBRWSR_DEST:-/Applications}"
[ -w "$dest" ] || dest="$HOME/Applications"

# An older release is never put over a newer one: not by a mistake, and not by somebody who serves
# you an old installer on purpose. The release that is installed says its number in a plain file.
# Both folders an install can be in are looked at, whichever of them this install goes to: Applications
# (in a test, the folder the test names in its place) and your own Applications folder. So a newer
# release in Applications is seen also when this install would go to your own folder because
# Applications is not yours to write. The refusal is this installer's: one from before release 5 does
# not hold it.
for folder in "${LZRBRWSR_DEST:-/Applications}" "$HOME/Applications"; do
	installed="$(sed -n 's/^release \([0-9]\{1,6\}\)$/\1/p' "$folder/LZRBRWSR.app/Contents/Resources/release" 2>/dev/null | sed -n 1p)"
	if [ -n "$installed" ] && [ "$installed" -gt "$RELEASE" ]; then
		stop "the LZRBRWSR that is installed in $folder is release $installed, and this installer holds the older release $RELEASE. To go back on purpose, move that LZRBRWSR.app to the Trash first."
	fi
done

tmp="$(mktemp -d)"

# get <address> <file> <checksum> <what it is>
get() {
	fetch "$1" "$tmp/$2" || stop "could not download $4."
	[ "$(sum "$tmp/$2")" = "$3" ] || stop "$4 does not match its checksum."
}

get "$LZRPRF_BASE/lzrprf" lzrprf "$LZRPRF_SHA256" "lzrprf"
get "$LZRPRF_BASE/selftest" selftest "$SELFTEST_SHA256" "lzrprf's self-test"
step "lzrprf downloaded, and it is the published one (commit $(printf %.12s "$LZRPRF_COMMIT"))"
get "$BASE/$FILE" "$FILE" "$SHA256" "the download"
# The same download once more, from a second place: lzrprf's public repository, where every
# release's download is on record with its date. Both must be the file this installer names.
# One changed place cannot pass: the site's copy is held to the checksum above, and so is this one.
fetch "$SECOND/$FILE" "$tmp/second" || stop "could not download the second copy of LZRBRWSR, from lzrprf's public repository."
if ! cmp -s "$tmp/$FILE" "$tmp/second"; then
	stop "lzrprf's public repository holds another download than the site. Either a newer release was just published (get the installer again), or one of the two places was changed."
fi
rm -f "$tmp/second"
step "LZRBRWSR downloaded from two places: both are the same file, and it matches its checksum"

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
# (https://github.com/lzrbrwsr/lzrprf), and inside it the program,
# lzrbrwsr-bin, which stands beside this file.
#
# The window you see is lzrprf's, under the name LZRBRWSR. The program has
# no window and no network. The address you type into the bar of that window
# is fetched by lzrprf itself, and written down first:
#
#     perl ~/.lzrprf/lzrprf log
#
# Without lzrprf the program is not started at all.
#
# This file reads no variable of whoever started it. Its one command starts
# perl with no variable at all (env -i), and the few lines of perl below find
# your home folder in this Mac's list of accounts, as lzrprf does, and the
# folder this file is in. So nothing set around it chooses which lzrprf runs.
# What is left of the starter's is how /bin/sh itself starts, before this line.
exec /usr/bin/env -i /usr/bin/perl -e '
use Cwd qw(abs_path getcwd); use File::Basename "dirname";
my $lzrprf = ((getpwuid $<)[7] // "") . "/.lzrprf/lzrprf";
if (!-f $lzrprf) {
	system "/usr/bin/osascript", "-e", q{display alert "LZRBRWSR needs lzrprf" message "lzrprf, the open container LZRBRWSR runs in, is not on this computer, and LZRBRWSR does not start without it. Install it again: how is on https://lzrbrwsr.com"};
	exit 1;
}
my $self = abs_path(shift) // exit 1;
my $from = getcwd();
chdir dirname($self) or exit 1;
my $here = getcwd() // exit 1;
chdir $from if defined $from;
exec "/usr/bin/perl", $lzrprf, "run", "$here/lzrbrwsr-bin", @ARGV;
' -- "$0" "$@"
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
	<string>Proprietary. Copyright 2026 create.repeat Oy. All rights reserved. Free to use; the terms: https://lzrbrwsr.com/terms.html</string>
</dict>
</plist>
PLIST
cmp -s "$tmp/plist" "$tmp/unpacked/LZRBRWSR.app/Contents/Info.plist" || stop "the app's property list is not the one written out in the installer."
# The release file is what lzrprf reads beside the program: the number of this release, four fixed
# addresses, the SHA-256 of the launcher and of the program (the two lines "file"), which lzrprf
# compares with those two files at every start, and the SHA-256 of the lzrprf this app is installed
# with, which lzrprf compares with itself at every start. This is all of it. "newest" is the one address lzrprf fetches by itself, and only
# after you said yes in its window. "installer" and "same" are the two places a newer release's
# installer is fetched from, by Terminal, after you chose to install it. "report" is where a report
# goes, and only when you pressed Send.
cat >"$tmp/release" <<'RELEASEFILE'
release 42
newest https://raw.githubusercontent.com/lzrbrwsr/lzrprf/main/latest
installer https://raw.githubusercontent.com/lzrbrwsr/lzrprf/main/install.sh
same https://lzrbrwsr.com/install.sh
report https://origin.lzrbrwsr.com/report
file lzrbrwsr 604a5cf1225c06b9beb01f80bd01d81645855dd3d63fc16a78b5e91198966eb1
file lzrbrwsr-bin ed1b16dbede7d42d445946a747418a727825028a925276aef3b00dbd32bf65ea
lzrprf 744974775c254f8445af956e08e34dec29644c88777e21348ea54fa59379c489
RELEASEFILE
cmp -s "$tmp/release" "$tmp/unpacked/LZRBRWSR.app/Contents/Resources/release" || stop "the app's release file is not the one written out in the installer."
grep -qx "lzrprf $LZRPRF_SHA256" "$tmp/release" || stop "the app's release file does not name the lzrprf this installer carries."
for name in lzrbrwsr-bin lzrbrwsr; do
	grep -qx "file $name $(sum "$tmp/unpacked/LZRBRWSR.app/Contents/MacOS/$name")" "$tmp/release" || stop "the app's release file does not name the file $name as it was unpacked."
done
step "the icon runs one thing: lzrprf, and inside it LZRBRWSR (release $RELEASE)"

# lzrprf is what holds LZRBRWSR in. A release of the browser never changes its own container
# silently: when the lzrprf this installer carries is not the one that is installed, that is
# said, with both checksums and where every change to it can be read, and it is your decision.
if [ -f "$HOME/.lzrprf/lzrprf" ] && [ "$(sum "$HOME/.lzrprf/lzrprf")" != "$LZRPRF_SHA256" ]; then
	step "this release replaces lzrprf, the container itself"
	step "  installed  $(sum "$HOME/.lzrprf/lzrprf")"
	step "  new        $LZRPRF_SHA256"
	step "  every change to it: https://github.com/lzrbrwsr/lzrprf/commits/main"
	if [ -z "${LZRBRWSR_UNATTENDED:-}" ]; then
		ask "Replace lzrprf with the new one? First it deflects, here on this Mac, hostile tries we made ourselves to be sure." "lzrprf is replaced by the new one once it deflects, here on this Mac, hostile tries we made ourselves to be sure" || stop "you said no to the new lzrprf."
	fi
fi

# The container proves itself on this computer before anything is put in place:
# we run hostile tries of our own inside it, made just to be sure, and it must
# deflect every one of them.
# It also leaves the mark of what it tested (this build of macOS, this lzrprf)
# in ~/.lzrprf/proven: lzrprf starts nothing without that mark, and asks to be
# tested again when macOS has changed.
#
# The test's steps are shown as they happen, each with its title and a beam
# while it runs that strikes lzrprf's wall and ricochets off it, in yellow and
# bright white: the deflection. Every word of it is read from the test's own output: its
# lines "now ..." and its numbered headings are the titles, and the lines
# "held" under a heading are counted. Nothing here decides what held.
shown() {	# shown <steps already printed> <frame> <seconds so far> <has the test ended: 0 or 1>
	awk -v printed="$1" -v frame="$2" -v seconds="$3" -v ended="$4" -v G="$G" -v B="$B" -v Y="$Y" -v N="$N" '
		/^now / { n++; title[n] = substr($0, 8); sub(/[.:;].*/, "", title[n]); next }
		/^[0-9]+\. / { n++; title[n] = $0; sub(/^[0-9]+\. /, "", title[n]); sub(/[.:;].*/, "", title[n]); next }
		/^(held|works) / { held[n]++ }
		/^FAILED/ { failed[n]++ }
		END {
			clear = G == "" ? "" : "\r\033[K"
			last = ended ? n : n - 1
			for (i = printed + 1; i <= last; i++)
				printf "%s    %-54s %s━━━━━━━%s▌%s✦%s  %s\n", clear, title[i], G, B, Y, N, failed[i] ? "FAILED" : held[i] ? B held[i] " deflected" N : "done"
			if (!ended && n > 0 && G != "") {
				at = frame % 10
				beam = ""
				if (at < 7) {	# the beam flies at the wall
					for (i = 0; i < at; i++) beam = beam "━"
					beam = beam "▶" N
					for (i = at; i < 6; i++) beam = beam " "
					beam = beam B "▌ " N "  "
				} else {	# it strikes the wall and ricochets off, yellow and bright white
					spark[7] = Y "✦" B "   "; spark[8] = B "✸" Y " ✦ "; spark[9] = Y "·" B " ✧" Y "✦"
					beam = "━━━━━━" Y "◀" B "▌" spark[at] N
				}
				printf "%s    %-54s %s%s%s  %s s", clear, title[n], G, beam, N, seconds
			}
			exit last > printed ? last : printed
		}' "$tmp/selftest.out"
}
step "lzrprf now deflects hostile tries we made ourselves, just to be sure: about half a minute"
/usr/bin/perl "$tmp/selftest" >"$tmp/selftest.out" 2>&1 &
testing=$!
# Stopped with Ctrl-C: the test is told, and it ends every process it started and takes its files away.
trap 'kill "$testing" 2>/dev/null || true; wait "$testing" 2>/dev/null || true; exit 130' INT TERM HUP QUIT
printed=0 frame=0 seconds=0 began="$(date +%s)"
while kill -0 "$testing" 2>/dev/null; do
	seconds="$(($(date +%s) - began))"
	if [ "$seconds" -gt 1800 ]; then	# DECLARED(half a minute on a quiet Mac; a Mac busy with other work can take many times that) a test that does not end is ended, and counts as one that did not hold
		kill "$testing" 2>/dev/null || true
		break
	fi
	if [ -t 1 ]; then
		shown "$printed" "$frame" "$seconds" 0 && printed=0 || printed=$?
		frame=$((frame + 1))
		sleep 0.1
	else
		sleep 1
	fi
done
if wait "$testing"; then held=yes; else held=no; fi
testing=""	# it has ended: nothing is left for the line that ends it at an exit
trap 'exit 130' INT TERM HUP QUIT
shown "$printed" 0 0 1 || true
if [ "$held" = yes ]; then
	untested="$(grep -c '^UNTESTED' "$tmp/selftest.out" || true)"
	step "self-test on this computer: lzrprf deflected all $(grep -c '^held' "$tmp/selftest.out") hostile tries we made ourselves, just to be sure"
	if [ "$untested" != 0 ]; then
		step "$untested of its checks could not be tried on this Mac. Each one, and why:"
		grep '^UNTESTED' "$tmp/selftest.out" | LC_ALL=C tr -c '\n\040-\176' '?' | cut -c1-300 | sed 's/^/      /'
		step "the mark of this test names them, and LZRBRWSR shows them and asks before it starts"
	fi
else
	if ! grep '^FAILED' "$tmp/selftest.out" >&2; then	# no try got through: the test itself ended early; its last words say why
		printf '  The self-test ended before it was done. Its last lines:\n' >&2
		tail -n 5 "$tmp/selftest.out" | LC_ALL=C tr -c '\n\040-\176' '?' | cut -c1-300 | sed 's/^/      /' >&2
		[ "$seconds" -le 1800 ] || printf '  It did not end within 30 minutes: this Mac is very busy. Run the installer again when it is quieter.\n' >&2
	fi
	stop "lzrprf's self-test did not hold on this computer."
fi

# What is put in place has exactly these rights. No attribute is taken off anything: the archive is
# packed without any (and is the file whose SHA-256 stands above), and a mark that macOS itself put on
# a file, the quarantine mark among them, stays where it is.
find "$tmp/unpacked" -type d -exec chmod 755 {} +
find "$tmp/unpacked" -type f -exec chmod 644 {} +
chmod 755 "$tmp/unpacked/LZRBRWSR.app/Contents/MacOS/lzrbrwsr-bin" "$tmp/unpacked/LZRBRWSR.app/Contents/MacOS/lzrbrwsr"

# Putting in place, as one change as far as files allow. First both new parts are written whole into
# folders of their own beside where they go (the same disk, so that a name can be taken by a rename),
# under names nobody can know beforehand, and checked there. Until then nothing that is installed
# has changed. Then the older ones are kept aside and the new ones take their names, renames back to
# back; if one fails, or Ctrl-C comes, every rename done is undone and the older app and the older
# lzrprf are back as a pair. Only when all stand are the older ones removed.
#
# What a script cannot do: make renames in two folders one act. If the power fails between them, or
# the installer is killed outright, the computer can be left with the new app and the older lzrprf,
# or the other way round, or with the app still aside in a hidden folder .LZRBRWSR.* in the same
# folder as the app. From this release on lzrprf notices a pair that does not belong together at
# its next start: the app's release file names the SHA-256 of the lzrprf it was installed with,
# lzrprf compares that with itself, says so and asks. That needs an app and an lzrprf that both
# know the line: an app of release 11 or earlier names no lzrprf, and an lzrprf of release 11 or
# earlier does not look. Running this installer again puts a matching pair in place.
[ "$(sum "$tmp/lzrprf")" = "$LZRPRF_SHA256" ] && [ "$(sum "$tmp/selftest")" = "$SELFTEST_SHA256" ] || stop "lzrprf changed while it was being installed."
for part in lzrprf selftest; do
	if [ -L "$HOME/.lzrprf/$part" ] || { [ -e "$HOME/.lzrprf/$part" ] && [ ! -f "$HOME/.lzrprf/$part" ]; }; then
		stop "$HOME/.lzrprf/$part is not a plain file, and lzrprf and its self-test are plain files. Look at what stands there, move it away, and run this again."
	fi
done
mkdir -p "$dest"
# What an earlier install left behind. This runs under the lock, so no folder of a running installer
# is among them. In lzrprf's folder: new files that never got their names, and second names of the
# installed ones, are removed. A folder that holds an older lzrprf or selftest which is NOT the
# installed one is the only copy of it, and stays: it is named, every time, until you remove it.
# In the app's folder nothing with a file in it is removed: a hidden folder .LZRBRWSR.* there can
# hold the older app, whole. It is named; an empty one is removed.
for left in "$HOME/.lzrprf"/.new.????????; do
	[ -d "$left" ] || continue
	only=""
	for part in lzrprf selftest; do
		[ ! -e "$left/old.$part" ] || cmp -s "$left/old.$part" "$HOME/.lzrprf/$part" || only=1
	done
	if [ -n "$only" ]; then
		step "an older lzrprf is kept in: $left"
		step "an earlier install could not put it back, or was killed just after the new one was in place; remove that folder by hand when you do not need it"
	else
		rm -rf "$left" || step "what an earlier install left could not be removed: $left"
	fi
done
for left in "$dest"/.LZRBRWSR.????????; do
	[ -d "$left" ] && [ ! -L "$left" ] || continue
	if rmdir "$left" 2>/dev/null; then
		continue	# it was empty: an install was stopped as it began
	elif [ -e "$left/old.app" ]; then
		step "an older LZRBRWSR.app is kept in: $left"
		step "an earlier install could not put it back, or was killed; remove that folder by hand when you do not need it"
	else
		step "a LZRBRWSR.app that an earlier install never put in place is left in: $left (remove that folder by hand)"
	fi
done
# appsum <folder>: one checksum of every name and every file's contents in that folder
appsum() { (cd "$1" && find . | LC_ALL=C sort && find . -type f -exec shasum -a 256 {} + | LC_ALL=C sort) | shasum -a 256 | cut -d' ' -f1; }
checked="$(appsum "$tmp/unpacked/LZRBRWSR.app")"
stage="" prfstage="" placing="" back=0 kept="" had_lzrprf="" had_selftest=""
# undo: puts back what was there. It goes by what stands on the disk and not by a count of the steps
# done, so it is right at whichever rename a failure or Ctrl-C came. Before the renames began
# (placing is empty) nothing installed has changed and only the folders of the new parts are removed.
# Every putting back is checked. An older part that could not be put back is never removed: it stays
# where it is, "kept" names the place, and "back" is 1 so that what is printed afterwards is true.
# Whether there was an older lzrprf file is what was noted when its second name was made (had_...),
# not what the disk shows now: an installed file is removed only when none stood there before.
undo() {
	trap '' INT TERM HUP QUIT
	set +e	# every step below is checked by itself; none may end the script half way
	holds=""
	if [ -n "$placing" ]; then
		# A new lzrprf file that has left its folder holds the installed name: the older one, kept
		# under a second name, takes the name back; if there was none, the name is removed.
		for part in selftest lzrprf; do
			[ ! -e "$prfstage/$part" ] || continue
			if [ -e "$prfstage/old.$part" ]; then
				if ! mv -f "$prfstage/old.$part" "$HOME/.lzrprf/$part"; then
					back=1 holds=1
					kept="$kept
      the older $part: $prfstage/old.$part"
				fi
			elif eval "[ -n \"\$had_$part\" ]"; then
				back=1
				kept="$kept
      the older $part is not where this installer kept it ($prfstage/old.$part); what stands in its place was left as it is: $HOME/.lzrprf/$part"
			elif ! rm -f "$HOME/.lzrprf/$part"; then
				back=1
				kept="$kept
      the new $part could not be taken away again: $HOME/.lzrprf/$part"
			fi
		done
		# The same for the app: the new one goes back to its folder, the older one takes its name back.
		if [ ! -e "$stage/LZRBRWSR.app" ] && ! mv "$dest/LZRBRWSR.app" "$stage/LZRBRWSR.app"; then
			back=1
			kept="$kept
      the new LZRBRWSR.app could not be taken away again: $dest/LZRBRWSR.app"
		fi
		[ ! -e "$stage/old.app" ] || [ -e "$dest/LZRBRWSR.app" ] || mv "$stage/old.app" "$dest/LZRBRWSR.app" || true
	fi
	# A folder that still holds an older part that could not be put back is never removed.
	if [ -n "$stage" ] && [ -e "$stage/old.app" ]; then
		back=1
		kept="$kept
      the older LZRBRWSR.app, whole: $stage/old.app"
	elif [ -n "$stage" ]; then
		rm -rf "$stage"
	fi
	[ -z "$prfstage" ] || [ -n "$holds" ] || rm -rf "$prfstage"
	unlock
}
# gone <what failed>: undoes, then says what is true of the disk now, and stops.
gone() {
	undo
	if [ "$back" = 0 ]; then
		printf '\n  LZRBRWSR: %s Nothing was changed: what was installed before, the app and\n  lzrprf as a pair, is in place as it was.\n\n' "$1" >&2
	else
		printf '\n  LZRBRWSR: %s Not everything that was installed before could be put back.\n  Nothing older was removed. It is here:%s\n  Run this installer again: it puts an app and an lzrprf that belong together in place.\n\n' "$1" "$kept" >&2
	fi
	exit "${2:-1}"
}
# The two older lzrprf files are kept by a second name (a hard link), so their own names are never
# missing: the new file takes the name in one rename, and undoing it is one rename back.
trap 'gone "stopped while it was being put in place." 130' INT TERM HUP QUIT
{
	stage="$(mktemp -d "$dest/.LZRBRWSR.XXXXXXXX")" &&
		prfstage="$(mktemp -d "$HOME/.lzrprf/.new.XXXXXXXX")" &&
		cp "$tmp/lzrprf" "$tmp/selftest" "$prfstage/" &&
		chmod 644 "$prfstage/lzrprf" "$prfstage/selftest" &&
		mv "$tmp/unpacked/LZRBRWSR.app" "$stage/LZRBRWSR.app" &&
		[ "$(sum "$prfstage/lzrprf")" = "$LZRPRF_SHA256" ] &&
		[ "$(sum "$prfstage/selftest")" = "$SELFTEST_SHA256" ] &&
		[ "$(appsum "$stage/LZRBRWSR.app")" = "$checked" ] &&
		{ [ ! -f "$HOME/.lzrprf/lzrprf" ] || { ln "$HOME/.lzrprf/lzrprf" "$prfstage/old.lzrprf" && had_lzrprf=1; }; } &&
		{ [ ! -f "$HOME/.lzrprf/selftest" ] || { ln "$HOME/.lzrprf/selftest" "$prfstage/old.selftest" && had_selftest=1; }; }
} || gone "the new files could not be written beside the installed ones, or were not the checked ones once written."
# The renames, back to back.
placing=1
before=
if [ -e "$dest/LZRBRWSR.app" ]; then
	before=yes
	mv "$dest/LZRBRWSR.app" "$stage/old.app" || gone "the LZRBRWSR.app that is installed could not be moved aside."
fi
mv "$stage/LZRBRWSR.app" "$dest/LZRBRWSR.app" || gone "the new LZRBRWSR.app could not be put in place."
mv -f "$prfstage/lzrprf" "$HOME/.lzrprf/lzrprf" || gone "lzrprf could not be put in place."
mv -f "$prfstage/selftest" "$HOME/.lzrprf/selftest" || gone "lzrprf's self-test could not be put in place."
trap '' INT TERM HUP QUIT	# all stand: what is left is removing the older ones
rm -rf "$stage" "$prfstage" || step "the older app or the older lzrprf, now replaced, could not be removed whole; what is left: $stage $prfstage"
unlock
rm -f "$HOME/.lzrprf/rules" "$HOME/.lzrprf/refused"	# kept by an earlier lzrprf; this one keeps neither
trap - INT TERM HUP QUIT
step "lzrprf is installed:    $HOME/.lzrprf/lzrprf"
step "LZRBRWSR is installed:  $dest/LZRBRWSR.app"
# An app in the other folder an install can be in was not touched, and can belong to another lzrprf.
for folder in "${LZRBRWSR_DEST:-/Applications}" "$HOME/Applications"; do
	[ "$folder" = "$dest" ] || [ ! -e "$folder/LZRBRWSR.app" ] || step "another LZRBRWSR.app stands in $folder and was not touched; it can belong to another lzrprf than the one installed now. Move it to the Trash and use the one above."
done
# A log an earlier release wrote. Nothing here removes it: that is for you, in the window.
if [ -s "$HOME/.lzrprf/log" ] && { [ ! -f "$HOME/.lzrprf/keep" ] || [ -L "$HOME/.lzrprf/keep" ] || ! grep -Eq '^(hosts|all) [0-9]+$' "$HOME/.lzrprf/keep"; }; then
	step "a log written earlier is still on this computer: $HOME/.lzrprf/log"
	step "this release adds nothing to it; the Log button of the window offers to clear it"
fi

# The Dock, if you say so. It is the one setting of yours this script can change,
# and only after a yes: one entry is added to the Dock's list of applications,
# and the Dock is started again so that it shows.
dock="${LZRBRWSR_DOCK:-com.apple.dock}"
case "$dest" in *[\&\<\>]*) dock="" ;; esac
if [ -n "$dock" ] && [ -z "${LZRBRWSR_UNATTENDED:-}" ]; then
	if defaults read "$dock" persistent-apps 2>/dev/null | grep -qF "$dest/LZRBRWSR.app"; then
		step "LZRBRWSR is in the Dock already"
	elif [ -n "$GIVEN" ] && [ -n "$before" ]; then
		step "the Dock is left as it is: this was an update, and whether LZRBRWSR is in the Dock is your own choice"
	elif ask "Put LZRBRWSR in the Dock?" "LZRBRWSR is put in the Dock"; then
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
  it, and only then hands the answer to the browser, in its container. What
  it wrote down is behind the Log button of the window. Unless you chose to
  keep a log, it is gone when the window closes: lzrprf keeps nothing on
  your disk unless you choose it, in Terminal and nowhere else. This says what
  is kept and how to choose:

      ${B}perl ~/.lzrprf/lzrprf keep${N}

  At its first start it asks once whether it may look for a newer release.
  It never updates itself: a newer release is offered, and then that
  release's installer runs, in front of you.

  LZRBRWSR is not signed by an Apple developer identity and not notarized,
  and that is on purpose. A signature says who made a program, not what it
  does, and the one who gives it can take it back. What vouches here is
  lzrprf: you can read it, and it just deflected, on this Mac, every hostile
  try we made ourselves to be sure. After an
  update of macOS it asks to be tested again before it starts anything.
  To have your own AI check that all of this is true, copy the prompt from
  https://github.com/lzrbrwsr/lzrprf

DONE
