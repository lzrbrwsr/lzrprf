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

A page gets no keystroke and no form. The page is drawn as text that cannot be edited, the one
field in the window you can type into is the address bar, and every request is a GET without a
body (`sub request`). There is nowhere on a page to type a password.

The rule this repository is written by: build everything ourselves, and make every safety
promise something you can check yourself, on your own computer, without asking us or anyone
else. No signature, no auditor and no reputation stands in for that check.

The container is two files:

- `lzrprf`: the whole program. The containers, the window, the fetch and the log. One file of Perl.
- `selftest`: a hostile application that attacks all of it on your Mac and says what it managed to do.

The rest is the record of the LZRBRWSR release that is built on it. It is kept here so that
everything a person installs stands in a second, public place, where each change has a date:

- `install.sh`: the installer. The same file as https://lzrbrwsr.com/install.sh.
- `lzrbrwsr-macos-arm64.tar.gz`: the download. The same file the site serves. It is the closed
  application as it is installed, it holds no source, and it is **not** under this repository's
  licence (see "Licence").
- `release.txt`: the SHA-256 of the installer, of the download, of each file in the download,
  and of `lzrprf` and `selftest`. The same file as https://lzrbrwsr.com/release.txt.
- `latest`: one number, the newest release (see "A newer release").
- `selftest-output.txt`: the run of the test of exactly this release's `lzrprf`, as it was
  printed when the release was made. Its last line names the build of macOS and the SHA-256 of
  the `lzrprf` and `selftest` that were run. A record that names another sum than `release.txt`
  is not of this release.

It runs on macOS on Apple silicon and uses only what macOS already has.

## What "proof" means here

Not a mathematical proof. Nobody has proven macOS correct, and nothing here says so. A promise in
this repository is proven in this sense, and in no stronger one:

1. It is a **condition in the code**: one line, or a few, that you can read. Each has a mark,
   `[C1]` to `[C12]`, listed in the first lines of `lzrprf` and set again at the line that holds it.
2. It is **attacked on your computer**: `selftest` runs a hostile application against that
   condition. An attack on a container is first made outside every container, where it must
   succeed, so a refusal inside is the container's and not an attack that could never have
   worked. A condition that is not a container's (what is fetched, what is logged, what is
   drawn) is judged by what the test's own site received and by what the log holds. The hostile
   application is the test's own (`$hostile` in `selftest`), put in the closed application's
   place. The closed application is never run by the test, so what is shown is what the
   container does to any program, whatever LZRBRWSR is.
3. The test is **shown not to be blind** for the page container `[C1]`, the tries of `[C2]`,
   the start inside the container `[C3]`, the window container `[C10]`, the yes to untried
   checks `[C11]`, the limit on memory and the pair check. `selftest` builds eight copies of `lzrprf`, each with something taken out
   (`%lost` and the runs `lostwindow`, `lostpair` and `lostyes` in `selftest`), and what comes
   after it must stop each or show the difference: a page container that
   refuses nothing is stopped by `[C2]`; that container without the tries of `[C2]`, and a
   start outside the container, are both stopped by `[C3]`; a page container without its limit
   on memory is stopped by `[C2]`, and with the tries of `[C2]` taken out too, the attack on
   memory is made in it and its line says so; a window container with one refusal taken out is
   stopped by `[C10]`; a copy whose pair check is taken out, and a copy that counts a mark
   with untried checks without your yes, each fetch without the window or the question the
   real `lzrprf` puts first, and their lines say so. The other conditions have no such copy
   yet.
4. It is **proven again when what it rests on changes**: after an update of macOS, or a change
   of `lzrprf` or of the `selftest` beside it, no page is shown before the attacks were made
   again `[C11]`. A run of `selftest` takes the mark of what it tests away at its start and
   writes it again only when nothing failed, so a run that fails takes back an earlier proof.

So a run that held is evidence for the attacks it names, each with its control outside the
container and, for the seven things named in point 3, the weakened copies it must catch. It is not a proof that
no other attack exists.

`selftest` also reads this README when it stands beside it. It fails when the marks cited here
are not exactly the twelve in `lzrprf`, when a part named here (the word `sub` and a name) is
not in `lzrprf`, or when one of seven limits is not stated here as the number in `lzrprf`: 30
seconds for a fetch and for a page, 6 MB, 200000 lines, 2000 boxes, 10 minutes, 8 addresses.
That is a check of names and numbers, not of sentences. Whether a sentence here is true of the
code is for a reader to decide, and "Check it yourself" below is written for that reader. An
installed copy of `selftest` has no README beside it and skips this check.

## How it works

Your Mac shows one window, named after the application. That window is lzrprf's. Behind it,
lzrprf starts three kinds of process, each in a container: a macOS sandbox profile.

| container | what runs in it | network | what it is given |
| --- | --- | --- | --- |
| page | the closed application, once for each answer | none | the finished answer on one pipe; a pipe to lzrprf for a list of lines |
| fetch | the system's `curl`, once for each request | none | one socket file, behind which lzrprf holds the one connection |
| window | lzrprf's own window text, run by the system's `osascript` | none of its own | two pipes to lzrprf, and the system's services a window needs |

The page and fetch containers start from "deny everything" and allow a short list
(`$CONTAINER` in `lzrprf`). The window container is written the other way round
(`$WINDOW_CONTAINER`): what a program of yours may do, without a list of things. It is the
weaker of the two kinds, and "What it does not prove" says what follows from that. What is
outside every container is `lzrprf` itself: it looks up the name, makes the one connection,
writes the log and checks what crosses.

Before the first page, at every start (`sub behind`): macOS is asked whether the window's own
process is in its container `[C10]`, and lzrprf looks whether `selftest` held on this Mac as it
is now `[C11]`. Without both, no page is shown. lzrprf also compares its own SHA-256 with the
line `lzrprf` of the installed app's `release` file, when that file has one (apps before
release 12 have none); when they differ it says so and does not start: that window has one
button, Quit (`sub paired`). And when the mark names checks the test could not try on this Mac,
the window names them and asks, and nothing is shown before your yes to exactly those
(`sub proven`).

One visit, in order (`sub visit`):

1. You type an address into the bar and press Return. The window tells lzrprf.
2. lzrprf checks that it is an https address of a host by its name (`sub address`), and writes
   "you typed ADDRESS" into the log `[C5]` (`sub record`): into the memory of the process behind
   the window, and through to the disk as well when you chose to keep a log (see "What is kept").
3. It looks the host up, in a process of its own that is given 10 seconds, and takes at most
   8 addresses (`sub find`).
4. If the host leads into your own network, it asks you, for this one request `[C8]`.
5. It writes down the numeric addresses, connects to one of them itself `[C6]`, and lets `curl`
   do the https over that one connection, in the fetch container (`sub fetch`). A fetch is
   given 30 seconds, looked at once a second, so a request that runs over ends at most about a
   second later; an answer may be 6 MB, and 64 KB at most are carried to the site. Neither
   bound is passed: what comes beyond it is not passed on, and the request fails.
6. It writes down how it ended and which address answered.
7. Only now, with the connection closed, the closed application is started in a page container
   `[C1]` with the address in one variable and nothing else, and handed the answer once macOS
   itself says the process is contained `[C3]` (`sub laid_out`).
8. The application writes a list of what to draw. lzrprf checks every line `[C9]`
   (`sub checked`) and gives the window only lines of four kinds: a paragraph begins, text, a
   line ends, a grey box where a picture would stand. The window draws them.

## The conditions

| mark | the condition | where in `lzrprf` | how `selftest` attacks it |
| --- | --- | --- | --- |
| `[C1]` | The application is started in one place only, and only inside the page container. | `sub laid_out`, through `sub contain` | Reads the text: the program is started on one line. A copy that starts it uncontained is stopped by `[C3]`. |
| `[C2]` | At every start lzrprf tries, inside that same container, what the container must refuse. Nothing starts unless all of it was refused and the same tries worked outside. | `sub holds` | A copy whose container refuses nothing: nothing is started. |
| `[C3]` | No process is handed a byte of what was fetched, nor the connection to a site, before macOS itself says that this process is contained. Before that, of what you asked for each knows the address alone: the application in one variable, `curl` among its fixed switches. | `sub inside`, asked in `sub laid_out` and `sub fetch` | Copies without `[C1]` and `[C2]`: the system says "not contained", and the answer, or the connection, is withheld. |
| `[C4]` | A request is made only for an address from the window's bar, or for one of two fixed addresses after you said yes. | `sub behind`, `sub fixed` | The test site's own record: each address once, and nothing else. Reads the text: a request has three roads and no fourth. |
| `[C5]` | Nothing is looked up or fetched before its line is in the log: in the memory of the process behind the window, and on the disk too when you chose to keep a log. No answer is shown whose line could not be recorded. | `sub visit`, `sub fixed`, `sub record` | A kept log that cannot be written: nothing is fetched. For every request the site received in a run that keeps a log, full or hosts only, the line was on the disk first. In a run that keeps nothing, the Log button shows the lines afterwards; that each was in memory before its request is read in `sub record`, not attacked: no test looks into that memory while a request is open. That the lookup comes after the line is read in `sub visit`, not attacked: the test's site is on this computer. |
| `[C6]` | One place connects to a site, and it connects to a numeric address that was checked and written down. | `sub reach` | Reads the text: two `connect` lines, this one and a try against lzrprf's own listener on this computer. A listener the hostile application knows hears from it only through lzrprf's hands. |
| `[C7]` | What a site is sent is made from the address alone: the same bytes from every computer, nothing kept from an earlier request. The same bytes are the request inside the encryption (HTTP); how TLS, TCP and IP are spoken around it is the system's `curl` and network, and can differ from one computer to another. | `sub request`, `sub fetch` | Compares `lzrprf request` with the bytes the test site received. The site sets a cookie; it never comes back. |
| `[C8]` | A host inside your own network is fetched only after your yes to exactly that, once. | `sub own_network` | A no: nothing is fetched, and the no is in the log. |
| `[C9]` | Every line the application writes is checked, and a list with anything but the four kinds of line is not drawn at all. | `sub checked` | Hostile lists (a script, lzrprf's own words to the window, too large, not text): none is drawn. |
| `[C10]` | The window's process has no network of its own, writes no file, starts no program, opens nothing through the system, commands no other program, sends no signal to another process, and reads nothing under `/Users` or on another disk but your settings, fonts, keyboard layouts and input methods. macOS is asked before anything is shown whether all of that but the reading is refused. It still reaches the system's services, the clipboard among them. | `$WINDOW_CONTAINER`, `sub inside`, `sub behind` | Runs its own tries inside the window's process, and asks macOS about that process. A copy with one refusal taken out: no page is shown. |
| `[C11]` | Nothing is shown before `selftest` held on this build of macOS with this `lzrprf` and the `selftest` beside it, in its last run there. A check the test could not try there is named in its mark, and then nothing is shown before you said yes to starting without exactly those checks. | `sub proven`, `sub mark` | No mark, a mark from another build of macOS, a mark of another `lzrprf`, a mark made by another `selftest`, a mark that names no `selftest`: each time you are asked to test, and after a no nothing is shown, looked up or fetched. A mark that names a check that could not be tried, with no yes or with a yes to other checks: the window names the check and asks, and after Quit nothing is shown, looked up or fetched. A copy that counts such a mark without a yes: its line says it fetched. |
| `[C12]` | Nothing of what you fetched stays on the disk unless you chose a kept log; a kept log holds hosts only unless you chose full addresses. It is only added to, apart from clearing by your button and the days you chose: in a kept log each of the two says so in its first line, and with nothing kept, clearing removes the log whole and the window's lines say so. | `sub record`, `sub keeping`, `sub choose_keeping`, `sub changed`, `sub clear_log`, `sub expire_log` | The window's buttons, pressed in every order the test knows, never leave more kept than before: more is taken from `lzrprf keep` only. A change is a line of the log. With nothing kept, no file holds a path or a query that was typed. Hosts only: no file holds them either. Tens of thousands of lines and none dropped; cleared only after two questions; not while a request is open; old lines taken out at the start of a window, said in the first line. A setting that is no setting keeps nothing. |

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
- For each process, macOS is asked by the number of the process about eight things
  (`$WITNESS`, `sub inside`). For a page or a fetch process four of them must be refused: using
  the network, creating a file, starting a second process, reaching a system service. The answer
  or the connection is handed over only after those four refusals `[C3]`. For the window's
  process seven must be refused: the first three, and opening something through the system,
  commanding another program, writing your settings, sending a signal. What the window may
  read is not among the questions: `selftest` tries that from the real window. Nothing is
  asked of the process itself.
- What the icon runs is a short plain-text launcher. It starts one thing, `lzrprf run`, through
  `/usr/bin/env -i`, so that no variable of whoever started it reaches lzrprf. The installer
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

Before any of them, the line is in the log `[C5]`. The connection is made by lzrprf, to a numeric
address it wrote down `[C6]`. `curl` has no network of its own: it gets one socket file, so it
can reach that one connection and nothing else. A redirect is not followed. Other hosts a page
names (pictures, scripts, trackers) are never asked. It is the application that reads the page,
so it is the application that names them: lzrprf takes at most 200 names from it, shows you how
many and the first four, and asks none. A hostile application can name fewer or other hosts
than the page does. That changes a sentence in the window and no request.
The page cannot make a request by being clicked either: a link is drawn as a colour and does
nothing.

The name lookup is a request too, to your resolver, for the host you typed, after the log line.

One more thing fetches, and it is not lzrprf. After you pressed "Install it" for a newer release,
lzrprf writes a short file that Terminal runs (`sub installer_file`), and that file fetches the
installer with the system's `curl`, from the two places the release names. `curl` is started
with `-q` there, so that no settings file of yours changes how it checks a site. Those fetches do not
go through `sub fetch`. They happen after your click and your Return in Terminal, in a window where you see them, and lzrprf
writes into the log that you asked for them, and from where, before the file exists
(`sub newer`). See "A newer release".

Conditions: macOS enforces the containers (tested on your Mac, `[C2]`, `[C3]`, `[C11]`); the
`lzrprf` you run is the one in this repository (compare its SHA-256); and the keys pressed in the
bar are yours. A program on your Mac that you allowed to control your computer can type there
like you can.

### It can read a few facts about your computer, and has no way to deliver them

A fingerprint needs two things: reading what tells your computer apart, and delivering it. The
application can do the first in part. The second is what the container refuses.

- Reading. The page container lets it read the system's values (`sysctl`) under `hw.` and
  `machdep.cpu.` (the model of the computer, its processor, its memory), a short list under
  `kern.` (the version of macOS and of its kernel, a few fixed limits, whether it runs in a
  virtual machine, whether the system is shutting down), three about its own
  process (`sysctl.proc_`) and one under `vm.`, exactly as `$CONTAINER` names them; and the
  time, and the folder it is installed in. Not the computer's name, your account's variables,
  your files, the fonts you installed, your time zone, your screen, or other processes.
- Delivering. It has no way out. No network, no file, no shared memory by the ways the test
  tries, no second process, no window. The one thing that leaves it is the list of lines, and `sub checked` lets through
  only lines that cannot carry an address, a picture or a command `[C9]`. The window that draws
  them has no network `[C10]`.
- lzrprf does not make one either. What a site is sent is `sub request`: the address, its host
  and two fixed lines `[C7]`. No cookie, no name of a browser, no language, no page you came
  from, no number of this computer or of this copy. Each request is a new `curl` that can write
  nothing, so nothing is kept for the next one.

- One thing is the application's choice and reaches its maker, and only after your click:
  whether it fails on a page at all. When it does, you are asked whether to send a report. A
  report says `page` for every failure of the application's own doing, and an application that
  ended by itself before macOS was asked about it counts as `page` too, so the application
  cannot choose among words (`sub fault`). A report you send tells the maker that some page
  failed, on a Mac with your build of macOS, at that moment. If you do not want that told,
  press "Don't send". See "When a page cannot be shown".

What a site does see: your internet address, the time, the address you typed, and how the
system's `curl` opens its encryption. `selftest` compares those opening bytes between the
requests of one run on your Mac. When they are the same the line says `held`; when they differ,
or the test site could not read them, it says `UNTESTED`, not `FAILED`, the mark of that run
names the check, and LZRBRWSR asks before it starts without it. Nothing here shows that
two Macs, or two builds of the system's `curl`, send the same opening bytes. What the code says
of them is only that the system's own `curl` makes them, with fixed switches (`sub fetch`).

Condition, and the one way around it: **you**. A page can show a text that asks you to type or
paste an address, and that address can carry whatever the application knows. lzrprf sends what
you type and writes it in the log first. It cannot judge an address for you.

### The application can keep nothing between pages and send nothing

What it cannot do is keep a record of where you go, or send one. What any request shows is
still seen: each site, your resolver and your network see your internet address and the time,
and a site can tie your requests together by that address, or by links it made unique to you.

Who could keep a record of where you go?

- The application: it is started fresh for each answer and sees that one page and its address.
  It can keep nothing between pages (no file, no shared memory by the ways the test tries) and
  send nothing.
- lzrprf: unless you chose otherwise, it keeps nothing after the window closes: the lines are
  in the memory of the process behind the window, and gone with it. A log you chose to keep is
  on your disk, readable by your account alone, hosts only unless you chose full addresses (see
  "What is kept"). Nothing in `lzrprf` sends the log or any part of it `[C12]`: the only place
  that connects is `sub reach` `[C6]`.
- The maker of the application: receives nothing about where you go. The two fixed addresses
  are fetched only after your yes `[C4]`. The release check goes to a file in this public
  repository on GitHub, not to a server of the maker, with the same bytes from everyone. The
  maker's server is asked for something by an installed copy in two cases only, both after
  your own click: a report you chose to send (three values, none of them an address you
  visited), and the installer of a newer release you chose to install. Installing asks it too:
  the three lines under "The installer" fetch the installer from it, and the installer fetches
  the download. The site is the maker's own server. While that server is down the maker can
  point the name at a copy held by a hosting company (Vercel), which then sees those requests
  in its place; the header `X-Served-By` of every answer says which one answered, `box` or
  `copy`. A report goes to `origin.lzrbrwsr.com`, which names the maker's own server only.
- GitHub: once you said yes to looking for newer releases, it is asked for the file `latest`
  at each start. It sees your internet address and the time you started the application, and
  nothing else from lzrprf.
- Other sites: a page's trackers are never fetched, so they get no request at all. The sites
  you do type get no cookie back and no page you came from, so they cannot link one visit to
  the next by anything lzrprf adds.

What remains: each site sees your internet address and the time, and can link your visits by
that address or by an address unique to you that you type in; your resolver sees the names you look
up. Hiding those is the job of a network you choose, not of a container.

### It cannot reach other applications, and can load the computer only within its limits

Interfering needs a way to reach them, or a way to starve them.

- Reach. The page and fetch containers refuse: signalling another process, every system service
  (so no window of another program, no key, no clipboard, no event to another program),
  starting a program or a second process, and writing any file. `selftest` tries each.
- Shared objects. macOS does not refuse the creation of old "System V" memory, flags and queues
  inside a container, and the computer has only a few of them. `selftest` found that on
  2026-11-18; `$CONTAINER` now refuses the three calls `shmget`, `semget` and `msgget` by name,
  and the test makes each. Memory and flags with a name (`shm_open`, `sem_open`) are refused by
  the container's `deny default`, which no rule opens for them, and the test makes those too.
  That is a test of these five ways, not a proof that no other way to share exists.
- Starving. A page container gets at most 30 seconds of processor time, counted over all
  processor cores together (`ulimit -t` in `$PAGE_LIMITS`), and is ended after 30 seconds
  whatever it does. It may create no file and no memory dump. It may write at most 6 MB,
  200000 lines and 2000 boxes; more is not drawn.
- Memory. The same `/bin/sh` (`$PAGE_LIMITS`) sets, before the container starts, the system's
  own limit on address space (`ulimit -v`) to what that shell itself holds (`ps -o vsz=`) plus
  2 GiB. What the application holds at its own start is not measured, so its real room is
  about 2 GiB, a little more or less. macOS enforces the limit: a request beyond it is refused
  by the system. If a limit cannot be set, nothing is started. `selftest` asks for 3 GiB in
  the page container, where it must be refused, and outside every container, where it must be
  given. The limit counts address space, not memory in use: an application that reserves much
  more than it uses (a large engine does) would need a larger `$PAGE_ROOM`, and with too small
  a one it shows no page.
  The system's `curl` in the fetch container is started under the same limit
  (`$FETCH_LIMITS`), and the test asks for the 3 GiB there too.
  The window's process (the system's `osascript`) has no such cap.

Limit, said plainly: within those limits a hostile application can still load this computer,
each time you ask for a page: about 2 GiB of address space, as the system counts it, and every
processor core until its 30 seconds of processor time are used. Then it is ended. Memory the
kernel holds for a process (what is in its pipes, and in messages it sends to itself) is not
counted in that limit; it is bounded only by the 30 seconds, after which the process and what
was held for it are gone. No attack of the test tries that. And a flaw in macOS itself, in its
kernel or its sandbox, is outside what lzrprf can refuse.

### It cannot read or change your files

The page and fetch containers may read the system's own folders and the application's own
folder, and write nothing. `selftest` puts a secret in your home folder and tries to read it,
to learn that it exists, to list the folder, and to reach it by its other path through the data
volume. It tries to read and change the log, the setting of what is kept (`~/.lzrprf/keep`)
and `lzrprf` itself, and to put a setting of its own in its place. Each is refused.

### Is its safety mathematically proven?

No. See "What "proof" means here". It rests on parts nobody has proven: the macOS kernel and
its sandbox, the system's `perl`, `curl` and `osascript`. What this repository gives instead is
short enough to read, attacked on your own Mac, and attacked again whenever macOS changes.

## What is kept

The principle: every outgoing network request must be observable by you, but no browsing
activity should be permanently retained without your explicit consent.

So every line of the log is kept first in the memory of the process behind the window
(`sub record`), and the Log button shows it. What stays on this computer after the window
closes is your choice, held in the plain file `~/.lzrprf/keep` (`sub keeping`) `[C12]`:

| mode | what the Log button shows | what stays on this computer |
| --- | --- | --- |
| `nothing`, when nobody chose | this window's lines | nothing: no file holds an address you typed |
| `hosts` | this window's full lines, and under them the log on this computer | each line with every address cut to `https://host`: the time, the run, the host, the numeric address lzrprf connected to, and how it ended; no path and no query (`sub shortened`) |
| `all` | the same | every line in full, as before there was a choice |

More is chosen in one place only, a terminal: `perl lzrprf keep hosts 30` keeps a log of hosts
for 30 days, `perl lzrprf keep all 30` keeps full addresses and says that they can hold search
words, tokens and invitation links (`sub keep_command`). No button of the window makes lzrprf
keep more.

The window can keep less: Log, then "Keep less", then "Keep nothing", or from full addresses
"Keep a log" and "Hosts only" (`sub choose_keeping`, where the new mode is never more than the
one that holds at that moment: the setting is read again after your last answer, and the days
stay as they are). The first button of each question keeps less or changes nothing, and a
question nobody answers counts as that one.

Why the two are not the same door: the window's process is the one that tells lzrprf which
button was pressed. If text it draws ever took that process over, it could do by itself what
the buttons can do. So the buttons can keep less and clear, and nothing else.

A change of what is kept is itself a line (`sub changed`), for example
`what is kept was changed in the window: full addresses, 30 days -> hosts only, 30 days`. A
change made in the window is among that window's lines. A change made either way is a line of
the log on this computer when there is one or one is kept from then on; where there is no log
and none is kept, `lzrprf keep` leaves no line. So a log says where it stops and where its lines became shorter or longer, and whether
a button or the command did it. The Log button and every start of a window say in one sentence
which mode is on (`sub kept_words`).

Keeping less holds at once: a request that is open while you choose writes no later line at
more than what is kept at that moment (`sub record` reads the setting again, under the lock the
change holds). Keeping more holds from the next request on.

- A kept log keeps a line 30 days unless you chose another number; 0 keeps it until you clear
  it. At the start of a window, older lines are taken out the same way clearing replaces the
  log, and the new first line says how many and why (`sub expire_log`). When a request of
  another window is open at that moment, it is tried again before each request of this window
  and each press of Log, until it is done.
- In a kept mode `[C5]` holds as before: the line is on the disk before the name is looked up.
  In `nothing` it is in memory before the name is looked up.
- Keeping less deletes and shortens nothing. Switching to `nothing` does not remove a log
  written earlier, and `hosts` does not shorten its older lines: they stay as they were, full
  ones among them, and lzrprf says how many there are. A log that is there, one an
  older release wrote among them, stays until you press "Clear the log", which is one click
  away under the Log button whenever there is a log, and asks once more (`sub clear_log`).
- Only lzrprf writes the setting, outside every container: `lzrprf keep` for you, and the
  process behind the window after your answers there, which only ever writes less
  (`sub keep_as`). One of them writes at a time (`sub keep_lock`). `lzrprf keep` changes
  nothing when the line that says so cannot be written to the log, unless the change is to
  keep nothing, which is never refused. Should putting the old setting back fail as well, the
  command says that the change stands. Anything else in that
  place counts as `nothing`: a link, a file with a second name or of another owner, something
  that is not a plain file, or words or a number of days (above 3650) it does not take.
  `selftest` tries each of these but the other owner, which only an administrator can make, and
  has the hostile application try to change the setting from inside each container.
- When lzrprf creates or replaces the log, or first adds a line to one that was there, it marks
  that file for Time Machine to leave out of its backups (`sub excluded`). A mark that cannot be set stops no request, and the Log button
  says so. The folder is not marked.

The limits, said plainly:

- With `nothing` there is nothing to look at after the window is closed, for you either.
- With `nothing`, lzrprf writes nothing of what was fetched to the disk on purpose. Memory can
  still reach the system's swap, a crash report of that process, or a snapshot of the disk:
  those are macOS's, outside lzrprf, and lzrprf cannot prevent them.
- Besides the log, `~/.lzrprf` holds files lzrprf needs to work, none with an address you typed:
  `keep` (what is kept), `look` (your answer about newer releases), `proven` (the mark of
  `[C11]`), `untested` (your yes to starting without the checks a test could not try, as the
  line of the mark you said it to), `selftest.txt` (the last test's report), `selftest.lock`, while an installer runs
  its lock (the link `.installing`), and while a window is
  open the lock files `lock`, `keep.lock` and `busy`, the folder `tries.NUMBER` of the tries at
  the start, and the socket `way.NUMBER` of a request;
  after "Install it", the file `install.command`, which holds the installer's fixed address.
- Hosts and times alone still show habits: which sites, when, and how often. That is why even
  `hosts` needs your yes.
- That Time Machine honours the mark is Apple's behaviour, and it is not tested here. Another
  backup program may not read it.
- A window process that text took over could press the buttons that keep less and the two that
  clear the log, as it could press any button (see "What it does not prove"). It could remove
  the record on this computer. It could not make lzrprf keep more.

## Which choices cost you, and where they are made

Each choice has one direction that costs you something. The window's process draws text the
application chose, so it is the part to trust least (see "What it does not prove"): if such
text ever took it over, it could say that a button was pressed. This is what that is worth,
choice by choice.

| choice | the direction that costs you | where it is made | what a taken-over window process could do |
| --- | --- | --- | --- |
| what is kept | more kept: a log, full addresses, more days | a terminal only (`sub keep_command`) | keep less, and clear the log (`sub choose_keeping`, `sub clear_log`) |
| an address | fetching it: the site sees your internet address and the address you typed | the bar of the window (`sub visit`) | say "go ADDRESS" as if you had typed it, as often as it likes. Each one is a line before it is fetched `[C5]` |
| a host inside your own network | yes: this computer, your router or another device of yours is asked, this once | the window, each time such an address is typed (`sub own_network`) | say such an address and answer "Yes, this once" itself. The address and the yes are lines before anything is fetched |
| looking for a newer release | yes: GitHub sees your internet address at each start | the window, when lzrprf asks: at a first start, and again when a release names another address or `~/.lzrprf/look` was deleted (`sub newer`) | answer yes while that question is open. It cannot open the question. The yes is a line of the log before it is kept, and each look is a line before it is made |
| installing a newer release | "Install it", then two Returns of your own | the window, then Terminal (`sub installer_file`) | press "Install it" when a newer release is published, which brings a file up in Terminal. That file fetches nothing before your first Return, and runs nothing it fetched before your second |
| a report after a failure | "Send": the maker's server sees your internet address and three values | the window, when a page was not shown (`sub fault`) | say that a page it was handed could not be drawn, once for each page (`sub behind`), and press "Send" to the question that follows: the three values, written in the log first |

Only the first row can be closed entirely, and it is: nothing in the window keeps more. In the
other rows the window is where you answer, so a taken-over window process could answer too.
Installing ends outside the window: what "Install it" starts waits in Terminal for a Return,
and the window's process commands no other program `[C10]`. What holds in the other rows is `[C5]`: nothing leaves this computer before its line exists, and with
nothing kept that line is in the memory of lzrprf's process, which the window's process
cannot write.

## A newer release

lzrprf looks for a newer release only if you said yes, once, in the window (`sub newer`). The
yes is kept together with the address it was given for (`~/.lzrprf/look`), so a release that
names another address has no yes and asks again. A no is kept for every address. The answer is
a line of the log before it is kept, like a change of what is kept: `you allowed lzrprf to look
for a newer release at each start: ADDRESS`, or that none is looked for. When that line cannot
be written, or the answer cannot be kept, it counts for nothing: no look is made, and you are
asked again at the next start. To take a yes back, delete `~/.lzrprf/look`: you are asked again.

- The look is one request for one fixed address: the file `latest` in this repository, which
  holds one number. It is sent like any address you type, the same bytes from every computer
  `[C7]`, so it does not say who you are or which release you run. It is in the log like every
  other request `[C5]`.
- The address is on GitHub, not on a server of the application's maker. The maker's server
  sees no request at all. GitHub sees your internet address and the time, at each start.
- When the number is larger than yours, the window says so and offers the installer. lzrprf
  replaces nothing itself, not the application and not itself. After "Install it" it writes
  into the log what Terminal is about to fetch, and then a short file (`sub installer_file`)
  that runs in Terminal, in front of you.
- That file runs as an ordinary program of your account, outside every container. Before it
  fetches anything it starts itself again through `env -i` with three variables only (your
  home folder, the kind of terminal, the system's own `PATH`), so no other variable of your
  shell reaches its `curl` or the installer. It leaves two things behind: itself (`~/.lzrprf/install.command`,
  replaced the next time) and a temporary folder that holds the installer it fetched.
- It first says where the installer comes from and waits for your Return. Before that it
  fetches nothing, so a press of "Install it" alone reaches no site.
- Then it fetches the installer from two places, when the release names a second one (the line
  `same`; the release on record here does): `install.sh` in this repository, and the site. It
  stops, with nothing changed, unless the two copies are the same byte for byte
  (`/usr/bin/cmp -s install.sh second`). Then it says where the file is, so that you can read
  it, shows its SHA-256, and runs it only after you press Return again. Nothing is piped into a shell.
  This is the one moment on this road when the maker's site is asked for anything: it sees your
  internet address then, as GitHub does.
- The installer then asks its own questions, refuses to put an older release over a newer one,
  and says so and asks when the release would replace `lzrprf` itself. It takes no test setting
  from a variable of your shell unless every file comes from this computer (see "The
  installer"), so a variable cannot point this road elsewhere.

Where the addresses come from: a plain file, `release`, beside the application
(`LZRBRWSR.app/Contents/Resources/release`), read by `sub beside`. It may hold six kinds of
line and nothing else counts: `release` (a number), `newest` (where the number is published),
`installer` and `same` (the two places of the installer), `report` (see the next section) and
`lzrprf` (the SHA-256 of the lzrprf the release installs; an lzrprf of release 12 or later
compares it with itself at every start, and a `release` file without the line is not compared).
Each address must pass `sub address`, the same check as an address you type. The two installer
addresses are written into the Terminal file between quotes, so `sub installer_file` writes no
file at all when one of them holds a character that could end a quote; `selftest` tries exactly
that. A `same` line that is there but is no address does not turn the comparison off: no file is
written. The installer compares the `release` file byte for byte with the text written out in
the installer, and `release.txt` holds its SHA-256, so what your copy names is what is on record
here:

    release 13
    newest https://raw.githubusercontent.com/lzrbrwsr/lzrprf/main/latest
    installer https://raw.githubusercontent.com/lzrbrwsr/lzrprf/main/install.sh
    same https://lzrbrwsr.com/install.sh
    report https://origin.lzrbrwsr.com/report
    lzrprf b02c2e25749d055a0e1fed0f5cb780786270646d3e9ef6c85315548393cee18b

## When a page cannot be shown

When the application did not give a page, the window says one of seven fixed phrases (`%FAULT`
in `lzrprf`). If the release names an address for reports, you are asked whether to send one,
with two buttons, and shown the whole address first (`sub fault`). A report holds three values:
one of two words, the number of the release, the build of macOS. Not the address you typed, and
nothing of the page. It is not anonymous to the network: like any request, it shows the
receiving server your internet address and the time. It is sent only after "Send", the way a typed address is `[C7]`, and
written in the log first `[C5]`. The first button is "Don't send", and a question nobody
answers counts as that one.

Seven phrases, and only two words. Five of the seven are the application's own doing: it ended
before it was given the page, it was late, it wrote too much, it wrote something that is no
page, or it wrote what the window could not draw. An application that could choose among five
words could tell its maker a little of what it had just read. So the report says `page` for
all five, and `container` for the two that lzrprf and macOS decide: the container could not be
started, or macOS did not say of a process still running that it was contained
(`sub laid_out`). An application that ends by itself before macOS was asked about it counts as
`page`, so it cannot pick `container` by ending early. One thing stays the application's choice and cannot be taken from it:
whether it fails at all. A report you send therefore tells the maker that some page failed on
your Mac at that moment, and not which.

The release of LZRBRWSR on record here names such an address: the `report` line shown in the
section above. So this is the whole of what can be sent, and to whom:

    GET /report?fault=WORD&release=NUMBER&macos=BUILD      to origin.lzrbrwsr.com

`WORD` is `page` or `container`, `NUMBER` is the release, `BUILD` is the build of macOS, such
as 26B123. The question shows that address in full before anything is sent.

What the maker's server keeps of it cannot be checked from here, and this repository does not
claim it as proven. The maker's word, the same as on the site's privacy page
(https://lzrbrwsr.com/privacy.html): the server sees your internet address and the moment, as
any server does, and keeps neither; it keeps one line with the day and those three values. What
you can check is everything on your side: the bytes (`perl lzrprf request ADDRESS`), the
question, and the line behind the Log button.

Everyone on the same update of macOS has the same build. A rare build, such as a test build,
narrows down who could have sent a report. The question shows the build before you choose.

## What it does not prove

- **What you are told to type.** A hostile application cannot send anything, but it can show a
  text that asks you to type an address that carries a secret. See "It can read a few facts
  about your computer".
- **What you are shown.** The application decides what the page says. It can show a page
  falsely. It cannot change the bar, the words under the bar, or the title: those are lzrprf's,
  and the bar shows the address lzrprf made of what you typed and asked for (`sub address`),
  whether or not an answer came.
- **The window's process.** It draws text the application chose, with macOS's own text drawing.
  This is the weakest point, so it is said in full. If such text could take over that process,
  the process has no network of its own, writes no file, starts nothing, opens nothing through
  the system, commands no other program, sends no signal to another process, and reads nothing under `/Users` or on another disk
  but settings, fonts, keyboard layouts and input methods `[C10]`, by the data volume's name of those
  folders too (`/System/Volumes/Data/Users/...`); `selftest` also tries the file by its number
  on the disk (`/.vol/...`). What it could still do:
  - say to lzrprf what the window says (`sub hear`): "go ADDRESS" as if you had typed it, a
    press of either button of the question that is open ("Send", "Yes, look", "Install it",
    "Clear the log" and the buttons that keep less among them), or a request for the
    log. Each of these that fetches is in the log before it has an effect outside your Mac,
    and "Install it" ends in Terminal, where nothing is fetched before a Return of your own and
    the installer runs only after a second one. A
    press cannot make lzrprf keep more: the buttons that change what is kept only keep less
    (`sub choose_keeping`), and the change is a line of the log (`sub changed`). Two presses
    clear the log on this computer: a kept log then says so in its first line, and with
    nothing kept no log is left and only that window's lines say so. lzrprf has no way of its
    own to tell such a line from your Return or your click: the log shows it as typed or
    pressed;
  - say that a page it was handed could not be drawn. That opens the question about a report,
    once for each page (`sub behind`), and "Send" is one of the presses above;
  - reach the system's other services (Mach services), the clipboard among them. It could read
    what you copied. It could send that nowhere but inside an address, through lzrprf, logged
    first;
  - make shared memory and open devices: the window's container (`allow default`) does not
    deny these. A signal to another process it does deny (`(deny signal)`, with a signal to
    itself allowed): macOS is asked about that at every start, and from the real window
    `selftest` asks to send one to its own process (signal 0, which delivers nothing) and
    sees it refused;
  - read the four folders it is allowed (your settings, fonts, keyboard layouts and input
    methods), and what any program of yours can read outside `/Users` and other disks;
  - read your temporary folder (`getconf DARWIN_USER_TEMP_DIR`, under `/var/folders`, outside
    the home folder). It is not denied, because `osascript` keeps its own caches there;
    `selftest` reads a file of its own there from the real window, and that line says it was
    read.

  lzrprf's own lines for the window read no file of the closed download: the icon of the
  running window in the Dock is drawn by the lines of `icon` in `window_text`, and no picture
  is taken from the app. What lzrprf hands the window from the application is the list of
  lines that `sub checked` let through, and nothing else. Two things stay as they are for
  every app: a window that was taken over could read the app's files as it can read anything
  outside `/Users`; and the Finder, and the Dock while the app is not running, show the app's
  own icon file (`Contents/Resources/lzrbrwsr.icns`), read by macOS as soon as the app is on
  the disk, with no container of lzrprf's around the Finder.
- **What the site learns.** Your internet address, the time, the address you typed, and how the
  system's `curl` speaks TLS. The name lookup is seen by your resolver.
- **The parts lzrprf stands on.** The macOS kernel and its sandbox, and the system's `perl`,
  `sh`, `env`, `ps`, `curl` with its TLS library and list of authorities, `route`, `sysctl`,
  `open`, `xattr` and `osascript`. A flaw in one of these is a flaw here. A flaw in `curl` can reach one place
  only: the connection lzrprf made for the address you typed (`selftest` puts the hostile
  application in curl's place).
- **`sandbox-exec` is marked deprecated.** The command and the profile language are; the
  mechanism in the kernel is the one macOS confines its own processes with. So lzrprf does not
  trust it to keep working: `[C11]`, `[C2]` and `[C3]` make it prove itself on every build of
  macOS, at every start and for every process, and nothing is shown when it does not hold.
  The day a build of macOS comes without the command, or reads a profile another way: the
  mark of `[C11]` is for one build of macOS, one `lzrprf` and one `selftest` (`sub proven`), so after a system
  update no page is shown until `selftest` held again on the new build. Where a profile no
  longer holds, the window says so, names `selftest` to see what was not refused, and the
  program is not started. Where the command itself is gone, no window opens: lzrprf stops with
  one sentence, which you read when you start it from a terminal; started from Applications,
  nothing appears. There is no second road that runs it without the container. LZRBRWSR then does not work on that build until a
  release whose container holds there. What that container would be is not built.
- **Your account.** Any other program you run can change `~/.lzrprf/lzrprf` or the launcher.
  Compare them with this repository.
- **The first download.** The installer and the download stand in two places that would both
  have to be changed: the site and this repository. Both places are in the hands of one maker,
  and releases are not signed with a key yet. "The installer" says exactly what the two places
  are worth and what they are not.
- **A tunnel that carries everything.** A network reached by the default route itself, such as
  a VPN all traffic goes through, looks like the internet to lzrprf: a host in there with a
  public address is fetched without the question about your own network.
- **Load.** Within about 2 GiB of address space and 30 seconds of processor time, each page
  can still load this computer. The window's process has no cap on memory. A flaw in macOS
  itself is outside what lzrprf can refuse. See "It cannot reach other applications".
- **What is kept, and where else it can go.** The lines of a window that keeps nothing are in
  memory, which the system can write to its swap or into a crash report. A log of hosts still
  shows habits. Time Machine's honouring of the mark is Apple's. See "What is kept".
- **Time.** How long a page container runs is the application's choice, up to 30 seconds. The
  request is over before the application sees the answer, so it cannot shape a request by it.
- **A question left open.** A question in the window that is still open after 10 minutes counts
  as answered with its first button. A window closed while it asks ends lzrprf: nothing is
  fetched or sent. The first button never fetches or sends anything, never
  replaces the application or the log, and never keeps more. Two such answers are written
  down: a "No" to looking for newer releases, like a no you pressed (delete `~/.lzrprf/look` to
  be asked again), and, after you pressed "Keep less", "Keep nothing", or after "Keep a log"
  from full addresses, "Hosts only".
- **Lines the test could not try.** An `UNTESTED` line does not stop an install. There are two
  such lines in `selftest`, and both depend on the network of the moment: whether `curl` opens
  its encryption with the same bytes each time, and how this Mac would send to an address on
  the internet. Neither is about what holds the program, and a Mac that is offline would
  otherwise never be allowed to show a page. So a run whose other lines held still writes the
  mark, and the mark then names each check that could not be tried, with the reason. The
  installer prints those lines again when the test ends. LZRBRWSR does not start on such a
  mark before its window has named the checks and you pressed "Start" (`sub proven`): what
  could not be tried is not shown to hold on your Mac, and that is yours to accept or not.
  Your yes is kept in `~/.lzrprf/untested` as that whole line of the mark. When the build of
  macOS, `lzrprf`, `selftest`, the checks untried or their reasons change, the line is
  another one, and you are asked again. The window shows all of the line's text: lzrprf
  counts 600 characters of it at most, and a `selftest` with more to name cuts its list and
  says so in it. That file is a plain file of your account, like the mark: see the next point.
- **The mark.** The mark of `[C11]` is a record in a plain file of your account
  (`~/.lzrprf/proven`), which any program running as you could write, as it could change
  `lzrprf` itself. It protects against forgetting to test after an update, not against a
  program already running as you. The mark always names the build of macOS, and `lzrprf` and
  the `selftest` that ran each by its SHA-256, and lzrprf compares it with the `selftest`
  beside it (`sub mark`). A mark without the `selftest`'s sum counts as no mark. The yes in
  `~/.lzrprf/untested` is the same kind of record, with the same limit.
- **Counting lines.** Where the table says "reads the text", `selftest` counts lines of
  `lzrprf`. That catches a careless change. It is no defence against a deliberate one, which
  would change the test too. What ties the file you run to the file you read is its SHA-256.
- **Who takes the connection.** lzrprf hands the one connection to the first process that
  opens its socket file, after macOS said that `curl` is contained (`sub fetch`). It does not
  ask which process opened it. The file is in `~/.lzrprf`, which only your account can enter,
  and the fetch container is given that one name. Another program of your account could take
  a connection in that moment; see "Your account".
- **A page process left behind.** If lzrprf is ended by force while a page is laid out, the
  page process is not ended with it. It stays in its container, with no network and no file,
  until it ends, uses up its processor time, or you log out.
- **An authority added to this Mac.** `curl` trusts the certificate authorities of macOS. One
  that you, an administrator or another program added is trusted like the rest, and whoever
  holds its key and stands in your network reads and changes what is fetched.
- **Older installers.** The refusal to put an older release over a newer one is in the
  installer since release 5. An older installer, or a download unpacked by hand, does not
  refuse.
- **`latest` held back.** Whoever holds this repository can leave `latest` at an old number.
  Then nobody is offered a newer release. Nothing is installed by that, and the file's history
  is public.
- **Where it was run.** By the maker on one Mac: macOS 27.2, build 26B123, Apple silicon.
  That is why `[C11]` makes your Mac run the test itself before a page is shown.
- **Other ways in.** It holds for a program started through `lzrprf run`. `lzrprf try`,
  `lzrprf behind` and `lzrprf lookup` are entries of the same code: `try` is `run` with its
  state in a test folder and a test site in place of the name lookup, for `selftest`, which
  the installer runs; `behind` and `lookup` are what `run` starts for itself. The launcher
  uses none of them.

## Use

    perl lzrprf run /path/to/program     open the window, with the program contained behind it
    perl lzrprf log                      what the log on this computer holds, and what is kept
    perl lzrprf keep                     what is kept after a window closes, in words
    perl lzrprf keep MODE [DAYS]         choose it: nothing, hosts or all; DAYS 0 keeps until you clear it. The one place where more is chosen
    perl lzrprf address TEXT             what would be fetched if TEXT were typed into the bar
    perl lzrprf request TEXT             the exact bytes a site is sent for TEXT
    perl lzrprf public NUMBER            whether a numeric address is public, and how this computer sends to it
    perl lzrprf mark                     this build of macOS, this lzrprf and the selftest beside it, as one line
    perl selftest                        attack it on this computer; about half a minute, no window

Three lines of the log, for one request (time, number of the run, what happened), as a log of
full addresses holds them; a log of hosts only holds `https://example.com` in each:

    2026-11-18T09:14:03Z  4711  you typed https://example.com/
    2026-11-18T09:14:03Z  4711  https://example.com/ -> lzrprf connects to the first that answers of: 93.184.215.14
    2026-11-18T09:14:04Z  4711  https://example.com/ answered: 931 bytes from 93.184.215.14

The Log button of the window shows the lines of that window, from memory, and the log on this
computer when there is one, with the button that clears it and, while a log is kept, the
questions that keep less (`sub log_shown`).

`selftest` prints five kinds of line under eleven numbered headings, then a count and a
verdict. `now`: what the test is doing at this moment, printed while it runs; the installer
shows these as its steps. `works`: an attack tried outside every container, where it must
succeed. `held`: an attack that failed inside, or a promise checked against what the test site
itself received. `UNTESTED`: something this Mac gave no way to try, with the reason; the mark
the run writes names each. `FAILED`:
an attack that succeeded, or a promise that did not hold. A line that begins `selftest:` says
why the test could not run at all. The hostile application is the text `$hostile` in
`selftest`: read it, add an attack of your own, run it again. `selftest-output.txt` is the
record of the run of this release's `lzrprf` on the maker's Mac, written when the release was
made; its last line names the build of macOS and the SHA-256 of the `lzrprf` and `selftest`
that were run, and a record that names another sum than `release.txt` is not of this release.
It shows what a run looks like; the proof for your computer is your own run.

## The installer

`install.sh` in this repository is the installer that https://lzrbrwsr.com/install.sh serves, and
`release.txt` holds the SHA-256 of it, of the download, and of each file in the download. The
installer runs from a file and never from a pipe, so that what runs is something you can read
and check first:

    curl -q -fsSLO https://lzrbrwsr.com/install.sh &&
    curl -q -fsSL https://raw.githubusercontent.com/lzrbrwsr/lzrprf/main/install.sh | cmp - install.sh &&
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

### Two places, and exactly what they are worth

Everything that is installed stands in two places: the maker's site, and this repository at
GitHub. They are two separate systems, and this one keeps every change with its date. Three
comparisons use that. Each is a line you can read:

| what is compared | who compares | the line |
| --- | --- | --- |
| the installer, before it runs | your own shell | the second of the three lines above |
| the download | the installer | in `install.sh`: `fetch "$SECOND/$FILE" "$tmp/second"`, then `cmp -s "$tmp/$FILE" "$tmp/second"`; `SECOND` is this repository |
| the installer of a newer release | the file lzrprf writes | `sub installer_file`: two `curl` lines, then `/usr/bin/cmp -s install.sh second`, before the line `read answer` |

What each is worth, and no more:

- **The installer is the root.** It carries the SHA-256 of the download, of `lzrprf` and of
  `selftest` (the lines `SHA256=`, `LZRPRF_SHA256=` and `SELFTEST_SHA256=`) and stops on a file
  that does not match (`get` in `install.sh`). So with the true installer, no changed file is
  installed, wherever it was fetched from. That leaves one question: is this the true installer?
  Before a first install, nothing on your Mac knows. The first comparison answers it as far as
  it can be answered without a key: two separate systems serve the same bytes.
- **The second comparison adds a record, not strength.** A changed installer would skip it, and
  against a changed download the checksum already stands. What it adds: the installer stops
  unless the file it is about to install is the file on record here. So every release anyone
  installed is in this repository's history, with its date, for anyone to fetch and take apart.
- **The third closes the road of a newer release**, which the first comparison does not cover,
  because nobody types the three lines then.

So for anyone who pastes the three lines printed here, and on the road of a newer release: to
put a changed program on a computer, the site and the `main` branch of this repository have to
be changed for the same moment, and the second is a public commit.

What the two places do not cover:

- **One maker holds both.** Somebody with the maker's computer or accounts can change both
  places. The change would be in this repository's history for everyone to see; an install in
  that moment would not notice it. A signing key kept away from that computer, with its public
  half in `lzrprf`, would close this. It is not built: nothing here is signed with a key of the
  maker's.
- **What "on record" is worth.** This repository's history is ordinary git at GitHub. Whoever
  holds the account can rewrite it with a forced push, the date of a commit is written by its
  author, and no rule of the repository forbids either today. What stands against a rewrite is
  every copy somebody else fetched before, and GitHub's own record of pushes, which the maker
  does not hold. The download is kept as a plain file in git, about 200 KB.
- **The three lines themselves.** Most people copy them from the site, and a changed site could
  show other lines. They are printed above, and in the first lines of `install.sh`. What you
  paste must be these.
- **https.** Both fetches rest on TLS and on macOS's list of certificate authorities.
- **A release in the making.** For some minutes the two places can differ, and GitHub serves a
  raw file from a cache for up to five minutes. A comparison then stops and nothing is
  installed. Try again later; if it still differs, one place was changed. `main` is what is
  released: lzrprf's own files and the release's files reach it in one push. A branch named
  `next` holds lzrprf's files of a release whose tests passed, from then until that push. In
  the minutes between the site serving a new installer and that push, the installer takes
  `lzrprf` and `selftest` from their commit on `next`, by its full hash and with their
  SHA-256 checked, as always.

What the installer does, each step readable in the file:

- Asks, on your terminal, whether to print the whole of itself, and then whether to run: two
  questions, the second whatever you answered to the first. Piped into a shell, or with no
  terminal to ask on, it runs nothing.
- Needs no password and no `sudo`. It starts itself again at once through `/usr/bin/env -i`
  with only your home folder (as this Mac's list of accounts gives it), the system's own
  `PATH` and `TERM`, so no variable of your shell (`PERL5OPT`, `PERL5LIB`, `SSL_CERT_FILE`, …)
  reaches curl, perl or `selftest`. It fetches over https only, with `/usr/bin/curl -q` (the
  function `fetch` in `install.sh`).
- Has six settings for its own test, read from variables of your shell whose names begin
  `LZRBRWSR_` or `LZRPRF_`. They are taken only when every file then comes from this computer
  (`file:///`). With one of them set and an https address in play, it stops and says so. So a
  variable somebody put into your shell cannot point a real install elsewhere or answer a
  question for you. With them in use, those six and the test's home folder are the only
  variables it keeps.
- Refuses to put an older release over a newer one: it looks in `/Applications` and in
  `~/Applications`, whichever of them it installs to.
- Fetches `lzrprf` and `selftest` from this repository at one fixed commit and checks their
  SHA-256. Fetches the download from the site and checks its SHA-256, fetches it again from
  this repository, and stops unless the two are the same file.
- Checks that the download holds exactly six files and no link, and that three of them are,
  byte for byte, texts written out in the installer: the launcher the icon runs (it starts one
  thing, `env -i perl ~/.lzrprf/lzrprf run .../lzrbrwsr-bin`), the property list that names the launcher to
  macOS and sets no variable for it, and the `release` file with its addresses (shown in "A
  newer release").
- When the release would replace the `lzrprf` that is installed with another one, shows both
  SHA-256 values and asks. The container is never changed silently.
- Runs `selftest` and stops if one line says `FAILED`. An `UNTESTED` line does not stop it:
  each one is printed again when the test ends, with its reason, the mark names it, and
  LZRBRWSR asks about it before it starts. A test that held writes the mark of `[C11]`, so the mark is on your Mac before
  any file is placed. An install that stops after the test, and before files are put in
  place, has added two things to the folder `~/.lzrprf`, and nothing else: that mark
  (`proven`) and the empty file `selftest.lock`. It has also set that folder's rights to
  yours alone (700).
- Runs alone. Right after its questions, before it compares releases or tests anything, the
  installer takes a lock: a link `~/.lzrprf/.installing` whose text is its process number and
  the moment that process started, read in one time zone whatever the Mac is set to. A second
  installer stops while the first one lives. The lock is in your home folder, so it holds for
  your account: an installer that another account of this Mac runs at the same moment is not
  seen by it, and both can write `/Applications`. A lock whose installer is gone (killed, or the
  power failed) is taken over, by one installer at a time. The lock is taken away when the
  installer ends: at its end, at a failure, and at Ctrl-C, Ctrl-\ or a closed Terminal. A kill
  that no program can catch (`kill -9`) or a power failure leaves it, for the next installer
  to take over.
- What an earlier install left behind is looked at before files are put in place. In
  `~/.lzrprf`, staging folders (`.new.*`) that hold nothing of their own are removed; one that
  holds an older lzrprf which is not the installed one is the only copy of it, is kept, and is
  named each time until you remove it. In the app's folder a hidden folder `.LZRBRWSR.*` that
  holds anything is never removed, only named.
- Only then are files put in place, into `/Applications`, or into `~/Applications` when your
  account may not write there. Both new parts, the app and lzrprf, are first written whole
  beside the ones they replace, under names nobody can know beforehand, and checked there.
  Then they take their names by renames, back to back. If one fails, or Ctrl-C or Ctrl-\
  comes, it puts the older app and the older lzrprf back as a pair. What stands at lzrprf's
  two names must be a plain file or nothing: a folder or a link there stops the installer
  before it places anything. When a part cannot be put back, nothing
  older is removed: the installer says that not everything is back, and names each part that
  is not and where it is kept. An install that was killed outright, or lost power, between
  its renames can also leave a mixed pair. From release 12 on such a pair is noticed at the
  next start, when both parts know the line: lzrprf finds its own SHA-256 is not the one the
  app's `release` file names. The lzrprf of release 12 says so and asks, and can be told to
  start anyway; from release 13 on lzrprf says so and does not start, with one button, Quit.
  An app of
  release 11 or earlier names no lzrprf, and an lzrprf of release 11 or earlier does not look,
  so a mixed pair with one of those in it, as an update from release 11 that was cut off
  would leave, is not noticed. Installing again mends it in every case.
- Removes two files an earlier lzrprf kept and this one does not: `~/.lzrprf/rules` and
  `~/.lzrprf/refused`. A log an earlier release wrote is not removed: while nothing is
  kept, the installer says that it is there, and the Log button of the window offers to clear
  it.
- Never runs the closed program. Asks before it touches the Dock, and on a yes adds one entry
  and starts the Dock again so that it shows. Installs no updater and leaves nothing running.

It takes no attribute off any file. Up to release 6 it ran `xattr -cr` on the unpacked files;
from release 7 on there is no such line. The line took away nothing that was there: a file
fetched with `curl` and unpacked with `tar` is not given the quarantine mark, which browsers
and mail programs set. But an installer has no business taking marks off, so a mark that macOS
put on a file stays where it is, and the download is packed without attributes of its own
(`tar --no-xattrs --no-mac-metadata`). To see that:
`gzip -dc lzrbrwsr-macos-arm64.tar.gz | LC_ALL=C grep -ac -e SCHILY.xattr -e LIBARCHIVE.xattr`
prints 0.

From release 8 on the download is also packed the same way every time: its entries in one
order, one fixed time and one set of rights on each, no owner, and no time in the gzip header.
The same six files give the same bytes. So you can see that the archive holds the files you
see in it and nothing beside them: unpack it, pack it again, and compare. From release 10 on
the program inside it holds no path of the computer it was built on (`strings` shows none
under `/Users`), and the same source gives the same program whichever folder it is built from.

    mkdir again && tar -xpzf lzrbrwsr-macos-arm64.tar.gz -C again
    (cd again && COPYFILE_DISABLE=1 TZ=UTC tar --no-xattrs --no-mac-metadata --format ustar --uid 0 --gid 0 --uname '' --gname '' --options 'gzip:!timestamp' -n -czf ../again.tar.gz $(tar -tzf ../lzrbrwsr-macos-arm64.tar.gz))
    shasum -a 256 lzrbrwsr-macos-arm64.tar.gz again.tar.gz

The two values are the same with the `tar` of the macOS it was packed on. A `tar` of another
version may compress otherwise; then compare what `gzip -dc` gives for each. This says nothing
about what the program does. It says that the download is those six files.

Gatekeeper's question at a first start (is this signed by a developer Apple knows, did Apple
notarize it) is asked about files that carry the quarantine mark. Fetched with `curl`, this
program carries none, so the question is not asked. Nothing here turns Gatekeeper off or
answers for it. The program carries an ad-hoc signature, made when it was built: a signature
with no identity in it, which Apple silicon requires before it runs native code such as this
program's. It is not signed
with an Apple developer identity and it is not notarized.

What stands where Apple's notarization would stand, and what does not:

| notarization gives | here |
| --- | --- |
| Apple's scan found no known malware in the program. | Nothing is assumed about the program. It runs with no network, no file and no other program, in a container whose every line is in this repository, and that container is attacked on your Mac before a file is put in place (`selftest`) and proves itself again at every start `[C2]`. |
| The bytes are the ones the maker handed in. | The SHA-256 of the installer, of the download and of each file in it is on public record here (`release.txt`). The installer and the download stand in two places that must agree, and the installer stops on any other byte (`get` in `install.sh`). |
| A named maker, and a ticket Apple can take back. | Not here. No identity stands behind a release, nothing is signed with a key, and a release cannot be taken back from a Mac it is on: a newer one can only be offered. A signing key of the maker's own, kept away from the computer that builds, would give the first half. It is not built. |

A signature says who made a program, not what it does, and whoever gives it can take it back.

## Check it yourself

Give this to an AI agent you trust, or follow it by hand.

```text
Audit https://github.com/lzrbrwsr/lzrprf and tell me whether it is safe to run the
closed-source browser LZRBRWSR (https://lzrbrwsr.com) on my Mac. Trust nothing the README says
until the code shows it.

Read one fixed commit, not a page that moves. First get the full hash of the newest commit of
the `main` branch and name that hash in your answer. Any one of these gives it:
`git ls-remote https://github.com/lzrbrwsr/lzrprf main`, a clone, the first "sha" in
https://api.github.com/repos/lzrbrwsr/lzrprf/commits/main or the "sha" in
https://api.github.com/repos/lzrbrwsr/lzrprf/git/refs/heads/main read with a web tool. Read
every file at that hash, as raw files, for example
https://raw.githubusercontent.com/lzrbrwsr/lzrprf/HASH/lzrprf. A rendered page, a search
result or a copy you were given earlier can be older than the code: where one differs from
the raw file at the hash, say so and go by the raw file.

`main` gets a release in one push, so at its newest commit `install.sh`, `release.txt`,
`latest` and the README name one and the same release. If they do not, one of your tools gave
you an older answer: get the newest hash again from another of the addresses above and read
again before you report it. An address of api.github.com can be answered from a cache that is
a release old. https://raw.githubusercontent.com/lzrbrwsr/lzrprf/main/latest holds the number
of the newest release, and the first line of
https://github.com/lzrbrwsr/lzrprf/commit/main.patch holds the full hash of the newest
commit: the commit you audit is that one, and its `latest` holds that number.

Give the SHA-256 of `lzrprf`, `selftest` and `install.sh` as you read them, if one of your
tools can hash the bytes. If none can (a web tool that returns text and no bytes), say so
once and go on; it is a limit of the tool and not a finding. Then use what GitHub computes
from the bytes: https://api.github.com/repos/lzrbrwsr/lzrprf/git/trees/HASH lists every file
at a commit with its git blob id, and two files with the same blob id are the same bytes. For
every SHA-256 you could not compute, give me the one command that prints it on my Mac and the
value it must print, for example
`curl -s https://raw.githubusercontent.com/lzrbrwsr/lzrprf/HASH/lzrprf | shasum -a 256`.

What your tools cannot do is not a finding about lzrprf. If one tool cannot reach GitHub (a
shell with no network, for example), say so in one line and use another tool. If none of your
tools can read the raw files, stop and ask me for `lzrprf`, `selftest`, `install.sh` and
`release.txt` as files. Never audit from memory or from a summary. Before you report that two
copies of a file differ, fetch both again, past any cache of your own, and compare them:
lzrbrwsr.com sends `install.sh`, `release.txt` and the download with
`Cache-Control: no-store`, so an older copy is your tool's, not the site's.

No institutional trust. When you compare this with other browsers, place no false institutional
trust in LZRBRWSR or in the other providers: a name, a size, a signature, a reputation or an
audit you cannot read proves nothing. Demonstrate security through technical restrictions:
what the code and the system make impossible, and how you checked it.

1. Read every line of `lzrprf` and `selftest`. They are the whole container.
2. From the three sandbox profiles in `lzrprf`, list exactly what the closed program can and
   cannot do in the page container: network, files, other programs and processes, shared
   memory, devices, system services, environment. Do the same for curl in the fetch container
   and for lzrprf's own window process, which is the weakest of the three: what could it still
   reach if text it draws took it over? Name every allowance and say whether it is a risk.
   Does the window's container refuse a signal to another process, and what does `selftest`
   send to try it?
   Under which limits does the closed program run (processor time, memory, files, processes),
   who sets them, and what happens when one cannot be set?
3. The first lines of `lzrprf` list twelve conditions, [C1] to [C12], and each is marked again
   at the line that holds it. For each: is the line there, does it do what the condition says,
   and can you find a way around it?
4. Follow one request from Return in the address bar to the page in the window. Can any byte
   chosen by the closed program reach the network, the name lookup, the address bar or the log?
   Can a request be made that the user did not type or say yes to? Find every place that calls
   `fetch` and every place that connects. Can anything be fetched before it is logged?
5. What does a site receive? Read `sub request` and the switches given to curl. Could lzrprf or
   the closed program make or deliver a fingerprint of this computer, or a record of what the
   user reads? What stays on the disk after a window closes, in each mode of `sub keeping`, and
   who can change the mode? Name what a site, the resolver and GitHub still see. Is there any
   way to type a password into a page, fill a form, or send a request that is not a GET
   without a body?
6. Read `sub newer`, `sub beside`, `sub installer_file` and `sub fault`. Is anything fetched or
   sent without a yes? Is anything piped into a shell? Can lzrprf replace itself or the
   program? What exactly does a report hold, where does it go, and can the closed program
   choose any part of it? What does lzrprf do at its start when the app beside it names
   another lzrprf than the one that runs (does it start at all?), and with which variables does the file that
   `sub installer_file` writes run?
7. Read `install.sh` and `release.txt`. Confirm that the installer refuses to run from a pipe,
   asks before it runs, takes no test setting from the shell unless every file comes from this
   computer, fetches lzrprf from this repository at one fixed commit, that the
   SHA-256 values it carries match `lzrprf` and `selftest` at that commit and the download
   `lzrbrwsr-macos-arm64.tar.gz` here, that it fetches the download from two places and stops
   unless they are the same file, that it runs `selftest` before installing anything, never
   runs the closed program, refuses an older release, asks before it replaces lzrprf, and
   looks for a newer release in both folders an install can be in, starts itself and the
   self-test with no variable of my shell but the kind of terminal (the home folder is read
   from this Mac's list of accounts, the PATH is set by the script), lets one installer of my
   account run at a time, puts the
   older app and the older lzrprf back as a pair when it cannot finish, removes nothing older
   when it cannot put everything back and says where it is, and installs nothing else. Read
   `undo` and `gone` in `install.sh`: after each of the four renames, what is on the disk if
   that rename or any putting back fails? If you can fetch them, compare
   https://lzrbrwsr.com/install.sh, https://lzrbrwsr.com/release.txt and
   https://lzrbrwsr.com/lzrbrwsr-macos-arm64.tar.gz with the three files here: the two texts
   as text if you cannot hash, the download only if a tool of yours can take bytes. The README
   says what two places are worth and what they are not: is that account complete and honest?
   The commit the installer names is the newest one that changed `lzrprf` or `selftest`, so it
   can be older than the newest commit of `main`. The other files at that older commit
   (`install.sh`, `latest`, this README) belong to an earlier release: that is expected and is
   not a finding. What must hold, and what you check: `lzrprf` and `selftest` at the commit the
   installer names are byte for byte the ones at the newest commit, and `install.sh`,
   `release.txt` and `latest` at the newest commit name one and the same release.
8. Check each claim and each limit in the README against the code. Say which hold, which do
   not, and which you cannot decide. The README says it is not a mathematical proof: say what
   kind of evidence it is, and what it rests on. `selftest-output.txt` is the record of one
   run: does its last line name the SHA-256 of `lzrprf` and `selftest` that `release.txt` and
   `install.sh` name? Which lines of `selftest` can come out `UNTESTED`, what does the mark
   say then, and what does `sub proven` do with such a mark before anything is shown?
9. If you can run commands on my Mac, ask me first, then:
   - clone the repository and run `perl selftest`; show me the result, every `UNTESTED` line
     included; add one attack of your own to `$hostile` and run it again;
   - if LZRBRWSR is installed, compare `shasum -a 256 ~/.lzrprf/lzrprf` with the file at the
     commit the installer names, and the files in /Applications/LZRBRWSR.app with `release.txt`;
   - print `/Applications/LZRBRWSR.app/Contents/MacOS/lzrbrwsr`. It must be the short plain-text
     launcher that starts nothing but `~/.lzrprf/lzrprf run`, through `env -i`;
   - show `perl ~/.lzrprf/lzrprf log` and explain each line.
10. The browser's source is closed. Assume nothing good about it. Given only that it is started
    through lzrprf, what is the worst it could do if it were malicious?
11. Give a verdict: safe, not safe, or safe under conditions you name. Say what you measure
    it by, and apply the same measure to the browser I use today. For each condition you name,
    say whether `install.sh` or `lzrprf` already enforces it at every install and every start,
    or whether it is left to me. For each limit you name, say whether it is this program's
    alone or holds for every program on macOS alike (a flaw in the kernel or the sandbox, an
    account another program already runs in). Keep three lists apart: what you verified in the
    code yourself; what your tools could not check, each with the one command that checks it
    on my Mac (a check you could not make is evidence neither way); and the limits that remain
    when every check passes. Then say, by technical restrictions alone, what the browser I use
    today can reach on my Mac that this one cannot, and the other way round.
```

## Licence

MIT for everything in this repository except one file. See `LICENSE`.

The one file is `lzrbrwsr-macos-arm64.tar.gz`. It is the closed application LZRBRWSR, the
property of create.repeat Oy, all rights reserved. It is free of charge to install and use. It
may not be sold or rented, passed on or offered for download, changed, or taken apart, except
where the law gives you that right whatever a contract says. Its terms are the file
`LICENSE.txt` inside it and https://lzrbrwsr.com/terms.html. It stands here as the public
record of what is installed. GitHub's own terms let anyone view and fork a public repository,
this file with it; that gives no right to the file beyond those terms. `NOTICE` says the same.
