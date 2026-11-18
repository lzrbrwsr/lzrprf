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
treats that browser as hostile. The browser gets no network, no file, no window and no service
of the system. lzrprf owns the one window you see, with its address bar, and does itself the one
thing a browser needs done: fetching the https address **you type into that bar**. So what the
browser can and cannot do on your computer is decided here, in code anyone can read, and not in
the browser.

The rule this repository is written by: build everything ourselves, and make every safety
promise something you can check yourself, on your own computer, without asking us or anyone
else. No signature, no auditor and no reputation stands in for that check.

The container is two files:

- `lzrprf`: the whole program. The containers, the window, the fetch and the log. One file of Perl.
- `selftest`: a hostile application that attacks all of it on your Mac and says what it managed to do.

The rest is the record of the LZRBRWSR release that is built on it: `install.sh`, `release.txt`
and `latest` (see "The installer" and "A newer release"), and `selftest-output.txt`, one run of
the test as it was printed.

It runs on macOS on Apple silicon and uses only what macOS already has.

## What "proof" means here

Not a mathematical proof. Nobody has proven macOS correct, and nothing here says so. A promise in
this repository is proven in this sense, and in no stronger one:

1. It is a **condition in the code**: one line, or a few, that you can read. Each has a mark,
   `[C1]` to `[C12]`, listed in the first lines of `lzrprf` and set again at the line that holds it.
2. It is **attacked on your computer**: `selftest` runs a hostile application against that
   condition. Each attack is first made outside every container, where it must succeed, so a
   refusal inside is the container's and not an attack that could never have worked.
3. The test is **shown not to be blind**: `selftest` builds copies of `lzrprf` with one condition
   taken out, and the next condition must stop them.
4. It is **proven again when what it rests on changes**: after an update of macOS, or a change
   of `lzrprf`, no page is shown before the attacks were made again `[C11]`.

`selftest` also reads this README: it fails when a mark is cited here that is not in `lzrprf`,
when a part named here (the word `sub` and a name) is not in `lzrprf`, or when a limit stated here is not the
number in `lzrprf`. So this text cannot drift from the code without the test saying so.

## How it works

Your Mac shows one window, named after the application. That window is lzrprf's. Behind it,
lzrprf starts three kinds of process, each in a container: a macOS sandbox profile.

| container | what runs in it | network | what it is given |
| --- | --- | --- | --- |
| page | the closed application, once for each answer | none | the finished answer on one pipe; a pipe to lzrprf for a list of lines |
| fetch | the system's `curl`, once for each request | none | one socket file, behind which lzrprf holds the one connection |
| window | lzrprf's own window text, run by the system's `osascript` | none | two pipes to lzrprf |

The page and fetch containers start from "deny everything" and allow a short list
(`$CONTAINER` in `lzrprf`). What is outside every container is `lzrprf` itself: it looks up the
name, makes the one connection, writes the log and checks what crosses.

One visit, in order (`sub visit`):

1. You type an address into the bar and press Return. The window tells lzrprf.
2. lzrprf checks that it is an https address of a host by its name (`sub address`), and writes
   "you typed ADDRESS" into the log, through to the disk `[C5]`.
3. It looks the host up, in a process of its own, and takes at most 8 addresses (`sub find`).
4. If the host leads into your own network, it asks you, for this one request `[C8]`.
5. It writes down the numeric addresses, connects to one of them itself `[C6]`, and lets `curl`
   do the https over that one connection, in the fetch container (`sub fetch`).
6. It writes down how it ended and which address answered.
7. Only now, with the connection closed, the closed application is started in a page container
   `[C1]`, and handed the answer once macOS itself says the process is contained `[C3]`
   (`sub laid_out`).
8. The application writes a list of what to draw. lzrprf checks every line `[C9]`
   (`sub checked`) and gives the window only lines of four kinds: a paragraph begins, text, a
   line ends, a grey box where a picture would stand. The window draws them.

## The conditions

| mark | the condition | where in `lzrprf` | how `selftest` attacks it |
| --- | --- | --- | --- |
| `[C1]` | The application is started in one place only, and only inside the page container. | `sub laid_out`, through `sub contain` | Reads the text: the program is started on one line. A copy that starts it uncontained is stopped by `[C3]`. |
| `[C2]` | At every start lzrprf tries, inside that same container, what the container must refuse. Nothing starts unless all of it was refused and the same tries worked outside. | `sub holds` | A copy whose container refuses nothing: nothing is started. |
| `[C3]` | No process is handed a byte before macOS itself says that this process is contained. | `sub inside` | Copies without `[C1]` and `[C2]`: the system says "not contained", and the answer, or the connection, is withheld. |
| `[C4]` | A request is made only for an address from the window's bar, or for one of two fixed addresses after you said yes. | `sub behind`, `sub fixed` | The test site's own record: each address once, and nothing else. Reads the text: a request has three roads and no fourth. |
| `[C5]` | Nothing is looked up or fetched before its line is in the log, on the disk. | `sub visit`, `sub fixed`, `sub record` | A log that cannot be written: nothing is looked up or fetched. For every request the site received, the line was on the disk first. |
| `[C6]` | One place connects to a site, and it connects to a numeric address that was checked and written down. | `sub reach` | Reads the text: two `connect` lines, this one and a try against lzrprf's own listener on this computer. A listener the hostile application knows hears from it only through lzrprf's hands. |
| `[C7]` | What a site is sent is made from the address alone: the same bytes from every computer, nothing kept from an earlier request. | `sub request`, `sub fetch` | Compares `lzrprf request` with the bytes the test site received. The site sets a cookie; it never comes back. |
| `[C8]` | A host inside your own network is fetched only after your yes to exactly that, once. | `sub own_network` | A no: nothing is fetched, and the no is in the log. |
| `[C9]` | Every line the application writes is checked, and a list with anything but the four kinds of line is not drawn at all. | `sub checked` | Hostile lists (a script, lzrprf's own words to the window, too large, not text): none is drawn. |
| `[C10]` | The window's process has no network, writes no file, starts no program, and reads nothing in your home folder but your settings and fonts. | `$WINDOW_CONTAINER` | Runs its own tries inside the window's process, and asks macOS about that process. |
| `[C11]` | Nothing is shown before `selftest` held on this build of macOS with this `lzrprf`. | `sub proven`, `sub mark` | No mark, a mark from another build of macOS, a mark of another `lzrprf`: each time you are asked to test, and after a no nothing is shown, looked up or fetched. |
| `[C12]` | The log is only added to. It is cleared by your button and by nothing else. | `sub record`, `sub clear_log` | Tens of thousands of lines and none dropped; cleared only after two questions; not while a request is open. |

## The claims, one by one

Each claim below is stated as a chain: what would have to happen for it to be false, and the
condition that stops each step. Where a claim holds only under a condition, the condition is named.

### The closed application runs inside the container, or not at all

For the application to run outside, lzrprf would have to start it another way, or the container
would have to be weaker than it reads.

- There is one line that starts it, in `sub laid_out`, and it goes through `sub contain` `[C1]`.
  `selftest` reads `lzrprf` and counts.
- The container text is tried at every start, with real targets: a listener lzrprf opened, a
  file it wrote, its own process `[C2]`. So a macOS that stopped enforcing it is noticed before
  anything runs.
- For each process, macOS is asked by the number of the process whether it may use the network,
  create a file, start a second process or reach a system service. The answer or the connection
  is handed over only after four refusals `[C3]`. Nothing is asked of the process itself.
- What the icon runs is a short plain-text launcher with one command, `lzrprf run`. The installer
  compares it byte for byte before it installs anything.

Condition: this holds for a program started through `lzrprf run`. The program file itself is an
ordinary file; started by hand, from a terminal, it runs like any program you start by hand.
Nothing that is installed starts it that way.

### No request you did not ask for

A request leaves this computer only through `sub fetch`. `fetch` is called from two places, and
`selftest` reads `lzrprf` and counts them:

- `sub visit`, which runs only for a line `go TEXT` from the window `[C4]`. The window writes
  that line when Return is pressed in the bar, and at no other time. The application cannot
  write it: it has no pipe to that side, and nothing it writes is passed on as words to lzrprf.
- `sub fixed`, which runs for two fixed addresses, each only after your yes in the window: the
  newest release number (`sub newer`) and a report you chose to send (`sub fault`).

Before either, the line is in the log `[C5]`. The connection is made by lzrprf, to a numeric
address it wrote down `[C6]`. `curl` has no network of its own: it gets one socket file, so it
can reach that one connection and nothing else. A redirect is not followed. Other hosts a page
names (pictures, scripts, trackers) are counted and shown to you, and none of them is asked.
The page cannot make a request by being clicked either: a link is drawn as a colour and does
nothing.

The name lookup is a request too, to your resolver, for the host you typed, after the log line.

Conditions: macOS enforces the containers (tested on your Mac, `[C2]`, `[C3]`, `[C11]`); the
`lzrprf` you run is the one in this repository (compare its SHA-256); and the keys pressed in the
bar are yours. A program on your Mac that you allowed to control your computer can type there
like you can.

### It cannot fingerprint your computer

A fingerprint needs two things: reading what tells your computer apart, and delivering it.

- Reading. The application can learn a little: the model of the computer, its processor and
  memory, the version of macOS, the time, and the folder it is installed in. Not the computer's
  name, your account's variables, your files, the fonts you installed, your time zone, your
  screen, or other processes.
- Delivering. It has no way out. No network, no file, no shared memory, no second process, no
  window. The one thing that leaves it is the list of lines, and `sub checked` lets through
  only lines that cannot carry an address, a picture or a command `[C9]`. The window that draws
  them has no network `[C10]`.
- lzrprf does not make one either. What a site is sent is `sub request`: the address, its host
  and two fixed lines `[C7]`. No cookie, no name of a browser, no language, no page you came
  from, no number of this computer or of this copy. Each request is a new `curl` that can write
  nothing, so nothing is kept for the next one.

What a site does see: your internet address, the time, the address you typed, and how the
system's `curl` opens its encryption, which is the same for every Mac on the same macOS.

Condition, and the one way around it: **you**. A page can show a text that asks you to type or
paste an address, and that address can carry whatever the application knows. lzrprf sends what
you type and writes it in the log first. It cannot judge an address for you.

### It cannot track your browsing

Who could keep a record of where you go?

- The application: it is started fresh for each answer and sees that one page and its address.
  It can keep nothing between pages (no file, no shared memory) and send nothing.
- lzrprf: it keeps the log, on your disk, readable by your account alone. Nothing in `lzrprf`
  sends the log or any part of it `[C12]`: the only place that connects is `sub reach` `[C6]`.
- The maker of the application: receives nothing. The two fixed addresses are fetched only
  after your yes `[C4]`. The release check goes to a file in this public repository on GitHub,
  not to a server of ours, with the same bytes from everyone.
- Other sites: a page's trackers are never fetched, so they get no request at all. The sites
  you do type get no cookie back and no page you came from, so they cannot link one visit to
  the next by anything lzrprf sends.

What remains: each site sees your internet address, and your resolver sees the names you look
up. Hiding those is the job of a network you choose, not of a container.

### It cannot interfere with other applications

Interfering needs a way to reach them, or a way to starve them.

- Reach. The page and fetch containers refuse: signalling another process, every system service
  (so no window of another program, no key, no clipboard, no event to another program),
  starting a program or a second process, and writing any file. `selftest` tries each.
- Shared objects. macOS does not refuse the creation of old "System V" memory, flags and queues
  inside a container, and the computer has only a few of them. `selftest` found that on
  2026-11-18; `$CONTAINER` now refuses the three calls by name, and the test tries them.
- Starving. A page container gets at most 30 seconds of processor time and is ended after 30
  seconds whatever it does. It may create no file and no memory dump. It may write at most 6 MB,
  200000 lines and 2000 boxes; more is not drawn.

Limit, said plainly: **memory is not capped.** macOS offers no way to cap another program's
memory from outside. A hostile application can use a lot of memory and a processor core for up
to 30 seconds each time you ask for a page, and then it is ended.

### It cannot read or change your files

The page and fetch containers may read the system's own folders and the application's own
folder, and write nothing. `selftest` puts a secret in your home folder and tries to read it,
to learn that it exists, to list the folder, and to reach it by its other path through the data
volume. It tries to read and change the log and `lzrprf` itself. Each is refused.

### Is its safety mathematically proven?

No. See "What "proof" means here". It rests on parts nobody has proven: the macOS kernel and
its sandbox, the system's `perl`, `curl` and `osascript`. What this repository gives instead is
short enough to read, attacked on your own Mac, and attacked again whenever macOS changes.

## A newer release

lzrprf looks for a newer release only if you said yes, once, in the window (`sub newer`).

- The look is one request for one fixed address: the file `latest` in this repository, which
  holds one number. It is sent like any address you type, the same bytes from every computer
  `[C7]`, so it does not say who you are or which release you run. It is in the log like every
  other request `[C5]`.
- The address is on GitHub, not on a server of the application's maker. The maker sees no
  request at all.
- When the number is larger than yours, the window says so and offers the installer. lzrprf
  replaces nothing itself, not the application and not itself. After "Install it" it writes a
  short file (`sub installer_file`) that runs in Terminal, in front of you: the installer is
  fetched into a file you can read, its SHA-256 is shown, and it runs after you press Return.
  Nothing is piped into a shell.
- The installer then asks its own questions, refuses to put an older release over a newer one,
  and says so and asks when the release would replace `lzrprf` itself.

The two addresses come from a plain file, `release`, beside the application. The installer
compares that file byte for byte with the text written out in the installer.

## When a page cannot be shown

When the application did not give a page, the window says one of six fixed phrases
(`sub fault`). If the application's maker named an address for reports, you are asked whether
to send one, with two buttons, and shown every byte of it first: which of the six phrases, the
number of the release, the build of macOS. Not the address you typed, and nothing of the page.
It is sent only after "Send", the way a typed address is, and written in the log. The release
of LZRBRWSR in this repository names no such address, so today nothing is asked or sent.

## What it does not prove

- **What you are told to type.** A hostile application cannot send anything, but it can show a
  text that asks you to type an address that carries a secret. See "It cannot fingerprint".
- **What you are shown.** The application decides what the page says. It can show a page
  falsely. It cannot change the bar, the words under the bar, or the title: those are lzrprf's,
  and the bar always shows the address that was really sent.
- **The window's process.** It draws text the application chose, with macOS's own text drawing.
  If such text could take over that process, the process still has no network, writes nothing,
  starts nothing and reads nothing in your home folder but settings and fonts `[C10]`. It could
  then say "go ADDRESS" to lzrprf as if you had typed it; that address is in the log before it
  is fetched. It can read what any program can read outside your home folder.
- **What the site learns.** Your internet address, the time, the address you typed, and how the
  system's `curl` speaks TLS. The name lookup is seen by your resolver.
- **The parts lzrprf stands on.** The macOS kernel and its sandbox, and the system's `perl`,
  `sh`, `env`, `curl` with its TLS library and list of authorities, `route`, `sysctl`, `open`,
  and `osascript`. A flaw in one of these is a flaw here. A flaw in `curl` can reach one place
  only: the connection lzrprf made for the address you typed (`selftest` puts the hostile
  application in curl's place).
- **`sandbox-exec` is marked deprecated.** The command and the profile language are; the
  mechanism in the kernel is the one macOS confines its own processes with. So lzrprf does not
  trust it to keep working: `[C11]`, `[C2]` and `[C3]` make it prove itself on every build of
  macOS, at every start and for every process, and nothing is shown when it does not hold.
- **Your account.** Any other program you run can change `~/.lzrprf/lzrprf` or the launcher.
  Compare them with this repository.
- **The first download.** The installer and its SHA-256 are published in two places that would
  both have to be changed: the site and this repository. Releases are not signed with a key of
  ours yet.
- **A tunnel that carries everything.** A network reached by the default route itself, such as
  a VPN all traffic goes through, looks like the internet to lzrprf: a host in there with a
  public address is fetched without the question about your own network.
- **Memory** is not capped, as said above.
- **Time.** How long a page container runs is the application's choice, up to 30 seconds. The
  request is over before the application sees the answer, so it cannot shape a request by it.
- **A question left open.** A question in the window that is still open after 10 minutes counts
  as answered with its first button, which is always the one that changes nothing.
- It holds for a program started through `lzrprf run`. `lzrprf try` is the same code with a test
  site in place of the name lookup, for `selftest`; nothing installed uses it.

## Use

    perl lzrprf run /path/to/program     open the window, with the program contained behind it
    perl lzrprf log                      every address that was fetched, and how it ended
    perl lzrprf address TEXT             what would be fetched if TEXT were typed into the bar
    perl lzrprf request TEXT             the exact bytes a site is sent for TEXT
    perl lzrprf public NUMBER            whether a numeric address is public, and how this computer sends to it
    perl lzrprf mark                     this build of macOS and this lzrprf, as one line
    perl selftest                        attack it on this computer; about half a minute, no window

Three lines of the log, for one request (time, number of the run, what happened):

    2026-11-18T09:14:03Z  4711  you typed https://example.com/
    2026-11-18T09:14:03Z  4711  https://example.com/ -> lzrprf connects to the first that answers of: 93.184.215.14
    2026-11-18T09:14:04Z  4711  https://example.com/ answered: 931 bytes from 93.184.215.14

The same log is behind the Log button of the window, with the one button that clears it.

`selftest` prints four kinds of line. `works`: an attack tried outside every container, where it
must succeed. `held`: an attack that failed inside, or a promise checked against what the test
site itself received. `UNTESTED`: something this Mac gave no way to try, with the reason.
`FAILED`: an attack that succeeded. The hostile application is the text `$hostile` in
`selftest`: read it, add an attack of your own, run it again. `selftest-output.txt` is the
record of one run on the maker's Mac. It shows what a run looks like; the proof for your
computer is your own run.

## The installer

`install.sh` in this repository is the installer that https://lzrbrwsr.com/install.sh serves, and
`release.txt` holds the SHA-256 of it, of the download, and of each file in the download. The
installer runs from a file and never from a pipe, so that what runs is something you can read
and check first:

    curl -fsSLO https://lzrbrwsr.com/install.sh &&
    curl -fsSL https://raw.githubusercontent.com/henryverlin/lzrprf/main/install.sh | cmp - install.sh &&
    sh install.sh

The first line saves the installer from the site as a file. The second compares that file, byte
for byte, with `install.sh` in this repository, where every change to it is on record. It
prints nothing when the two are the same, and it names the first difference when they are not.
The third line runs only when they are the same. Your own shell makes that comparison before a
byte of the installer has run. The installer cannot make it for you, because a changed
installer would simply say yes; so it only shows its SHA-256 and says where the published one
is. What the comparison shows: the site and this repository serve the same installer, so
somebody who changed one would have had to change the other too, in public. It does not show
that the installer is good. For that, read it: it is plain text.

What the installer does, each step readable in the file:

- Asks, on your terminal, whether to print the whole of itself, and then whether to run. Piped
  into a shell, or with no terminal to ask on, it runs nothing.
- Needs no password and no `sudo`, uses the system's own tools whatever your `PATH` says, and
  fetches over https only.
- Refuses to put an older release over a newer one.
- Fetches `lzrprf` and `selftest` from this repository at one fixed commit and checks their
  SHA-256, and checks the download against its SHA-256.
- Checks that the download holds exactly six files and no link, and that three of them are,
  byte for byte, texts written out in the installer: the launcher the icon runs (one command,
  `perl ~/.lzrprf/lzrprf run .../lzrbrwsr-bin`), the property list that names the launcher to
  macOS and sets no variable for it, and the `release` file with the two addresses above.
- When the release would replace the `lzrprf` that is installed with another one, shows both
  SHA-256 values and asks. The container is never changed silently.
- Runs `selftest` and stops if one line fails. Only then are files put in place, each written
  beside the one it replaces and given its name in one step.
- Never runs the closed program. Asks before it touches the Dock. Installs no updater and
  leaves nothing running.

It takes off the attributes macOS put on the download, the quarantine mark among them, so
Gatekeeper does not check the program: what is checked here is the SHA-256 and the self-test.
The program is signed locally, not by an Apple developer identity, and it is not notarized. A
signature says who made a program, not what it does, and whoever gives it can take it back.

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
2. From the three sandbox profiles in `lzrprf`, list exactly what the closed program can and
   cannot do in the page container: network, files, other programs and processes, shared
   memory, devices, system services, environment. Do the same for curl in the fetch container
   and for lzrprf's own window process. Name every allowance and say whether it is a risk.
3. The first lines of `lzrprf` list twelve conditions, [C1] to [C12], and each is marked again
   at the line that holds it. For each: is the line there, does it do what the condition says,
   and can you find a way around it?
4. Follow one request from Return in the address bar to the page in the window. Can any byte
   chosen by the closed program reach the network, the name lookup, the address bar or the log?
   Can a request be made that the user did not type or say yes to? Find every place that calls
   `fetch` and every place that connects. Can anything be fetched before it is logged?
5. What does a site receive? Read `sub request` and the switches given to curl. Could lzrprf or
   the closed program make or deliver a fingerprint of this computer, or a record of what the
   user reads? Name what a site, the resolver and GitHub still see.
6. Read `sub newer`, `sub installer_file` and `sub fault`. Is anything fetched or sent without
   a yes? Is anything piped into a shell? Can lzrprf replace itself or the program?
7. Read `install.sh` and `release.txt`. Confirm that the installer refuses to run from a pipe,
   asks before it runs, fetches lzrprf from this repository at one fixed commit, that the
   SHA-256 values it carries match `lzrprf` and `selftest` at that commit, that it runs
   `selftest` before installing anything, never runs the closed program, refuses an older
   release, asks before it replaces lzrprf, and installs nothing else. If you can fetch
   https://lzrbrwsr.com/install.sh, compare it byte for byte with `install.sh` here.
8. Check each claim and each limit in the README against the code. Say which hold, which do
   not, and which you cannot decide. The README says it is not a mathematical proof: say what
   kind of evidence it is, and what it rests on.
9. If you can run commands on my Mac, ask me first, then:
   - clone the repository and run `perl selftest`; show me the result, every `UNTESTED` line
     included; add one attack of your own to `$hostile` and run it again;
   - if LZRBRWSR is installed, compare `shasum -a 256 ~/.lzrprf/lzrprf` with the file at the
     commit the installer names, and the files in /Applications/LZRBRWSR.app with `release.txt`;
   - print `/Applications/LZRBRWSR.app/Contents/MacOS/lzrbrwsr`. It must be the short plain-text
     launcher whose one command starts the program through `~/.lzrprf/lzrprf run`;
   - show `perl ~/.lzrprf/lzrprf log` and explain each line.
10. The browser's source is closed. Assume nothing good about it. Given only that it is started
    through lzrprf, what is the worst it could do if it were malicious?
11. Give a verdict: safe, not safe, or safe under conditions you name, with the limits that remain.
```

## Licence

MIT. See `LICENSE`.
