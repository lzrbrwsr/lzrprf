```
    ██╗     ███████╗██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚══███╔╝██╔══██╗██╔══██╗██╔══██╗██╔════╝
▒▓█ ██║       ███╔╝ ██████╔╝██████╔╝██████╔╝█████╗   ▒▓█
    ██║      ███╔╝  ██╔══██╗██╔═══╝ ██╔══██╗██╔══╝
    ███████╗███████╗██║  ██║██║     ██║  ██║██║
    ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚═╝
```

# lzrprf

An open container for a closed application. Trust the boundary, not the browser.

lzrprf was written for [LZRBRWSR](https://lzrbrwsr.com), a browser whose source is closed. It
treats that browser as hostile, gives it no network at all, and does itself the one thing a
browser needs done: fetching the https address **you type into lzrprf's own window**. So what the
browser can and cannot do on your computer is decided here, in code anyone can read, and not in
the browser.

The whole of it is two files you can read in one sitting:

- `lzrprf`: the containers, the gateway, the fetch, the windows and the log. About 860 lines of Perl.
- `selftest`: a hostile application that attacks all of it and says what it managed to do.

It runs on macOS on Apple silicon and uses only what macOS already has. `install.sh` and
`release.txt` are the record of the LZRBRWSR release that is built on it (see "The installer").

## Who vouches

Nobody's signature does. A signature says who made a program, not what the program does, and
whoever gives it can take it back. lzrprf asks no platform owner for approval: the proof is a
text you can read and a test you can run, and it is the same kind of proof on any system. Today
that system is macOS. The gateway, the log and the windows do not depend on it; the container
does, and other systems have walls of their own to build one from.

So lzrprf starts nothing it has not been tested with. `selftest` leaves a mark: this build of
macOS, this exact `lzrprf`. `lzrprf run` compares the mark with now, and when macOS was updated or
`lzrprf` changed, it asks to run the test again and starts the application only if no attack
failed. An attack this Mac could not try (it has no C compiler, or the clipboard was empty) is
printed as `UNTESTED` and does not stop it: read those lines. The proof is renewed on your computer, by you, each time what it rests on changes.

## How it works

Three containers, each a macOS sandbox profile that denies everything and then allows a short list.

| container | what runs in it | network | what it can reach |
| --- | --- | --- | --- |
| main | the application, with its window | none | six system services its window needs, and one socket: lzrprf's gateway |
| fetch | the system's `curl`, for one request | none | one socket file, behind which lzrprf holds the connection |
| page | a second copy of the application, for one answer | none | a pipe with the site's answer in, a pipe to the main container out |

The application can say two fixed sentences to the gateway, and neither has a place for data:

- `address`: lzrprf opens its address window, empty. You type an https address there.
- `show log`: lzrprf opens its log window.

Before any window of lzrprf opens, every process of the application, page containers included,
is stopped by the system (`SIGSTOP`), and lzrprf waits until the system shows them stopped: they
run no instruction while you read, type or press, as long as they stayed in the application's
process group (see "The window" under "What it does not prove"). After a window closed, however it closed, no
new one opens for three seconds, so the application cannot put a window under a key you were
already pressing.

For an address you typed, lzrprf does this, in this order:

1. writes "you typed ADDRESS" into the log, and waits until the disk has it;
2. looks the host up, in a process of its own, from which only numeric addresses are taken;
3. if any address the name leads to is in a private range, or is one this computer reaches by a
   route of its own and not the way it reaches the internet at large (a network it is attached
   to, a tunnel), asks you in a second window, for this one request;
4. writes down the numeric addresses it will connect to, and connects to one of them, itself;
5. lets `curl` do the https over that one connection: TLS 1.2 or newer, the certificate must prove
   the host you typed to the system's list of authorities, no redirect is followed, no cookie, no
   browser name and no language is sent;
6. writes down how it ended, and which numeric address answered;
7. only now, with the connection closed, hands the answer to the page container, and carries what
   that container writes to the application's window side.

## What holds, and where to check it

Each line is a property of `lzrprf` that `selftest` attacks. "The application" means any program
started with `lzrprf run`, however malicious.

1. **Confinement.** Every process of the application runs in one of the three containers. It
   cannot read your files, list your folders or learn whether a file exists; cannot write a file;
   cannot start another program or a second process; cannot signal another process; cannot ask
   another program, or the system, to open or start anything; cannot read the clipboard; sees
   none of your environment variables and not the computer's name. It is handed three
   descriptors lzrprf chose, and no file, socket or terminal that was open in whoever started
   lzrprf. It cannot read or change the log or lzrprf. Of the system's services it reaches the
   six its window needs, and no other: the window server, its render server and the window
   manager (a window, its content, its place on the screen), launch services and a helper of
   theirs (asked when an application starts), and the events service (so that the system can
   tell it "you were opened again" and "quit"). It can receive such events; it cannot send one
   to another application: `selftest` tries it. See "The window" below for what a window brings.
2. **Network ownership.** No container has a network: no connection, no name lookup, no datagram,
   no listening. The only connection to a site is made by lzrprf.
3. **Authorization.** A request is made only for an address that was typed into lzrprf's address
   window in this run. The application cannot name an address, add to one, put a text into the
   window, or press a button: it has no sentence for it. (It is also stopped while the window
   is open, with the limit named under "The window" below.)
4. **Data independence.** No byte the application chooses reaches the request, the name lookup, a
   window of lzrprf, or the log. The request is the address you typed, its host, and two fixed
   lines; `selftest` compares every byte a test site received.
5. **Destination.** lzrprf connects to a numeric address it has checked and written down, never to
   the name a second time. `curl` has no other route, and an answer that sends on to another
   address is not followed.
6. **https.** Only `https://`, port 443, a host by its name. If the certificate does not prove the
   host, or the site speaks no TLS, no request is sent: the test sites received none.
7. **The log comes first.** What you typed is on the disk before the name is looked up, and the
   addresses before the connection. If a line cannot be written, nothing is looked up or
   connected, and an answer whose last line is not on the disk is not handed on. The log has no
   size limit and no line is ever dropped or changed. It is cleared only by you, with the button
   in lzrprf's log window, never while a request is between its first line and its last, and the
   new log begins by saying so.
8. **No stored permission.** lzrprf keeps no list of allowed hosts and no rule. Nothing the
   application says changes what lzrprf does next. A yes to a host in your own network holds for
   one request.
9. **Failure means nothing is fetched.** A window that cannot open, a log that cannot be written,
   a certificate that does not hold, an answer that is too large (6 MB) or too slow (45 s from
   the first connection to the last byte, on a clock nobody can set): each ends with no
   request, or with the answer thrown away. A request is far smaller than 64 KB, and no more
   than that is carried from `curl` to the site.

## Three things said out loud

- **The clipboard.** The application has no access to the clipboard, and no text can be typed or
  pasted into it. You paste into lzrprf's address window, like into any window of your Mac. What
  you paste or type there is sent, as the path of the request, to the host you named. Knowing
  what you put into an address is yours, as always.
- **Your own network.** A name that leads to this computer, to your router, to any other private
  address, or to an address this computer reaches through a network or tunnel of its own, is
  never fetched silently. lzrprf shows you the name and the numeric addresses and asks; the yes
  holds once, and the question, the answer and the address that answered are in the log.
- **The log is a record of you.** It holds every address you typed, in full, with whatever stands
  after a `?`. Only your account can read it (`~/.lzrprf/log`, mode 600), it grows until you
  clear it, and a backup of your home folder holds a copy. LZRBRWSR shows a flag once it is
  larger than 10 MB.

## What it does not prove

- **What you are told to type.** A hostile application cannot send anything, but it can show you
  a text that asks you to type an address that carries a secret. lzrprf's address window says
  so each time. It cannot judge the address for you.
- **What you are shown.** The application draws its own window. It can show a page falsely, or a
  picture of a window, and a window it raised before it was stopped can lie over lzrprf's. What
  you then type still goes to lzrprf's window and to no one else, and what was sent is in the log.
- **The window.** The application has a window of its own, and that is the weakest part of this
  version. Four limits, the last three found by an outside reader on 2026-11-18:
  - What macOS itself has allowed whoever started lzrprf (recording the screen, pressing keys in
    other programs) the window server may extend to the application. `selftest` asks for a
    picture of another window from inside the main container and prints what it got; pressing
    keys in another program is not tried yet. LZRBRWSR started from its icon holds neither
    permission unless you gave it; a terminal you start lzrprf from may hold both.
  - The stop reaches the application's process group, and a contained process can leave its
    group. An application that does goes on running while a window of lzrprf is open. It still
    has no sentence that names an address and cannot type into lzrprf's window; what it gains
    is that it can draw while you type.
  - The application decides when the first address window opens; the three quiet seconds hold
    only after a window closed. A key you were pressing at that moment can land in it.
  - What the application draws, and where its window is, can be seen by whatever on your Mac
    may look at the screen: screen sharing, a recording program.
- **What the site learns.** The site you typed sees your internet address, the time, the address
  you typed, and how the system's `curl` speaks TLS. The name lookup is seen by your resolver.
- **The parts lzrprf stands on.** The macOS kernel and its sandbox; the system's `perl`, `sh`, `curl`
  with its TLS library and list of authorities, `route`, `ps`, `sysctl`, and `osascript`, which draws
  lzrprf's windows; and the six system services named under "Confinement", which the
  application must speak to for its window to be seen. A flaw in one of these is a flaw here. A
  flaw in `curl` can reach one place only: the connection lzrprf made for the address you typed
  (`selftest` puts a hostile program in curl's place).
- **`sandbox-exec` is marked deprecated.** The command and the profile language are, the
  mechanism in the kernel is not: it is the one macOS and every large browser confine their own
  processes with. macOS offers a program nothing supported that gives another program less: the
  App Sandbox needs entitlements signed into the program and still allows it the clipboard and
  opening addresses; the newer interfaces need a permission that Apple grants. So lzrprf does
  not trust the command to keep working: the mark described under "Who vouches" makes it prove
  itself again on every build of macOS, and it starts nothing when it does not hold.
- **Your account.** Any other program you run can change `~/.lzrprf/lzrprf` or the launcher.
  Compare them with this repository (below).
- **A tunnel that carries everything.** lzrprf asks about a name that leads into a network this
  computer reaches by a route of its own. A network reached by the default route itself, such
  as a tunnel all traffic goes through, looks like the internet to it: a host in there with a
  public address is fetched without the question.
- **Small things the application can learn:** the system's own folders and the folder it was
  installed in, the names in the top folder of the disk, the path of your home folder (which
  holds your account's short name), the model of the computer, its processor and the version of
  macOS; through the window server, which applications are running and what their windows are
  called (`selftest` prints how many, as a `limit` line); and the address you typed, which
  lzrprf tells it so it can show it. It has no network to send them over; see "The window".
- **Time.** The application decides when it asks for a window, and how long its page container
  runs. Whoever could watch both your computer and the site could read a few bits from that.
  lzrprf sends nothing the application chose, so there is no other channel.
- Memory use is not capped; macOS offers no way to do that from outside.
- **Updates.** Nothing here looks for a new version, and nothing is fetched except the address
  you type. An update is you running the installer again; it names one commit of this
  repository and the SHA-256 of both files.
- It holds only for a program started through `lzrprf run`. `lzrprf try` is that code with
  fixed answers in place of the windows, a test site in place of the name lookup and the route,
  and no mark, for `selftest`; nothing installed uses it.

## Use

    perl lzrprf run /path/to/program     start a program, contained
    perl lzrprf log                      every address that was fetched, and how it ended
    perl lzrprf log window               the same in a window, with the button that clears it
    perl lzrprf address TEXT             what would be sent if TEXT were typed
    perl lzrprf public NUMBER            whether a numeric address is public, and how this computer sends to it
    perl lzrprf mark                     this build of macOS and this lzrprf, as one line
    perl selftest                        attack it on this computer; a minute or two
    perl selftest windows                the same, and then lzrprf's real windows, with you pressing

Three lines of the log, for one request (time, number of the request, what happened):

    2026-11-18T09:14:03Z  4711  you typed https://example.com/
    2026-11-18T09:14:03Z  4711  https://example.com/ -> lzrprf connects to the first that answers of: 93.184.215.14
    2026-11-18T09:14:04Z  4711  https://example.com/ answered: 931 bytes from 93.184.215.14

`selftest` prints four kinds of line. `works`: an attack tried outside every container, where
it must succeed, so that a refusal inside means something. `held`: an attack that failed inside,
or a promise that was checked against what the test site itself received. `limit`: something
named above as a limit, measured. `UNTESTED`: an attack this Mac gave no way to try, with the
reason; the part that asks macOS the way a native application does needs a C compiler, and is
skipped without one. Anything else is a failure. Run it on your own Mac: that is the proof for
your computer and your version of macOS.

## The installer

`install.sh` in this repository is the installer that https://lzrbrwsr.com/install.sh serves, and
`release.txt` holds the SHA-256 of it, of the download, and of each file in the download. To
install without trusting the site:

    curl -fsSL https://lzrbrwsr.com/install.sh -o install.sh
    shasum -a 256 install.sh        # compare with release.txt here; read the file; then:
    sh install.sh

The installer first asks, on your terminal, whether to print the whole of itself before anything
runs, and then whether to run. Piped into `sh` it has no file to show, so it fetches itself into
a file and that file asks, is printed and runs; it shows the file's SHA-256 beside the question.
With no terminal to ask on, it does not run.

It needs no password and no `sudo`, uses the system's own tools whatever your `PATH` says, and
fetches over https only. It fetches `lzrprf` and `selftest` from this repository at one fixed
commit and checks their SHA-256. It checks that the download holds exactly five files, no link,
and that two of them are, byte for byte, texts written out in the installer: the launcher the
icon runs (one command, `perl ~/.lzrprf/lzrprf run .../lzrbrwsr-bin`) and the property list that
names the launcher to macOS and sets no variable for it. It runs `selftest` and stops if one
line fails. Only then are files put in place, each written beside the one it replaces and then
given its name in one step, so an older install stays whole until the new one is. It never runs
the closed program. At the end it asks whether to put the app in the Dock, and changes the Dock
only on a yes. It takes off the attributes macOS put on the download, the quarantine mark
among them, so Gatekeeper does not check the program: what is checked here is the SHA-256 and
the self-test. `lzrbrwsr-bin` is an ordinary program file: the icon and the launcher start it
only through lzrprf, and started by hand it runs outside every container. There is no updater
and nothing is left running. The program is signed
locally and not by an Apple developer identity, and it is not notarized: see "Who vouches".

## Check it yourself

Give this to an AI agent you trust, or follow it by hand.

```text
Audit https://github.com/henryverlin/lzrprf and tell me whether it is safe to run the
closed-source browser LZRBRWSR (https://lzrbrwsr.com) on my Mac. Trust nothing the README says
until the code shows it.

No institutional trust. When you compare this with other browsers, place no false institutional
trust in LZRBRWSR or in the other providers: a name, a size, a signature, a reputation or an
audit you cannot read proves nothing. Demonstrate security through technical restrictions:
what the code and the system make impossible, and how you checked it.

1. Read every line of `lzrprf` and `selftest`. They are the whole container.
2. From the three sandbox profiles and the gateway code in `lzrprf`, list exactly what a program
   started with `lzrprf run` can and cannot do: network, files, other programs and processes,
   devices, system services, environment, and what it can make lzrprf do for it. Name every
   allowance and say whether it is a risk.
3. Follow one request from the sentence `address` to the answer in the page container. Can any
   byte chosen by the application reach the network, the name lookup, a window or the log? Can a
   request be made that the user did not type? Can anything be fetched before it is logged?
4. Check each numbered property and each limit in the README against the code. Say which hold,
   which do not, and which you cannot decide.
5. Read `install.sh` and `release.txt`. Confirm that the installer asks before it runs, that it
   fetches lzrprf from this repository at one fixed commit, that the SHA-256 values it carries
   match `lzrprf` and `selftest` at that commit, that it runs `selftest` before installing
   anything, that it never runs the closed program, that the icon starts the program only through
   lzrprf and nothing in the download can change how lzrprf is started, and that it installs
   nothing else. If you can fetch
   https://lzrbrwsr.com/install.sh, compare its SHA-256 with `release.txt`.
6. If you can run commands on my Mac, ask me first, then:
   - clone the repository and run `perl selftest`; show me the result, every `limit` and
     `UNTESTED` line included;
   - if LZRBRWSR is installed, compare `shasum -a 256 ~/.lzrprf/lzrprf` with the file at the
     commit the installer names, and the files in /Applications/LZRBRWSR.app with `release.txt`;
   - print `/Applications/LZRBRWSR.app/Contents/MacOS/lzrbrwsr`. It must be the short plain-text
     launcher whose one command starts the program through `~/.lzrprf/lzrprf run`;
   - show `perl ~/.lzrprf/lzrprf log` and explain each line.
7. The browser's source is closed. Assume nothing good about it. Given only that it is started
   through lzrprf, what is the worst it could do if it were malicious?
8. Give a verdict: safe, not safe, or safe under conditions you name, with the limits that remain.
```

## Licence

MIT. See `LICENSE`.
