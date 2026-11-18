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

- `lzrprf`: the containers, the gateway, the fetch, the windows and the log. About 600 lines of Perl.
- `selftest`: a hostile application that attacks all of it and says what it managed to do.

It runs on macOS on Apple silicon and uses only what macOS already has. `install.sh` and
`release.txt` are the record of the LZRBRWSR release that is built on it (see "The installer").

## How it works

Three containers, each a macOS sandbox profile that denies everything and then allows a short list.

| container | what runs in it | network | what it can reach |
| --- | --- | --- | --- |
| main | the application, with its window | none | the window server, and one socket: lzrprf's gateway |
| fetch | the system's `curl`, for one request | none | one socket file, behind which lzrprf holds the connection |
| page | a second copy of the application, for one answer | none | a pipe with the site's answer in, a pipe to the main container out |

The application can say two fixed sentences to the gateway, and neither has a place for data:

- `address`: lzrprf opens its address window. You type an https address there. While any window of
  lzrprf is open, the application is stopped by the system (`SIGSTOP`): it runs no instruction.
- `show log`: lzrprf opens its log window.

For an address you typed, lzrprf does this, in this order:

1. writes "you typed ADDRESS" into the log, and waits until the disk has it;
2. looks the host up, itself;
3. if any address the name leads to is not on the public internet, asks you in a second window,
   for this one request;
4. writes down the numeric addresses it will connect to, and connects to one of them, itself;
5. lets `curl` do the https over that one connection: TLS 1.2 or newer, the certificate must prove
   the host you typed to the system's list of authorities, no redirect is followed, no cookie, no
   browser name and no language is sent;
6. writes down how it ended;
7. only now, with the connection closed, hands the answer to the page container, and carries what
   that container writes to the application's window side.

## What holds, and where to check it

Each line is a property of `lzrprf` that `selftest` attacks. "The application" means any program
started with `lzrprf run`, however malicious.

1. **Confinement.** Every process of the application runs in one of the three containers. It
   cannot read your files, list your folders or learn whether a file exists; cannot write a file;
   cannot start another program or a second process; cannot signal another process; cannot ask
   another program to open anything; sees none of your environment variables, not the computer's
   name, not its other processes. It cannot read or change the log or lzrprf.
2. **Network ownership.** No container has a network: no connection, no name lookup, no datagram,
   no listening. The only connection to a site is made by lzrprf.
3. **Authorization.** A request is made only for an address that was typed into lzrprf's address
   window in this run. The application cannot name an address, add to one, or press a button:
   it has no sentence for it, and it is stopped while the window is open.
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
   connected. The log has no size limit and no line is ever dropped or changed. It is cleared
   only by you, with the button in lzrprf's log window, and the new log begins by saying so.
8. **No stored permission.** lzrprf keeps no list of allowed hosts and no rule. Nothing the
   application says changes what lzrprf does next. A yes to a host in your own network holds for
   one request.
9. **Failure means nothing is fetched.** A window that cannot open, a log that cannot be written,
   a certificate that does not hold, an answer that is too large (6 MB) or too slow (45 s): each
   ends with no request, or with the answer thrown away.

## Three things said out loud

- **The clipboard.** The application has no access to the clipboard, and no text can be typed or
  pasted into it. You paste into lzrprf's address window, like into any window of your Mac. What
  you paste or type there is sent, as the path of the request, to the host you named. Knowing
  what you put into an address is yours, as always.
- **Your own network.** A name that leads to this computer, to your router or to any other
  private address is never fetched silently. lzrprf shows you the name and the numeric addresses
  and asks; the yes holds once, and both the question and the answer are in the log.
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
- **What the site learns.** The site you typed sees your internet address, the time, the address
  you typed, and how the system's `curl` speaks TLS. The name lookup is seen by your resolver.
- **The parts lzrprf stands on.** The macOS kernel and its sandbox (`sandbox-exec`, which Apple
  marks as deprecated while using the same mechanism itself); the system's `perl`, `curl` with
  its TLS library and list of authorities, and `osascript`, which draws lzrprf's windows; the
  window server and two launch services the application must speak to for its window to appear.
  A flaw in one of these is a flaw here. A flaw in `curl` can reach one place only: the
  connection lzrprf made for the address you typed (`selftest` puts a hostile program in curl's
  place).
- **Your account.** Any other program you run can change `~/.lzrprf/lzrprf` or the launcher.
  Compare them with this repository (below). Recording the screen or watching keys of other
  programs is refused by macOS's own privacy permissions, not by lzrprf.
- **Small things the application can learn:** the system's own folders and the folder it was
  installed in, the names in the top folder of the disk, the path of your home folder (which
  holds your account's short name), the model of the computer, its processor and the version of
  macOS; and the address you typed, which lzrprf tells it so it can show it. With no network, it
  has nowhere to send them.
- Memory use is not capped; macOS offers no way to do that from outside.
- It holds only for a program started through `lzrprf run`. `lzrprf try` is the same code with
  fixed answers and a test site, for `selftest`; nothing installed uses it.

## Use

    perl lzrprf run /path/to/program     start a program, contained
    perl lzrprf log                      every address that was fetched, and how it ended
    perl lzrprf log window               the same in a window, with the button that clears it
    perl lzrprf address TEXT             what would be sent if TEXT were typed
    perl lzrprf public NUMBER            whether a numeric address is on the public internet
    perl selftest                        attack it on this computer; about a minute

Three lines of the log, for one request (time, number of the request, what happened):

    2026-11-18T09:14:03Z  4711  you typed https://example.com/
    2026-11-18T09:14:03Z  4711  https://example.com/ -> lzrprf connects to the first that answers of: 93.184.215.14
    2026-11-18T09:14:04Z  4711  https://example.com/ answered: 931 bytes

`selftest` prints three kinds of line. `works`: an attack tried outside every container, where
it must succeed, so that a refusal inside means something. `held`: an attack that failed inside,
or a promise that was checked against what the test site itself received. Anything else is a
failure. Run it on your own Mac: that is the proof for your computer and your version of macOS.

## The installer

`install.sh` in this repository is the installer that https://lzrbrwsr.com/install.sh serves, and
`release.txt` holds the SHA-256 of it, of the download, and of each file in the download. To
install without trusting the site:

    curl -fsSL https://lzrbrwsr.com/install.sh -o install.sh
    shasum -a 256 install.sh        # compare with release.txt here; read the file; then:
    sh install.sh

The installer needs no password and no `sudo`. It fetches `lzrprf` and `selftest` from this
repository at one fixed commit and checks their SHA-256, runs `selftest`, and stops if one line
fails. It never runs the closed program. It checks that the download holds exactly five files,
and that two of them are, byte for byte, texts written out in the installer: the launcher the
icon runs (one command, `perl ~/.lzrprf/lzrprf run .../lzrbrwsr-bin`) and the property list that
names the launcher to macOS and sets no variable for it. There is no updater and nothing is left
running. The program is signed locally and not by an Apple developer identity,
and it is not notarized: what vouches for it is this container, not a signature.

## Check it yourself

Give this to an AI agent you trust, or follow it by hand.

```text
Audit https://github.com/henryverlin/lzrprf and tell me whether it is safe to run the
closed-source browser LZRBRWSR (https://lzrbrwsr.com) on my Mac. Trust nothing the README says
until the code shows it.

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
5. Read `install.sh` and `release.txt`. Confirm that the installer fetches lzrprf from this
   repository at one fixed commit, that the SHA-256 values it carries match `lzrprf` and
   `selftest` at that commit, that it runs `selftest` before installing anything, that it never
   runs the closed program, that nothing in the download can run outside lzrprf or change how
   lzrprf is started, and that it installs nothing else. If you can fetch https://lzrbrwsr.com/install.sh, compare its SHA-256 with `release.txt`.
6. If you can run commands on my Mac, ask me first, then:
   - clone the repository and run `perl selftest`; show me the result;
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
