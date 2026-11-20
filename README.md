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
treats that browser as hostile. The browser gets no network, no file of yours, no window and no service
of the system: it reads the system's own folders and the folder it is installed in, and can
write no file. lzrprf owns the one window you see, with its address bar, and does itself the one
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
- `selftest`: a hostile application that probes all of it on your Mac and says what it managed to do.

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
   `[C1]` to `[C16]`, listed in the first lines of `lzrprf` and set again at the line that holds it.
2. It is **probed on your computer**: `selftest` runs a hostile application against that
   condition. A probe on a container is first made outside every container, where it must
   succeed, so a refusal inside is the container's and not a probe that could never have
   worked. A condition that is not a container's (what is fetched, what is logged, what is
   drawn) is judged by what the test's own site received and by what the log holds. The hostile
   application is the test's own (`$hostile` in `selftest`), put in the closed application's
   place. The closed application is never run by the test, so what is shown is what the
   container does to any program, whatever LZRBRWSR is.
3. The test is **shown not to be blind** for the page container `[C1]`, the tries of `[C2]`,
   the start inside the container `[C3]`, the window container `[C10]`, the yes to untried
   checks `[C11]`, the limit on memory and the pair check, and from release 17 on for the
   keeper, the second read of the program, the files beside it and the limit on open files.
   `selftest` builds copies of `lzrprf`, each with one or two things taken out (`%lost`, the
   runs whose names begin `lost`, and `nofeeder`, `leftpage`, `leftkilled`, in `selftest`), and what comes after it must
   stop each or show the difference: a page container that
   refuses nothing is stopped by `[C2]`; that container without the tries of `[C2]`, and a
   start outside the container, are both stopped by `[C3]`; a page container without its limit
   on memory is stopped by `[C2]`, and with the tries of `[C2]` taken out too, the probe on
   memory is made in it and its line says so; a window container with one refusal taken out is
   stopped by `[C10]`; a copy whose pair check is taken out, and a copy that counts a mark
   with untried checks without your yes, each fetch without the window or the question the
   real `lzrprf` puts first, and their lines say so; a copy without the keeper leaves the
   application running when lzrprf is killed (`leftkilled`), a copy that does not read the
   program again starts a program that was swapped (`lostswap`), a copy that does not read
   it before a site is asked fetches for a program that changed (`lostlook`), a copy whose
   page container does not refuse it lets the application load another file of its own
   folder as code (`lostcode`), a copy whose limits may be raised again lets it allow
   itself more processor time (`lostsoft`), a copy that does not look
   beside the program starts with a file there that is not named (`lostbeside`), and a copy
   without the page container's limit on open files lets the hostile application allow
   itself more (`lostfiles`; the same limit on `curl` has no such copy), a copy that shows a second run which names style sheets again shows its page (`lostsheets`), and their lines say so. The other conditions have no such copy yet.
4. It is **proven again when what it rests on changes**: after an update of macOS, or a change
   of `lzrprf` or of the `selftest` beside it, no page is shown before the probes were made
   again `[C11]`. A run of `selftest` takes the mark of what it tests away at its start and
   writes it again only when nothing failed, so a run that fails takes back an earlier proof.
   The one module the test uses that is not part of perl itself (`IO::Socket::SSL`) is loaded
   only after the mark is out.

So a run that held is evidence for the probes it names, each with its control outside the
container and, for the things named in point 3, the weakened copies it must catch. It is not
a proof that no other probe exists.

`selftest` also reads this README when it stands beside it. It fails when the marks cited here
are not exactly the sixteen in `lzrprf`, when a part named here (the word `sub` and a name) is
not in `lzrprf`, or when one of eleven limits is not stated here as the number in `lzrprf`: 30
seconds for a fetch and for a page, 6 MB for an answer, 12 MB for a list, 50000 lines, 2000 boxes,
20000 characters in a block, 30 characters in a row that hang on the one before them,
1000 characters with no white space, 10 minutes, 8 addresses.
That is a check of names and numbers, not of sentences. Whether a sentence here is true of the
code is for a reader to decide, and "Check it yourself" below is written for that reader. An
installed copy of `selftest` has no README beside it and skips this check.

## How it works

Your Mac shows one window, named after the application. That window is lzrprf's. Behind it,
lzrprf starts three kinds of process, each in a container: a macOS sandbox profile. The
keeper of a page, the name lookup and the system's tools that lzrprf calls run outside the
containers, as lzrprf itself does; the closed program is never one of them.

| container | what runs in it | network | what it is given |
| --- | --- | --- | --- |
| page | the closed application, once for each answer | none | the finished answer on one pipe; a pipe to lzrprf for a list of lines |
| fetch | the system's `curl`, once for each request | none | one socket file, behind which lzrprf holds the one connection |
| window | lzrprf's own window text, run by the system's `osascript` | none of its own | two pipes to lzrprf, and the 41 system services and one local name its container lists |

The page and fetch containers start from "deny everything" and allow a short list
(`$CONTAINER` in `lzrprf`). The window container is written the other way round
(`$WINDOW_CONTAINER`): what a program of yours may do, without a list of things, except the
system services it may look up by name, which from release 19 on are listed one by one. It is the
weaker of the two kinds, and "What it does not prove" says what follows from that. What is
outside every container is `lzrprf` itself: it looks up the name, makes the one connection,
writes the log and checks what crosses.

Before the first page, at every start (`sub behind`): macOS is asked whether the window's own
process is in its container `[C10]`, and lzrprf looks whether `selftest` held on this Mac as it
is now `[C11]`. Without both, no page is shown. lzrprf also compares its own SHA-256 with the
line `lzrprf` of the installed app's `release` file; when they differ, or when the app names
no lzrprf at all (apps before release 12 named none), it says so and does not start: that
window has one button, Quit (`sub paired`, the runs `pairother` and `pairnone` in `selftest`).
From release 16 on the same `release` file names the launcher and the program with their
SHA-256 (two lines `file`), and lzrprf compares each file those lines name with the file
that is there, at the same moment: when one is another file, or the program is not named,
the app does not start either (the runs `fileother`, `filebeside`, `filegone`, `filenone` and
`fileunnamed`). Only a plain file is read, so a folder, a pipe or a device of that name
counts as another file (`filefolder`), and a line that begins with `file` and is not in its
shape counts as a file that differs (`filedamaged`). From release 17 on, in an application
folder, every entry in the program's folder (`Contents/MacOS`) whose name does not begin with
a dot must be named by a line `file NAME SHA-256`: so the launcher must be named, and a file
put beside the program that the `release` file does not name stops the start (`filelone`,
`fileextra`). A name that begins with a dot is passed over, because the Finder writes
`.DS_Store` there, and nothing starts such a file (`filedot`). Release 16 required only that
the program be named (a copy that does not look beside it: `lostbeside`). The installer stops
unless both lines are there. The named files are looked at once, at the start, measured by a
file of the app's own: it finds a program or a launcher that was changed while that file was
not, as a damaged disk or a copy that did not finish leaves them. From release 17 on the
program is also read again for every page, twice: lzrprf takes its SHA-256 at the start,
takes it again when you press Return, before a site is asked (`sub visit`), and once more
just before the program is started (`sub laid_out`). When it differs at the first, nothing
is fetched. When it changed while the site answered, that request was made and is in the
log, and the program is not started. The
window then says that the program on the disk is another file than when the window opened, as
after an update, and to quit and start again; no report is offered for this (`swapped`,
`lostswap`, `lostlook`). Release 16 looked once, at the start. Between reading the file and starting it
there is a moment. Whoever can replace the program can replace that file, and lzrprf, too:
this finds an update or a damaged file under an open window, not an intruder in your
account. It does not have to find one: the program is the part that is assumed hostile, and
it is kept in the container whichever file it is.
A program that stands in no application and has no `release` file beside it is not asked: the
installer places no such program, and the launcher starts none. And when the mark names checks the test could not try on this Mac,
the window names them and asks, and no page is fetched or shown before your yes to exactly those
(`sub proven`).

One visit, in order (`sub visit`):

1. You type an address into the bar and press Return. The window tells lzrprf.
2. lzrprf checks that it is an https address of a host by its name (`sub address`). From
   release 17 on it then reads the application's program again: when that is no longer the
   file the window began with, the visit ends here, with nothing written and no site asked.
   Then it writes
   "you typed ADDRESS" into the log `[C5]` (`sub record`). When you chose to keep a log (see
   "What is kept") the line is written to the disk first, and added to the memory of the
   process behind the window only after that write succeeded; otherwise it goes into that
   memory alone. Both come before the request.
3. It looks the host up, in a process of its own that is given 10 seconds, and takes the first
   8 addresses this computer has a way to (`sub find`): one it has no route to is passed over,
   and what the lookup gave beyond its first 16 is not looked at.
4. If the host leads into your own network, it asks you, for this one request `[C8]`.
5. It writes down the numeric addresses, connects to one of them itself `[C6]`, and lets `curl`
   do the https over that one connection, in the fetch container (`sub fetch`). A fetch is
   given 30 seconds, looked at once a second, so a request that runs over ends at most about a
   second later. Those 30 seconds start in `sub fetch`: the lookup before it, the question to
   the system about the way to each address (`sub route`, 5 seconds each, and a second one for
   some), and your answer about your own network have their own time and are not inside them.
   From release 19 on the way the internet at large is sent is recognized over IPv6 too:
   macOS writes that route with the destination `::`, and until release 18 lzrprf took it
   for a route of your own, so on a network with IPv6 it asked about your own network before
   a site that has an IPv6 address. It asked too often, never too seldom.
   An answer may be 6 MB, and 64 KB at most are carried to the site. Neither
   bound is passed: what comes beyond it is not passed on, and the request fails.
6. It writes down how it ended and which address answered. When that line cannot be written,
   the answer is not shown, and the window says that the fetch was tried, not that nothing was
   fetched (the run `logend` of `selftest`).
7. Only now, with the connection closed, and from release 17 on only when its program is
   still that same file, the closed application is started in a page container
   `[C1]` with the address in one variable and nothing else, and handed the answer once macOS
   itself says the process is contained `[C3]` (`sub laid_out`). From release 17 on the
   answer is handed over by the page's keeper, a second process of lzrprf's own (`sub keeper`),
   which ends the application when lzrprf ends (see "It cannot reach other applications").
8. The application writes a list of what to draw. lzrprf checks every line `[C9]`
   (`sub checked`) and gives the window only lines of five kinds: a paragraph begins, text, a
   line ends, a grey box where a picture would stand, and before all of these, from release 20
   on, a thing the application says the page is made of; or a laid page. The window draws them.
   The application sends no picture pixels yet: every picture is a grey box.
   Those first lines are what the application says the page is made of: a kind (one of eight
   letters: document, CSS, JavaScript, libraries, media and formats, web APIs, security and
   transport, metadata), a `+` or a `-` for whether the application says its own code
   supports the thing, a name of at most 60 plain characters, and after a tab a version of at
   most 30. There are at most 120, in the order of the kinds and by name within a kind, no
   name twice in a kind, so one list has one form. The window lists them in a pane under the
   page, a row for each: its name, its version, and "supported by" the application's name
   with true or false. Above the rows a sentence says that lzrprf checked the form of the
   list and not whether it is true. Apart from refusing a whole list in which such a line has
   a wrong form or place, lzrprf does nothing with them: nothing is fetched or allowed
   because of what they say.
   From release 21 on the list is also held to what the window can set without standing
   still. The window sets text with the system's own code, and that code slows down far
   more than the text grows: measured in the real window, unseen, one block of 100,000
   characters outside the first font kept it busy for more than a minute, and so did one
   letter under 20,000 marks. So a list may hold 12 MB and 50000 lines, and one block (from
   one line that begins a paragraph to the next) 20000 characters as the application wrote
   them, where a line break counts 1 and a grey box 400. A list over any of these is not
   drawn at all. And lzrprf changes two things in a text, as it changes a control
   character in it to U+FFFD. After 30 characters in a row that hang on the one before them
   the next becomes U+FFFD. What hangs is what Unicode joins to the character before it (a
   mark, a character that extends a cluster or is spaced like a mark, a Hangul vowel or
   final, a Hangul initial after another), what follows a character that comes before its
   letter, and what follows a sign that joins two letters into one (`$HANGS`). And after
   1000 characters with no white space, that is with no space where a line may end (a
   no-break space is none), it puts in a space of no width (U+200B), which shows nothing
   and lets a line end there. It is put after the characters that hang on the last one; a
   word that ends in them keeps them whole. A text you copy out of the window holds those
   spaces. `selftest` draws the heaviest pages these limits allow, of each kind that was
   measured slow, in the real window, and fails when one takes 30 seconds; on the Mac this
   was written on the slowest took about 7. That is a measurement on one Mac and one build
   of macOS, not a bound on the system's code: a text of a kind nobody tried may still be
   slow.
   From release 22 on a page may instead be laid: the application has laid it out itself and
   says where everything stands (`sub laid`). After the lines of what the page is made of
   comes one line with the page's width, 320 to 2400, and height, 1 to 200000, in CSS pixels.
   Then, in the order they are painted: filled rectangles in a colour, runs of text whose
   baseline begins at a point, in a size of 6 to 96 and with the same letter of looks as a
   text, grey boxes where a picture would stand, and pictures. A picture is given as its
   pixels, at most 1024 by 1024, one line of base64 for each row: red, green, blue and how
   opaque, a byte each. All the pictures of a page hold 262144 pixels at most. Every number
   is written in one way only, everything stands inside the page, and a page is laid or
   flowing, never both. A laid page holds at most 20000 rectangles, 30000 runs of text, 1000
   grey boxes and 64 pictures, a run 2000 characters and all its runs 1000000, within the
   12 MB and 50000 lines of every list. A page over any of these, a picture whose rows are
   not as many as it says, a row that is not exactly as long as the picture is wide, or
   base64 in any other form than the one it is written in, is not drawn at all. A run of
   text gets the changes a text gets: a control or format character becomes U+FFFD, and so
   does the 31st character in a row that hangs, counted in each run by itself. No space of
   no width is put in, since a run is drawn on one line. The window draws a laid page in a
   view of its own in the place of the text: white, scaled to the window's width and never
   larger until the window is half as wide again as the page, the rectangles over what is
   under them, the text in Arial and Menlo, and each picture from its bytes as they are,
   handed to the system as pixels, with no image decoder. A laid page has no menu, and its
   text cannot be selected or copied.

## The conditions

| mark | the condition | where in `lzrprf` | how `selftest` probes it |
| --- | --- | --- | --- |
| `[C1]` | The application is started in one place only, and only inside the page container. | `sub laid_out`, through `sub contain` | Reads the text: the program is started on one line. A copy that starts it uncontained is stopped by `[C3]`. |
| `[C2]` | At every start lzrprf tries, inside that same container, what the container must refuse. Nothing starts unless all of it was refused and the same tries worked outside. | `sub holds` | A copy whose container refuses nothing: nothing is started. |
| `[C3]` | No process is handed a byte of what was fetched, nor the connection to a site, before macOS itself says that this process is contained. Before that, of what you asked for each knows the address alone: the application in one variable, `curl` among its fixed switches. | `sub inside`, asked in `sub laid_out` and `sub fetch` | Copies without `[C1]` and `[C2]`: the system says "not contained", and the answer, or the connection, is withheld. |
| `[C4]` | A request is made only for an address that came from the window's bar or was typed into its own bookmark modal, at once or kept as the home page or a bookmark, or that a page redirected to and you then said yes to in lzrprf's modal (once a visit, to the same address with `www.` put in front of its host or taken off, without a question, written in the log first); for at most eight pictures and at most eight style sheets the page laid out from such an address names on that same host (`sub pictured`, `sub sheeted`); or for one of three fixed addresses of the release file after you said yes: a report, after you pressed "Send" for it, the look for a newer release at each start after a yes you gave once for exactly that address, kept in `~/.lzrprf/look` until you delete it (`sub newer`), and the installer, in its one or two places, after "Install it" (`sub installed`). | `sub behind`, `sub go`, `sub fixed` | The test site's own record: each address as often as it was asked for, and nothing else, with tabs, the home page, bookmarks, redirects and the installer among the runs. Reads the text: a request has four roads and no fifth. |
| `[C5]` | Nothing is looked up or fetched before its line is in the log: in the memory of the process behind the window, and on the disk too when you chose to keep a log. No answer is shown whose line could not be recorded. | `sub visit`, `sub fixed`, `sub record` | A kept log that cannot be written: nothing is fetched. For every request the site received in a run that keeps a log, full or hosts only, the line was on the disk first. In a run that keeps nothing, the Log button shows the lines afterwards; that each was in memory before its request is read in `sub record`, not probed: no test looks into that memory while a request is open. That the lookup comes after the line is read in `sub visit`, not probed: the test's site is on this computer. |
| `[C6]` | One place connects to a site, and it connects to a numeric address that was checked and written down. | `sub reach` | Reads the text: two `connect` lines, this one and a try against lzrprf's own listener on this computer. A listener the hostile application knows hears from it only through lzrprf's hands. |
| `[C7]` | What a site is sent is made from the address alone, with one fixed browser name, `User-Agent: LZRBRWSR`: the same request from every computer, byte for byte, nothing kept from an earlier request. The request is what goes inside the encryption (HTTP); how TLS, TCP and IP are spoken around it is the system's `curl` and network, and can differ from one computer to another. | `sub request`, `sub fetch` | Compares `lzrprf request` with the bytes the test site received, and finds `User-Agent: LZRBRWSR` exactly once in every request and no other header than the five fixed lines. The site sets a cookie; it never comes back. |
| `[C8]` | A host inside your own network is fetched only after your yes to exactly that, once. | `sub own_network` | A no: nothing is fetched, and the no is in the log. |
| `[C9]` | Every line the application writes is checked, and a list with anything but the five kinds of line (from release 22 on, or the lines of a laid page, laid at the width its `=view` frame asked for), or with more than the window is given to set, is not drawn at all. The page's title, a line `=title` right after `=page` of at most 200 characters with every control and format character taken out, is shown in its tab and nowhere else. A laid page may also hold tiles: `K<n>,<x>,<y>,<w>,<h>` gives tile n (0 to 31, each once) at a corner of the grid of 256, exactly as wide and high as the page leaves there (256 at most), with one line `n<base64>` for each row: red, green and blue, a byte each and no alpha, since a tile is opaque, so a row is exactly 4 characters of base64 a pixel with no `=`, and its length and its alphabet are its whole check (from release 31 on; a picture keeps its rows `m` with how opaque), and `J<n>,<x>,<y>` places a tile given above again where it is cut the same; at most 32 tiles and 1024 places, outside the 262144 pixels of the pictures, which is why a list may hold 12 MB. | `sub checked`, `sub laid` | Hostile lists (a script, lzrprf's own words to the window, too large, a block that holds too much, not text, a thing the page is said to be made of in a wrong form or place): none is drawn. The fullest list of such things that is allowed is passed on, and the real window's pane is read. The most lines, the most boxes and a block that is exactly full are passed on; a row of hanging characters and a word with no white space come out changed at the 31st and after the 1000th; the heaviest pages the limits allow are drawn by the real window and timed. Laid pages broken in eleven ways (out of the page, a number in a second form, too narrow, too many rectangles, mixed with a flowing page either way, a row of a picture missing or too long, not base64 or base64 in a second form, too many pixels), and tiles broken in twenty-three ways (wider or narrower than their cut, a row 4 characters too long or too short or missing, a row `m` as a picture's, a row with `=` or `==` at its end or with `-` or `_` in it, a row `n` under a picture or under no tile, numbered 32, 01 or twice, placed before they are given, off the grid or out of the page, placed where they are cut otherwise, 33 tiles or 1025 places): none is drawn. A laid page that is fit, tiles too, is passed on as it is, and in its text a control character is replaced, not refused. |
| `[C10]` | The window's process has no network of its own, writes no file, starts no other program (the one program its container lets it start is `/usr/bin/osascript`, the program it is, and that stays in the same container), opens nothing through the system, commands no other program, sends no signal to another process, and reads nothing under `/Users` or on another disk but your settings, fonts, keyboard layouts and input methods. Before the window takes an address or shows a fetched page, macOS is asked about eight operations of that process (connecting out, creating a file, starting a second process, reaching a system service when none is named, opening something through the system, commanding another program, writing your settings, sending a signal), and each must be refused; the rest of the container's text is not asked about, and `selftest` makes its own tries from the real window, starting another program among them. Until then the window shows only the words of lzrprf and of its `selftest`, and no fetched page. Of the system's services it looks up by name only the 41 its container lists and one local name, the clipboard's (from release 19 on; before that all but one). The question about a system service names none: it says that the container refuses by default, not which names its list lets through. | `$WINDOW_CONTAINER`, `sub inside`, `sub behind` | Runs its own tries inside the window's process, and asks macOS about that process. A copy with one refusal taken out: no page is shown. From the real window it asks for six system services by name: the clipboard, which the container lists, is answered, and the five it does not list are refused; a copy without that refusal is answered as a program outside every container is, and a copy whose list is one name wider is caught by the same try. |
| `[C11]` | No page is fetched or shown before `selftest` held on this build of macOS with this `lzrprf` and the `selftest` beside it, in its last run there. The window is there earlier, with its bar switched off: it shows lzrprf's own questions and no page. A check the test could not try there is named in its mark, and then no page is fetched or shown before you said yes to starting without exactly those checks. | `sub proven`, `sub mark` | No mark, a mark from another build of macOS, a mark of another `lzrprf`, a mark made by another `selftest`, a mark that names no `selftest`: each time you are asked to test, and after a no nothing is shown, looked up or fetched. A mark that names a check that could not be tried, with no yes or with a yes to other checks: the window names the check and asks, and after Quit nothing is shown, looked up or fetched. A copy that counts such a mark without a yes: its line says it fetched. |
| `[C12]` | lzrprf writes nothing of what you fetched to the disk unless you chose a kept log (what macOS keeps on its own is under "What is kept"), apart from the one address you made the home page, the bookmarks you made or imported (each a name and an address) and the order of each of their folders (a file `.order` of their names), whether the bookmarks bar is shown, and an installer you chose to run, with what it printed (`install.txt`); a kept log holds hosts only unless you chose full addresses. It is only added to, apart from clearing by your button and the days you chose: in a kept log each of the two says so in its first line, and with nothing kept, clearing removes the log whole and the window's lines say so. | `sub record`, `sub keeping`, `sub choose_keeping`, `sub changed`, `sub clear_log`, `sub expire_log` | The window's buttons, pressed in every order the test knows, never leave more kept than before: more is taken from `lzrprf keep` only. A change is a line of the log. With nothing kept, no file holds a path or a query that was typed. Hosts only: no file holds them either. Tens of thousands of lines and none dropped; cleared only after two questions; not while a request is open; old lines taken out at the start of a window, said in the first line. A setting that is no setting keeps nothing. |
| `[C13]` | The application opens no file for its fonts. lzrprf hands a page run, and never a picture run, eight fonts of the Mac by fixed paths in `/System/Library/Fonts/Supplemental` (Arial and Courier New, each plain, bold, italic and both), as one frame in front of the answer: `=fonts` and the eight lengths on one line, then their bytes. A face goes with length 0 unless it is a plain file and no link, of at most 2 MiB, that begins as a TrueType font; a pipe put in its place is not waited for. They are read once in a window, and the keeper hands them over after the same word of the system as the answer `[C3]`. A site cannot put a frame in front of lzrprf's: what it sends comes after it. | `sub faces`, `sub contained` | The application takes the frame off its input and says the length and SHA-256 of each face: they are the eight files as `selftest` reads them itself. A picture run gets no frame. A site whose answer holds a frame of its own: it arrives after the real one, byte for byte. A copy that reads its fonts from a folder of the test: a link to a font, a file one byte over 2 MiB, a pipe and a file that does not begin as a font each go with length 0, while a font of exactly 2 MiB is handed over whole; the same copy without O_NOFOLLOW hands over the font behind the link, and the test notices. |
| `[C14]` | A page is laid out at most twice. The first run of a page is given the empty frame `=sheets` after the fonts, and may name up to eight style sheets on the page's own host in a line `=sheets`, checked as the paths of pictures are `[C9]`. lzrprf fetches them `[C4]` `[C5]` and runs the page a second time, with `=sheets`, the length of each and their answers byte for byte in front of the page's answer, each at most 1 MiB or with length 0. A second run that names style sheets again, or is not a page, is not shown: the first run's page is, and the bar says the sheets were not used. There is never a third run, and a picture run is given no style sheet. | `sub checked`, `sub sheeted`, `sub visit`, `sub contained` | The application says on each run the length and SHA-256 of each sheet it took off its input: none on the first run, the test site's answers on the second. A sheet whose body begins `=sheets 4` arrives inside its own length. A sheet over 1 MiB, a fetch that failed and a sheet not begun within the clock each go with length 0, the last neither logged nor asked for. Each sheet has two lines in the log and one request, of its own address; no other host is asked. Lines `=sheets` broken in six ways are refused with nothing fetched. A second run that names sheets again, or is not a page: the first run's page, two runs. A page that names none: one run. A picture run gets no frame. A copy that shows a second run naming sheets again shows it (`lostsheets`). |
| `[C15]` | Another browser's bookmarks are read only after you chose that browser, or a bookmarks file, in the window's import wizard, by lzrprf itself and never by a container or the window, with no program started: `Local State` and each profile's `Bookmarks` of Chrome, Edge, Brave and Vivaldi, Firefox's `profiles.ini` and newest `bookmarkbackups/*.jsonlz4`, Safari's `Bookmarks.plist`, all at fixed places under your home folder, or an HTML bookmarks file of yours found in Downloads, Desktop or Documents or typed as a path in your home folder; each a plain file of yours and no link, of at most 32 MiB. Nothing in them is fetched, and nothing of them is written but the bookmarks kept after you pressed Import `[C12]`. | `sub import_read`, `sub import_profiles_of`, `sub import_files`, `sub import_path`, `sub import_preview`, `sub import_plan`, `sub import_go`, `sub lz4_block`, `sub plist_binary` | Fixture files of each format under the run's own folder, which a try takes for the home folder: Chrome's JSON with two profiles named in Local State, a Firefox backup whose LZ4 block holds matches, a binary plist made by `plutil`, an HTML export. Each is imported in its order, the bar into the bookmarks bar after what it held, the rest into "Imported from" and the browser's name, numbered past a folder of that name. Plain http and `javascript:` are skipped and a fifth folder deep is left out, each counted. A link to a bookmarks file is neither offered nor read; a typed path outside the home folder, or climbing out of it, is refused. Nothing imported is fetched or logged. |
| `[C16]` | An incognito window writes nothing that outlives it. Its log, history, tabs and everything it fetched are held in its memory or in one folder of its own, readable by you alone, in your temporary folder, named `lzrprf-i.<process number>.<12 random hex digits>`; of `~/.lzrprf` it reads, and never writes, the self-test's result, the home page, the search address, whether the bar is shown and the bookmarks. The folder is removed however the window ends, and one left by a run whose processes are all gone is removed at the next start. | `sub incognito_begun`, `sub swept`, `sub removed`, `sub leave` | Run `incognito`: two pages, a bookmark opened, the star and the import tried; every file of the run's lzrprf folder hashed before and after, byte for byte the same, and the window's folder gone. Runs `incognitokilled` and `incognitoswept`: kill -9 of the sweeper, the process behind the window and lzrprf leaves the folder; the next start removes it. |

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
  or the connection is handed over only after those four refusals `[C3]`. These are questions
  about a fixed list of operations, not about the whole container text: the rest of the text is
  what `[C2]` tries. And the process is already running when it is asked, with the address it
  was given; what waits for the answer is the site's answer, or for `curl` the connection.
  From release 19 on an application the system does not call contained is held still
  (`SIGSTOP`) before its keeper is ended, and then killed: the keeper's end closes the
  application's input, and until release 18 it could go on at that for an instant, outside
  the container it was never in, with the address and without the answer. `selftest` saw
  that once in its own run of a copy that starts the application uncontained.
  For the window's process eight must be refused: those four, and opening something
  through the system, commanding another program, writing your settings, sending a signal. For
  the window the fourth question names no service (from release 19 on): the no says that its
  container refuses a system service by default, and nothing about which names its list lets
  through. What the window may
  read is not among the questions: `selftest` tries that from the real window. Nothing is
  asked of the process itself.
- What the icon runs is a short plain-text launcher. It starts `lzrprf run` through
  `/usr/bin/env -i`, or without lzrprf only an alert, so no variable of whoever started it
  reaches lzrprf. From release 14 the launcher reads no variable itself either: its one
  command starts perl through `env -i`, and that perl finds your home folder in this Mac's
  list of accounts, as lzrprf does. What is left of the starter's is how `/bin/sh` itself
  starts, before that one command. The installer compares the launcher byte for byte before
  it installs anything.
- Which process sees which variables. lzrprf's own process, outside every container, sets its
  own at its start: `PATH` to the system's folders, and `LANG`, `TMPDIR` and
  `__CF_USER_TEXT_ENCODING` kept only when they were set; every process it starts outside the
  page and fetch containers starts with those: the window's (in its own container), the
  keeper, the name lookup, `route`, `xattr`, `sysctl`, the `osascript` that asks macOS
  whether a process is contained, `open`, and `selftest` when you say yes to a run. The page program sees
  one variable, `LZRPRF_CONTAINED`, which holds the address. `curl` sees none.

Condition: this holds for a program started through `lzrprf run`. The program file itself is an
ordinary file; started by hand, from a terminal, it runs like any program you start by hand.
Nothing that is installed starts it that way.

### No request you did not ask for

A request of lzrprf's to a site goes only through `sub fetch`: it is the one way for an address
you typed, a bookmark or the home page you opened, a redirect you said yes to, the look for a
newer release, a report and the installer after "Install it". Other things touch a socket, and none of
them connects to a site: the try at each start against a listener lzrprf opened on this
computer (`sub holds`), the system's name lookup (`sub lookup`, below), `curl`'s
connection to lzrprf's own socket file, the question to the system's routing table
(`/sbin/route` in `sub route`), and `selftest`, which `sub proven` starts after your yes:
it opens listeners on this computer and tries 192.0.2.1, an address no host answers. Outside
lzrprf, the `curl` of the installer you start by hand fetches too ("The installer"). `fetch` is
called from four places, and `selftest` reads `lzrprf` and counts them:

- `sub visit`, called from `sub go` alone, for an address that came from the window `[C4]`: a
  line `go TEXT`, which the window writes when Return is pressed in the bar and at no other
  time; a line `mark open N`, a bookmark you made; the home page you set, at the window's start
  and in a new tab; or the address a redirect named, after your yes in lzrprf's own modal (see
  "Tabs, the home page, bookmarks, redirects"). The application cannot write any of these: it
  has no pipe to that side, and nothing it writes is passed on as words to lzrprf.
- `sub pictured`, called from `sub visit` after the page was laid out, and from `sub relaid`
  (the page laid out again at a new width, or in a tab chosen again) with the pictures it
  decoded then, which fetches nothing. A laid
  page may name up to eight pictures on its own host, by path, in a second line
  `=pictures /path /path ...`, and place them with `I` lines. Each picture placed is fetched
  once, one after the other, from `https://` the page's own host and that path: never another
  host. It goes the way the page went: its line `<address> -> lzrprf connects to ...` is in the
  log first, then `fetch` connects to the same addresses the page came from, and the site is
  sent `request` of the picture's address, the same five lines as for any address typed
  `[C7]`, and its result is written as a second line. The application then decodes the picture
  in a page container of its own, started exactly as a page's is, with one variable more
  (`LZRPRF_PICTURE=1`), and writes only pixels: `P<w>,<h>` and one line of hex per row.
  lzrprf checks every byte of that; anything else is no picture. The window is never given a
  byte the site sent: lzrprf writes the pixels into the form of picture a laid page already
  has, rows of red, green, blue and how opaque, and a picture that is missing, late (all of
  them share one clock of 20 seconds) or wrong is the grey box it was before. The line under
  the bar says how many of the pictures were fetched and shown, and it still says that no
  other host was asked.

  After the lines `=pictures` and `=sheets`, or where they would stand, the application may write one line
  `=statement TEXT`: in its own words, why it shows the page in compatibility-statement mode,
  1 to 200 plain printable characters (bytes 0x20 to 0x7e). lzrprf shows those words as plain
  text at the end of the line under the bar, and reads them for nothing else; they name no
  address and cause no fetch. A second such line, or one too long or with any other byte,
  makes the page no page (`sub stated`).
- `sub sheeted`, called from `sub visit` alone, from release 32 on, before the pictures. A page
  may name up to eight style sheets on its own host, by path, in a line `=sheets /path /path ...`
  right after the line `=pictures` (or where it would stand), in the same grammar and with the
  same checks as the paths of pictures; a second such line, or one in another place, makes the
  page no page and nothing is fetched. Every page run is given, after the fonts `[C13]`, a frame
  of style sheets: on the first run the empty line `=sheets`. When the first run names sheets,
  each is fetched the way a picture is, its line in the log first, from `https://` the page's own
  host and that path, never another host; one clock of 10 seconds for starting them, and a sheet
  not begun by then, a fetch that failed and an answer over 1 MiB each go with length 0. The page
  is then run a second time with `=sheets` and the length of each on one line, and the answers
  as the site sent them, in front of the page's `[C14]`. The second run's page is shown when it
  is a page and names no style sheet; otherwise the first run's is, and the line under the bar
  says that the style sheets were not used. There is never a third run, and a picture run is
  given neither frame. The pictures are fetched after the page that is shown was chosen.
- `sub fixed`, which runs for three fixed addresses of the release file, each only after your
  yes in the window: the newest release number (`sub newer`), a report you chose to send
  (`sub fault`), and the installer after "Install it" (`sub installed`), from both places when
  the release names two. For the
  newest release number the yes is given once and kept with its address in `~/.lzrprf/look`:
  the look is then made at each start, without a new yes, until you delete that file.

Before any of them, the line is in the log `[C5]`. The connection is made by lzrprf, to a numeric
address it wrote down `[C6]`. `curl` has no network of its own: it gets one socket file, so it
can reach that one connection and nothing else. `curl` follows no redirect: an answer that
sends on is never laid out, and lzrprf asks you in its own modal (`sub redirected`). Other hosts a page
names (pictures, scripts, trackers) are never asked. It is the application that reads the page,
so it is the application that names them: lzrprf takes at most 200 names from it, shows you how
many and the first four, and asks none. A hostile application can name fewer or other hosts
than the page does. That changes a sentence in the window and no request. Those up to four
names, and how many it named, are the only text the application chooses that is shown outside
the page: in lzrprf's words under the bar, each name in the shape of a host name (letters,
digits, hyphens, at least one dot, each part at most 63 characters, the last part beginning
with a letter; `$NAME`, used in `sub checked`). They are not written in the log.
Which of five of the eight fixed phrases says why a page was not shown is its choice too; the
other three are lzrprf's and the system's (see "When a page cannot be shown").
The page cannot make a request by being clicked either: a link is drawn as a colour and does
nothing.

The name lookup is a request too, to your resolver, for the host you typed, after the log line.

The installer of a newer release is fetched by lzrprf itself, after you pressed "Install it",
through `sub fixed` and `sub fetch` like every request, from the places the release names, and
it runs in lzrprf's own window (`sub installed`). Nothing on that road is fetched outside lzrprf.
See "A newer release".

Conditions: macOS enforces the containers (tested on your Mac, `[C2]`, `[C3]`, `[C11]`); the
`lzrprf` you run is the one in this repository (compare its SHA-256); and the keys pressed in the
bar are yours. A program on your Mac that you allowed to control your computer can type there
like you can.

### It can read a few facts about your computer, and has no way to deliver them

A fingerprint needs two things: reading what tells your computer apart, and delivering it. The
application can do the first in part. The second is what the container refuses.

- Code. From release 17 on the page program may load as code only itself and the system's
  own libraries (`/System`, `/usr/lib`): no other file, also not one in its own folder
  (`(deny file-map-executable)` and the line after it in `$CONTAINER`). `curl` in the fetch
  container is held to the same. `selftest` puts a file of code into the hostile
  application's own folder: outside every container it loads, in the page container it is
  refused, and with the refusal taken out it loads again (`lostcode`). Before release 17
  the profile held only the line that allows, and macOS refuses nothing there without a
  line that says no: the program could load as code any file it could read, which was the
  system's folders and its own app folder. It could write to none of them then, and cannot
  now. So the files of an app folder that no line `file` names (the icon, `Info.plist`, the
  `release` file itself, anything put into another folder of the app) are not compared with
  anything, and from release 17 on none of them can be run or loaded by the program.
- Reading. The page container lets it read every system value (`sysctl`) this macOS has under
  three prefixes, `hw.`, `machdep.cpu.` and `kern.osvariant` (prefixes, not a fixed list: the
  model of the computer, its processor, its memory, which variant of macOS this is and
  whatever else this macOS puts there),
  and single names under `kern.` (the version of macOS and of its kernel, a few fixed limits,
  where its own stack begins, whether the kernel is the secured one,
  whether it runs in a virtual machine, whether the system is shutting down), three about its
  own process (`sysctl.proc_`) and one under `vm.`, exactly as `$CONTAINER` names them; and the
  time, and the folder it is installed in. So it can tell the processor, the size of the
  memory, the version of macOS and whether it runs in a virtual machine. Not the computer's
  name, your account's variables, your files, the fonts you installed, your time zone, your
  screen, or other processes.
- Delivering. It has no way out by the ways its page container gives it. No network, no file
  to write, no shared memory by the ways the test tries, no second process, no window. The one thing that leaves it is the list of lines, and `sub checked` lets through
  only lines that cannot carry an address or a command `[C9]`. Until release 22 they could
  carry no picture either; from then on a laid page may hold pictures, as pixels that the
  window draws as they are, never as a file that is decoded. The application sends no picture
  pixels yet: every picture is a grey box. From release 20 on
  the list may begin with up to 120 lines that say what the page is made of. They are plain
  characters, shown as text in the pane under the page, and they are the application's own
  words as much as the text of the page is: what stands there is whatever it wrote. The true
  or false beside each of them is the application's word about itself, which lzrprf cannot
  check either. The window that draws
  them has no network `[C10]`. One exception: the window's process. An application
  whose text took that process over, by a flaw in how macOS draws text, would have the ways
  that process has, a fetch through lzrprf among them, logged first (see "The window's process"
  under "What it does not prove").
- What it read it can still use inside its own page: lay the page out differently, take
  longer, fail on purpose, or put the facts into the text it shows, which you could copy.
- lzrprf does not make one either. What a site is sent is `sub request`: the address, its host,
  one fixed browser name, `User-Agent: LZRBRWSR`, and two fixed lines `[C7]`. The name is that
  one word, with no version: the same from every computer and in every release (some sites
  answer a request that names no browser with nothing but a redirect, which is why it names
  one). No cookie, no language, no page you came from, no number of this computer or of this
  copy. Each request is a new `curl` that can write
  nothing, so nothing is kept for the next one.

- One thing is the application's choice and reaches its maker, and only after your click:
  whether it fails on a page at all. When it does, you are asked whether to send a report. A
  report says `page` for every failure of the application's own doing, and an application that
  ended by itself before macOS was asked about it counts as `page` too, so the application
  cannot choose among words (`sub fault`). It chooses no field of a report; by failing it
  chooses whether you are asked, and the word it brings about is `page`. Sending still needs
  your "Send" in the window. A report you send tells the maker that some page
  failed, on a Mac with your build of macOS, at that moment. So, though a report holds no
  address, the question and a report you then send carry a little from the program: that a
  page failed, at a moment it chose. It cannot choose the word. Never pressing "Send" closes
  this way. See "When a page
  cannot be shown".

The page container keeps the closed program from sending what it can read about this
computer. It does not make your Mac look like any other Mac. What a site does see: your
internet address, the time, the address you typed with its path and query, and how this
macOS and the system's `curl` open TLS and TCP. `selftest` compares the TLS opening bytes
between the requests of one run on your Mac. When they are the same the line says `held`; when they differ,
or the test site could not read them, it says `UNTESTED`, not `FAILED`, the mark of that run
names the check, and LZRBRWSR asks before it starts without it. Nothing here shows that
two Macs, or two builds of the system's `curl`, send the same opening bytes. What the code says
of them is only that the system's own `curl` makes them, with fixed switches (`sub fetch`).

Condition, and the one way around it: **you**. A page can show a text that asks you to type or
paste an address, and that address can carry whatever the application knows. lzrprf sends what
you type and writes it in the log first. It cannot judge an address for you.

### The application is given no way to keep anything between pages or to send anything

What it is given no way to do is keep a record of where you go, or send one; the bullets
below say how far that goes. What any request shows is
still seen: each site, your resolver and your network see your internet address and the time,
and a site can tie your requests together by that address, or by links it made unique to you.

Who could keep a record of where you go?

- The application: it is started fresh for each answer and sees that one page and its address.
  It is given no way to keep anything between pages (no file to write, no shared memory by the ways the test tries) and
  no way to send anything (the exception: "The window's process" under
  "What it does not prove"). That is said of the ways its container gives it and the test
  tries, not of every way a program could find: what it draws, how long it takes and whether
  it fails are its own to choose, and an application left behind after lzrprf and its keeper
  were both killed ("A page process left behind", below) lives on past its page.
- lzrprf: unless you chose otherwise, it keeps nothing of its own after the window closes:
  the lines are in the memory of the process behind the window, and gone with it; a log kept
  earlier stays until you clear it, and what macOS keeps is its own (see "What is kept"). A
  log you chose to keep is on your disk, readable by your account alone, hosts only unless you
  chose full addresses. Nothing in `lzrprf` sends the log or any part of it `[C12]`: the only
  place that connects to a site is `sub reach` `[C6]`.
- The maker of the application: receives nothing about where you go. The two fixed addresses
  are fetched only after your yes `[C4]`. The release check goes to a file in this public
  repository on GitHub, not to a server of the maker, with the same request from everyone `[C7]`. The
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
  Whatever lzrprf starts is handed three open files it chose and no other (`sub seal`):
  `selftest` keeps a file open under the number 19 and, from release 17 on, also under 700
  when the system lets it, and the hostile application looks at every number from 3 to 1023
  (before release 17, 3 to 255).
  They open no device but `/dev/null` and the two that give random numbers: the test opens
  a device of the terminals (`/dev/ptmx`), outside every container and inside. A file in your
  home folder is tried by three names: its path, its path through the data volume, and its
  number on the disk (`/.vol/…`), a name that holds no folder. They read no
  file in your temporary folder, which is outside the home folder: the test puts one there
  and reads it outside every container and inside. And a name in
  the program's own folder that points at a file in your home folder opens nothing in the
  page container: the rule goes by where the file is, not by the name it is opened by (the
  run `alias` of `selftest`, with the same link opened outside every container first).
- Shared objects. macOS does not refuse the creation of old "System V" memory, flags and queues
  inside a container, and the computer has only a few of them. `selftest` found that on
  2026-11-18; `$CONTAINER` now refuses the three calls `shmget`, `semget` and `msgget` by name,
  and the test makes each. Memory and flags with a name (`shm_open`, `sem_open`) are refused by
  the container's `deny default`, which no rule opens for them, and the test makes those too.
  From release 19 on the test also makes memory with a name itself, outside every container,
  and the hostile application asks to open it: opened outside, refused in the page and fetch
  containers, as the making is. The window container refuses neither.
  That is a test of these six ways, not a proof that no other way to share exists.
- Starving. A page container gets at most 30 seconds of processor time, counted over all
  processor cores together (`limit -t 30` in `$PAGE_LIMITS`); nothing limits how many threads
  it starts, and they share the 30 seconds. It is ended after 30 seconds of the clock
  whatever it does (`$PAGE_SECONDS`, looked at once a second, so up to about a second later),
  counted from when it is handed the answer, after macOS was asked about it for about two
  seconds at most. Before release 16, when the process that hands the answer over could not be
  started, the page process was left to end by itself; from release 16 on it is ended there
  (`sub laid_out`). It may write no byte into a file (`limit -f 0`; making a file is refused
  by the container) and leave no memory dump. It may write at most 12 MB,
  50000 lines and 2000 boxes, and no block of more than 20000 characters; more is not drawn
  (until release 20: 6 MB and 200000 lines, and a block of any length). From release 17 on the page program and
  `curl` may hold at most 256 open files (`limit -n 256` in `$PAGE_LIMITS` and
  `$FETCH_LIMITS`), set like the other limits. From release 17 on each limit is set twice,
  as the limit that counts now and as the limit that may not be raised again (`limit()` at
  the start of both). Before that a bare `ulimit` set them: the shell macOS uses as
  `/bin/sh` unless an administrator chose another sets both kinds that way, but one of the
  shells that can be chosen sets only the first, and there the program could have raised
  its limits again. The hostile application asks for more processor time and more memory
  too, in both containers, and a copy that sets only the first kind is noticed (`lostsoft`). The hostile application asks the system for a
  limit of 300, in both containers, where it must be refused, and outside, where it must be
  given; the run `lostfiles` takes the limit out of the page container, and the limit on
  `curl` has no such copy. Where lzrprf was itself started with a limit below 256 that no
  process may raise, that lower limit stands (before this was written so, such a start
  failed). `sub holds` does not try it at each start:
  it still tries seven things.
- The end of lzrprf. From release 17 on each page has a second process of lzrprf's own, its
  keeper (`sub keeper`), started in `sub laid_out` right after the application and before
  macOS is asked about it. It waits for lzrprf's word that macOS called the application
  contained, hands the site's answer over, and all the while waits for one thing: the end of lzrprf.
  It reads a pipe whose other end only lzrprf holds, so when lzrprf ends in any way, also when
  it is killed, the keeper ends the application at once, and then itself. `selftest` kills
  lzrprf while the application sleeps, and the application is ended (`killed`); with the
  keeper's line taken out the application goes on, so the test would notice (`leftkilled`).
  Release 16 and earlier left a page process running when lzrprf was killed. What remains:
  if the keeper itself is killed by another program of your account, nothing ends the
  application when lzrprf is killed later. The keeper is started right after the
  application, so an lzrprf killed in the instant between the two leaves that one
  application without a keeper. And after lzrprf's end the keeper acts on the application's
  process number: if the application ended in that same instant and the system gave its
  number to a new process of your account, that process is the one ended. And `curl` in the
  fetch container has no keeper:
  it ends by its own limit of 30 seconds, or when lzrprf's socket closes.
- Memory. The same `/bin/sh` (`$PAGE_LIMITS`) sets, before the container starts, the system's
  own limit on address space (`limit -v`) to what that shell itself holds (`ps -o vsz=`) plus
  2 GiB. What the application holds at its own start is not measured, so its real room is
  about 2 GiB, a little more or less. macOS enforces the limit: a request beyond it is refused
  by the system. If a limit cannot be set, nothing is started. `selftest` asks for 3 GiB in
  the page container, where it must be refused, and outside every container, where it must be
  given. The limit counts address space, not memory in use: an application that reserves much
  more than it uses (a large engine does) would need a larger `$PAGE_ROOM`, and with too small
  a one it shows no page.
  The system's `curl` in the fetch container is started under the same limit on memory, and
  from release 15 also with at most 30 seconds of processor time, no byte written into a file
  and no memory dump (`$FETCH_LIMITS`); the test asks for the 3 GiB there too. From release
  16 on `curl` is started through `env -i` as the application is, so it sees no variable at
  all, not one the shell that sets its limits made for itself (`PWD`, `SHLVL`, `_`); in
  `curl`'s place the test's program lists what it is given, and the list must be empty.
  The window's process (the system's `osascript`) has no limit on memory or processor time,
  and neither has lzrprf's own process or any process it starts outside the page and fetch
  containers (the keeper, the name lookup, `route`, `xattr`, `sysctl`, the `osascript` that
  asks macOS, `open`, `selftest`): only `$PAGE_LIMITS` and `$FETCH_LIMITS` set limits.
  From release 21 on what the window's process is given to set is bounded (point 8 of "How
  it works": the size of a list and of a block, and the two changes in a text). That bounds
  the work one page was measured to make it do; it is no limit on the process itself.

Limit, said plainly: within those limits a hostile application can still load this computer,
each time you ask for a page: about 2 GiB of address space, as the system counts it, and every
processor core until its 30 seconds of processor time are used. Then it is ended. Memory the
kernel holds for a process (what is in its pipes, and in messages it sends to itself) is not
counted in that limit; it is bounded only by the 30 seconds, after which the process and what
was held for it are gone. No probe of the test tries that. And a flaw in macOS itself, in its
kernel or its sandbox, is outside what lzrprf can refuse.

### It cannot read or change your files

The page and fetch containers may read the system's own folders and the application's own
folder, and write nothing. `selftest` puts a secret in your home folder and tries to read it,
to learn that it exists, to list the folder, and to reach it by its other path through the data
volume and by its number on the disk (`/.vol/…`). It tries to read and change the log, the setting of what is kept (`~/.lzrprf/keep`)
and `lzrprf` itself, and to put a setting of its own in its place. Each is refused.

### Is its safety mathematically proven?

No. See "What "proof" means here". It rests on parts nobody has proven: the macOS kernel and
its sandbox, the system's `perl`, `curl` and `osascript`. What this repository gives instead is
short enough to read, probed on your own Mac, and probed again whenever macOS changes.

## Tabs, the home page, bookmarks, search, the lock, redirects

All of this is drawn by lzrprf's window, in strips of its own above the page where no page
draws: the strip of tabs on top, then back, forward and reload, the bar with its lock and star,
and the cogwheel, then the bookmarks bar when you chose to show it. The look is lzrprf's too,
the neon laser: near black glass inside a thin glowing cyan edge, straight beams of light, light
grey line icons and the system's own face, the logo set wide. It is drawn on the processor by
the window alone, and nothing in it comes from a page.

- **Tabs.** Each tab keeps its own page as lzrprf keeps the page shown: its address, the
  answer, the style sheets it was laid out with and its pictures, its title, the addresses it
  went to and lzrprf's last words in it (`sub tabbed`). Choosing a tab lays its kept page out
  again at the window's width (`sub relaid`): nothing is fetched and nothing is written in the
  log. At most 32 tabs; closing the last leaves one empty tab. Cmd-T opens a tab, Cmd-W closes
  one. A tab's title is the page's `=title` line, checked `[C9]`.
- **The home page.** The cogwheel's "Make current page the home page" keeps the address of the
  tab in one plain file of yours, `~/.lzrprf/home`, one line (`sub menu`, `sub home`). A new
  tab and each new window open it, as if it had been typed: its line is in the log first `[C4]`
  `[C5]`. A link at that name, a file that is not yours or a line that is no address lzrprf
  fetches opens nothing.
- **Bookmarks.** The star opens lzrprf's own modal: Name, Address, Folder, New folder. A
  bookmark is one plain file in `~/.lzrprf/bookmarks`, a folder of yours, `NAME.mark` with
  two lines, its name and its address; a folder of bookmarks is a real folder, at most 4 deep,
  each name letters, digits, space, dot, underscore and hyphen, not beginning with a dot or a
  space; at most 1000 are read (`sub marks_read`, `sub mark_saved`). A link, a file that is not
  yours and an address lzrprf does not fetch are passed over; a bookmarks folder that is a link
  is not read and nothing is written through it. The star of a page you bookmarked opens the
  same modal to change it or Remove it. Opening a bookmark is a visit like a typed one `[C4]`.
  The cogwheel's "Show bookmarks bar" is kept in `~/.lzrprf/marksbar`. The bar shows one folder,
  `Bookmarks bar` (Chrome's name for it), which the star's modal offers first; the first time the
  folder is read without it, the bookmarks at its top, which the bar showed until then, move into it
  by a change of name each (`sub marks_into_bar`).
  A folder's order is
  kept in a file `.order` in it, its names one a line (`sub order_set`): the window shows every
  folder in that order, everywhere (the bar, the folder menus, the bookmarks page), and a new
  bookmark is added at the end. What is in a folder and not named in it comes after, by name.
- **Importing bookmarks.** The cogwheel's "Import bookmarks..." opens one modal with steps,
  Back and Next. First the source: Chrome, Edge, Brave, Firefox, Safari, Vivaldi, or "A
  bookmarks file (HTML)"; a browser that is not on this Mac is shown greyed, "Not found". Then
  the profile, by the names in Chromium's `Local State` or Firefox's `profiles.ini`; then what
  Import would add (N bookmarks in M folders, K in the bar, what is skipped and what is left
  out, and why); then Import, and a last screen of what was written. lzrprf reads the files
  itself, never the window, and starts no program for it `[C15]`: Chromium's `Bookmarks` JSON
  with the JSON code that comes with the system's perl, Firefox's newest
  `bookmarkbackups/*.jsonlz4` with an LZ4 block decoder of its own (`sub lz4_block`, at most
  64 MiB unpacked), Safari's binary `Bookmarks.plist` with a reader of its own
  (`sub plist_binary`), and an exported HTML file (`sub import_html`). Firefox's
  `places.sqlite` would need `sqlite3` and is not read: its own backups hold the same
  bookmarks. `plutil` is not used either. macOS gives Safari's file only to a program you
  granted Full Disk Access: when it refuses, the wizard says so and tells you to export the
  bookmarks from Safari and choose the HTML file. The window cannot show a file picker: its
  container answers only the clipboard service and reads nothing under your home folder
  `[C10]`, so the HTML step offers the bookmarks files lzrprf finds in Downloads, Desktop and
  Documents, and takes a path you type in your home folder. The source's bookmarks bar goes into
  "Bookmarks bar", folders and all, after what it holds; the rest into a new folder "Imported
  from" and the browser's name; each folder in the source's order, bookmarks and folders mixed,
  kept in its `.order`. Each bookmark gets the checks one you add gets: its name through
  `sub plain_name`, its address through `sub address` (one lzrprf does not fetch is skipped and
  counted), at most 1000 in all and folders at most 4 deep (what is beyond is left out and
  counted), each written by `sub mark_written` (`sub import_plan`, `sub import_go`). Nothing
  imported is fetched `[C4]`.
- **Address suggestions.** While you type in the bar, a list under it suggests pages shown in
  this window and your bookmarks: the start of a host first, then the start of a title or of a
  word in it, then anything that contains what you typed, at most 8 (`function suggested` in
  the window). The arrow keys move, Return or a click opens, Escape closes. The pages come from
  lzrprf as they are shown (`history add`), held in the window's memory only, at most 500, and
  cleared with "Clear browsing history": nothing of them is written to the disk. Opening one is
  a visit like a typed address `[C4]`.
- **The bottom bar.** At its right end two line icons: the log, and what the page is made of.
  The second opens, in a panel of its own over the page, the list the application gave of what
  the page is made of, each thing with its version and whether the application says it
  supports it, under the sentence that lzrprf checked the form of that list and not whether it
  is true.
- **Clearing.** "Clear browsing history" empties the addresses the tabs went to; the log is
  cleared by its own button and by nothing else. Clearing the sessions also drops every page
  lzrprf keeps for a tab. lzrprf sends no cookie and keeps none `[C7]`, so no login was kept by
  it either way.
- **Redirects.** An answer 301, 302, 303, 307 or 308 is never laid out and never followed by
  `curl` `[C7]`. lzrprf reads its `Location` itself, in plain characters only, resolves it
  against the address, and asks in its own modal, with the status, both addresses and Cancel
  first (`sub redirected`, `sub asked`). Proceed is a new visit, with every check of a typed
  address and its line in the log first. An address lzrprf does not fetch (plain http, a host
  that is a bare number, another port) gets Cancel alone, and the modal says why in plain words
  (`sub unfit`). A page opened from a bookmark gets a third button, "Proceed and update
  bookmark". One redirect a visit is followed without asking: to the same https address with
  `www.` put in front of its host or taken off, the same path and query, written in the log as
  one line first (`example.com redirected to www.example.com (301); followed, the same site`).
- **Undo.** The bar and the modal's fields undo and redo typing step by step: Cmd-Z and
  Cmd-Shift-Z, in an Edit menu that also cuts, copies, pastes and selects all.
- **Back, forward, reload.** The arrows left of the bar, and Cmd-[, Cmd-] and Cmd-R, walk the
  addresses the tab went to (`sub navigated`). Each step is a new visit to that address, with
  every check of a typed one and its line in the log first (`you went back to`, `you reloaded`)
  `[C4]`: lzrprf keeps no copy of an earlier page to show instead. A redirect followed on the way
  takes the place of the address it came from, so back does not land on it again.
- **The home screen.** An empty tab shows the logo, LZRBRWSR over BROWSE WITH ZERO TRUST, and
  four buttons: search, bookmarks, the open tabs, and a new tab. Nothing on it is fetched.
- **Search.** Words typed into the bar that are no address (no `://`, and a space or no dot)
  go to the search engine you chose: Brave, DuckDuckGo, Google, or one of your own (`sub typed`).
  Nothing is sent before you choose: the first search, and the home screen's search button,
  ask in lzrprf's modal. A search engine of your own is given as an address with `%s` once where
  your words go, for example `https://search.example.com/search?q=%s`; it must be https, a host
  by its name, port 443, plain characters without a space, and lzrprf percent-encodes your words
  into it (`sub engine_fit`). The choice is one line in one plain file of yours,
  `~/.lzrprf/search`; the cogwheel's "Search engine..." changes it. A search is a visit like a
  typed address, written in the log first as `you searched with` `[C4]`.
- **The cogwheel's menu.** A panel of the window's own glass, opened under the cogwheel inside the
  window, each item with the keys that do it too; a press outside it closes it and reaches nothing.
- **Keys.** Chrome's keys for what LZRBRWSR has: Cmd-L, Cmd-[, Cmd-], Cmd-R, Cmd-T, Cmd-W, Cmd-D
  (bookmark the page), Cmd-Shift-B (the bookmarks bar), Cmd-Option-B (the bookmarks page),
  Cmd-Shift-Delete (clear history), Cmd-Comma (the cogwheel's menu), Cmd-1 to Cmd-8 and Cmd-9
  (a tab, the last tab), Ctrl-Tab and Ctrl-Shift-Tab, Cmd-Option-Right and Left (the next and the
  previous tab), Cmd-Shift-A (the tabs page). Each does what its button does, and only then.
- **The bookmarks page.** The cogwheel's "Bookmarks", the home screen's button and Cmd-Option-B
  list every bookmark by folder; the back arrow returns to the page.
- **The lock.** Pointing at the lock in the bar, or pressing it to keep it open, shows what
  lzrprf knows of the page shown (`sub secured`): the address, the server's IP address it
  connected to, the encryption, the answer's status line, that no cookie was sent or kept, every
  redirect on the way here and who followed it, and each certificate the server presented (up to
  6): subject, issuer, valid from and until, serial number, signature, public key and the names
  it covers. The certificates are as `curl` read them in the same connection that fetched the
  page; nothing is fetched to show them.

## What is kept

The principle: every outgoing network request must be observable by you, but no browsing
activity should be permanently retained without your explicit consent.

So every line of the log is kept in the memory of the process behind the window
(`sub record`), after it was written to the disk when a log is kept, and the Log button shows
it. What stays on this computer after the window
closes is your choice, held in the plain file `~/.lzrprf/keep` (`sub keeping`) `[C12]`:

| mode | what the Log button shows | what stays on this computer |
| --- | --- | --- |
| `nothing`, when nobody chose | this window's lines | nothing lzrprf writes: no file of lzrprf's holds an address you typed. A log kept earlier stays until you clear it, and what macOS keeps on its own is in the limits below |
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
  still reach the system's swap, a crash report of that process, the resolver's cache of
  names, a snapshot of the disk or a backup: those are macOS's, outside lzrprf, and lzrprf
  cannot prevent them.
- Besides the log, `~/.lzrprf` holds what you chose to keep there: `home` (the one address you
  made the home page), the folder `bookmarks` (one file a bookmark, a name and an address, and a file `.order` in each folder),
  `marksbar` (whether the bookmarks bar is shown), and after "Install it" the folder
  `install.NUMBER` with the installer it fetched and `install.txt`, every line an installer
  printed, appended. It also holds files lzrprf needs to work, none with an address you typed:
  `keep` (what is kept), `look` (your answer about newer releases), `welcomed` (the number of
  the last release whose welcome you closed, and nothing else), `proven` (the mark of
  `[C11]`), `untested` (your yes to starting without the checks a test could not try, as the
  line of the mark you said it to), `selftest.txt` (the last test's report), `selftest.lock`, from an installer's questions until its files are placed
  its lock (the link `.installing`), and while a window is
  open the lock files `lock`, `keep.lock` and `busy`, the folder `tries.NUMBER` of the tries at
  the start, and the socket `way.NUMBER` of a request.
- Hosts and times alone still show habits: which sites, when, and how often. That is why even
  `hosts` needs your yes.
- That Time Machine honours the mark is Apple's behaviour, and it is not tested here. The mark
  is a request to backup programs; another backup program may not read it.
- Old lines are taken out only while lzrprf runs (`sub expire_log`, at the start of a window;
  when another window's request kept it from that, again before each request and each press
  of Log until it is done). Nothing runs by itself to do it: while LZRBRWSR is not started, no line
  is taken out.
- Clearing and taking out old lines remove them from the file: a new file takes the log's name,
  or the log is removed. The places on the disk where the old lines stood are not overwritten,
  and a snapshot or a backup made before still holds them.
- What macOS itself keeps is outside lzrprf: its cache of names that were looked up, crash
  reports, and the memory it writes to swap.
- A window process that text took over could press the buttons that keep less and the two that
  clear the log, as it could press any button (see "What it does not prove"). It could remove
  the record on this computer. It could not make lzrprf keep more.

## An incognito window

`lzrprf incognito`, or "New Incognito Window" (Shift-Command-N) in the app menu or the cog
menu, opens a second window of its own whose whole state lives in one folder that is removed
when it ends `[C16]`. It is told apart at a glance: it glows violet instead of cyan, the word
"Incognito" and a mask stand left of the address, and its new tab page says what it keeps and
what it does not.

Where its state lives. `sub incognito_begun` makes a folder `lzrprf-i.<pid>.<12 hex>` with mode
0700 in your own temporary folder: `TMPDIR` when it is a folder of yours that nobody else can
read, else yours under `/private/var/folders/.../T` (`sub temp_folder`). The log of the window,
its tabs, its history and every answer are in the memory of the process behind the window or in
that folder; a search engine chosen there and the bookmarks bar shown or hidden there are held in
memory for that window only.

What it reads from `~/.lzrprf`, read only, and why each: `proven`, `untested` and `selftest.lock`
(no page is shown before the self-test held `[C11]`; an incognito window never runs the test,
because the test writes its result, and says to open a normal window once instead); `home` (the
home page opens); `search` (searches go where you chose); `marksbar` (the bar as you keep it);
`bookmarks` (your bookmarks open). Everything else of a normal window is not read, and nothing
is written there: the star, the bookmark modal, the import wizard and "make this the home page"
are refused with "An incognito window writes nothing", shown greyed out with that tooltip.

Every way out removes the folder. The process behind the window removes it in `sub leave`
whether the window was quit, its last window closed, Command-Q pressed or the window's process
ended; it does the same on SIGINT, SIGTERM, SIGHUP and SIGQUIT. A third process, the sweeper,
started in its own session and deaf to those signals, waits until the window's process is gone
and the process behind it has let go of the lock on `held`, then removes the folder too. Only
`kill -9` of all three at once (a crash, a power cut) leaves it; `sub swept`, at every start of
any lzrprf window, removes every `lzrprf-i.*` folder of yours whose window process is gone.
`sub removed` removes nothing whose name is not exactly that form.

What macOS could keep, and what was checked:

- Saved application state (the windows macOS reopens at login, under
  `~/Library/Saved Application State`). The window's container refuses every file write, so
  `osascript` cannot write it; on top of that an incognito window registers, in memory only,
  `NSQuitAlwaysKeepsWindows` false and `ApplePersistenceIgnoreState` true, and sets its window's
  `restorable` to false. Checked on the development Mac on 2026-11-20 after incognito windows were
  run off the screen: that folder holds nothing for `osascript`, `perl` or lzrprf, and
  `~/Library/Caches` and `~/Library/Preferences` hold no `com.apple.osascript` entry.
- Recent documents. The window opens no document and has no `NSDocumentController`, so it adds
  nothing to the recent items list. The list's own folder
  (`~/Library/Application Support/com.apple.sharedfilelist`) is closed to a terminal by macOS
  privacy settings, so that it is unchanged was not read directly.
- Temporary files. The page container writes no file at all `[C10]`, the window's container none,
  and the process behind the window writes into the incognito folder only. `selftest` run
  `incognito` checks that afterwards no `lzrprf-i.<its pid>.*` is left in the temporary folder
  and that every file of the run's lzrprf folder is byte for byte what it was.
- What it does not cover: what sites see (your internet address and what you send them), and the
  macOS unified log, which records process starts and sandbox refusals as for any program.

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
| installing a newer release | "Install it": it runs at once, in lzrprf's window, by itself | the window (`sub newer`, `sub installed`) | press "Install it" when a newer release is published. lzrprf then fetches the installer from the addresses the release names, from both places, and runs it only when the two copies are the same: the most a press can do is install the release the maker published |
| the home page and bookmarks | an address kept on the disk, opened at each start, in each new tab, or with a click | the cogwheel's menu and the star's modal (`sub menu`, `sub mark_saved`) | keep an address it said, as if from the bar or the modal, and open it. Each opening is a line before it is fetched `[C5]` |
| following a redirect | Proceed: a new request to the address the site named | lzrprf's modal over the window (`sub visit`, `sub asked`) | press Proceed while the question is open. The new address gets every check of a typed one, and a line before it is fetched |
| a report after a failure | "Send": the maker's server sees your internet address and three values | the window, when a page was not shown (`sub fault`) | say that a page it was handed could not be drawn, once for each page (`sub behind`), and press "Send" to the question that follows: the three values, written in the log first |

Only the first row can be closed entirely, and it is: nothing in the window keeps more. In the
other rows the window is where you answer, so a taken-over window process could answer too.
Installing takes nothing from the window but the press: what is fetched and run comes from the
fixed addresses of the release file and nothing the window says, and the window's process
commands no other program `[C10]`. What holds in the other rows is `[C5]`: nothing leaves this computer before its line exists, and with
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
  holds one number. It is sent like any address you type, the same request from every computer
  `[C7]`, so the request does not say who you are or which release you run (your internet
  address, and how this Mac speaks TLS, are outside the request); GitHub still sees
  what any site sees (below). It is in the log like every
  other request `[C5]`.
- The address is on GitHub, not on a server of the application's maker. The maker's server
  sees no request at all. GitHub sees your internet address and the time, at each start.
- The first start of a release shows a welcome once (`sub welcome`): what is new in it, from
  the release file's lines `new`, and two short groups, what the application keeps you from
  and what it cannot keep you from, which stays yours to watch: what you type into a site, what
  a site does with it on its own servers, fake sites, what you take into another program, and
  your internet address. Got it writes the release number to `welcomed`; nothing is fetched.
- When the number is larger than yours, the window says so and offers the installer. lzrprf
  replaces nothing itself, not the application and not itself. "Install it" is the yes, and no
  key is pressed after it (`sub installed`).
- lzrprf fetches the installer itself, like any request: its line in the log first `[C5]`,
  through `sub fetch` `[C6]`, by a contained `curl` that follows no redirect `[C3]` `[C7]`. When
  the release names a second place (the line `same`; the release on record here does), it
  fetches that copy too and goes on only when the two are the same byte for byte. While a
  release is being published one place can keep its old copy for a few minutes, so when the two
  differ both are fetched again every 30 seconds, twelve times in all, each try a line in the
  window; a copy that differs is never run, and after the twelfth the install fails. A `same` line
  that is there and is no address counts as one that does not agree, and nothing is fetched.
  An address is handed to `curl` as one argument and to no shell, so a quote in it is a
  character like any other.
- It writes the installer into `~/.lzrprf/install.NUMBER/install.sh`, a file only you can read,
  shows that file and its SHA-256 in the window, and writes both in the log, before it runs it.
- It runs it there, outside every container, as `/bin/sh install.sh auto`, through `env -i`
  with only the system's `PATH`, your home folder and `TERM=dumb`: no variable of your shell.
  Nothing is piped into a shell. Every line the installer prints is shown in a modal of
  lzrprf's own over the window, where no page draws, and appended to `~/.lzrprf/install.txt`.
  A colour it asks for becomes one letter the window draws in, and every escape and control
  character is taken out first (`sub install_line`), so nothing it prints acts on the window.
  After 30 minutes it is ended. At the end the modal says done or failed; after done, lzrprf
  takes nothing more in that window, which offers Close, and Close and restart. Restart starts
  the application again once this run has ended: a process of its own waits until lzrprf and
  the launcher are gone, then asks macOS to open the application at the place it ran from,
  which the installer has replaced (`sub restarted`). This is the one moment on this road when the maker's site is asked for anything:
  it sees your internet address then, as GitHub does.
- The installer, in auto, shows no question and leaves the Dock alone on an update, refuses to put an older
  release over a newer one, and says so when the release would replace `lzrprf` itself. Run by
  hand (`sh install.sh`), each question takes y (yes, and the next is asked), n (no), or a
  (auto: yes to it and to every one after it). It takes no test setting
  from a variable of your shell unless every file comes from this computer (see "The
  installer"), so a variable cannot point this road elsewhere.

Where the addresses come from: a plain file, `release`, beside the application
(`LZRBRWSR.app/Contents/Resources/release`), read by `sub beside` and `sub paired`. It may
hold seven kinds of line and nothing else counts: `release` (a number), `newest` (where the
number is published), `installer` and `same` (the two places of the installer), `report` (see
the next section), `lzrprf` (the SHA-256 of the lzrprf the release installs; an lzrprf of
release 12 or later compares it with itself at every start, and from release 15 an app whose
`release` file has no such line does not start either) and `file` (a name and the SHA-256
of a file in the folder of the program; the installer writes two, for the launcher and for
the program; an lzrprf of release 16 or later compares each with the file that is there at
every start, from release 17 on stops at a file beside the program that no line names and
reads the program again before every page, and the installer compares each line with what it
unpacked before it puts anything in place).
Each address must pass `sub address`, the same check as an address you type. lzrprf hands each
installer address to `curl` as one argument and to no shell, so a character that would end a
quote is a character like any other; `selftest` tries exactly that. A `same` line that is there
but is no address does not turn the comparison off: nothing is fetched. The installer compares the `release` file byte for byte with the text written out in
the installer, and `release.txt` holds its SHA-256, so what your copy names is what is on record
here:

    release 49
    new Each panel of the bottom bar flies out of its icon when it opens and back into it when it closes
    newest https://raw.githubusercontent.com/lzrbrwsr/lzrprf/main/latest
    installer https://raw.githubusercontent.com/lzrbrwsr/lzrprf/main/install.sh
    same https://lzrbrwsr.com/install.sh
    report https://origin.lzrbrwsr.com/report
    file lzrbrwsr 604a5cf1225c06b9beb01f80bd01d81645855dd3d63fc16a78b5e91198966eb1
    file lzrbrwsr-bin e42a8ff18ec666e7a758ccbd290789a346c6fbc9e44f698ff9e3c4470828b67a
    lzrprf 52bbc1948422b3501f9d408c7f0bb6fd2c25de49167fdaa11b3b95eea1d202b2

## When a page cannot be shown

When the application did not give a page, the window says one of eight fixed phrases (`%FAULT`
in `lzrprf`; the eighth, from release 17 on, says that the program on the disk changed under
an open window, and it offers no report: nothing of the application ran). For the other seven,
if the release names an address for reports, you are asked whether to send one,
with two buttons, and shown the whole address first (`sub fault`). A report holds three values:
one of two words, the number of the release, the build of macOS. Not the address you typed, and
nothing of the page. It is not anonymous to the network: like any request, it shows the
receiving server your internet address and the time. It is sent only after "Send", the way a typed address is `[C7]`, and
written in the log first `[C5]`. The first button is "Don't send", and a question nobody
answers counts as that one. When the line that says how the report ended cannot be written to
the log, the window says that the report was tried, not that it could not be sent.

Seven phrases that can lead to a report, and only two words. Five of the seven are the
application's own doing: it ended
before it was given the page, it was late, it wrote too much, it wrote something that is no
page, or it wrote what the window could not draw. An application that could choose among five
words could tell its maker a little of what it had just read. So the report says `page` for
all five, and `container` for the two that lzrprf and macOS decide: the container could not be
started, or macOS did not say of a process still running that it was contained
(`sub laid_out`). An application that ends by itself before macOS was asked about it counts as
`page`, so it cannot pick `container` by ending early. One thing stays the application's choice and cannot be taken from it:
whether it fails at all, and so when. A report you send therefore tells the maker that some
page failed on your Mac at that moment, and not which. The report holds no address, but the
question appearing, and a report you then send, carry a little information from the
program: that a page failed, at a moment it chose. It cannot choose the word. Never pressing
"Send" closes this way.

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

- **The program started by another hand.** lzrprf holds the closed program when lzrprf
  starts it `[C1]`. Nothing that is installed starts it another way: the launcher is one
  command that you can print ("Check it yourself"), and it starts `lzrprf run`. But
  `lzrbrwsr-bin` is a file like any other: you, or another program of your account, can start
  it straight, and then it runs with no container. See "Your account".
- **What you are told to type.** A hostile application cannot send anything by the ways its
  container gives it (the exception is "The window's process" below), but it can show a
  text that asks you to type an address that carries a secret. See "It can read a few facts
  about your computer".
- **What you are shown.** The application decides what the page says. It can show a page
  falsely. It cannot change the bar, the buttons, the log or the title. Of the words under
  the bar and of the questions it can choose only up to four host names and their count (see
  "No request you did not ask for"), and which of five fixed phrases says why a page was not
  shown, which the question about a report repeats: the rest are lzrprf's,
  and the bar shows the address lzrprf made of what you typed and asked for (`sub address`),
  whether or not an answer came.
- **The window's process.** It draws text the application chose, with macOS's own text drawing.
  This is the weakest point, so it is said in full. If such text could take over that process,
  the process has no network of its own, writes no file, starts no other program, opens nothing through
  the system, commands no other program, sends no signal to another process, and reads nothing under `/Users` or on another disk
  but settings, fonts, keyboard layouts and input methods `[C10]`, by the data volume's name of those
  folders too (`/System/Volumes/Data/Users/...`); `selftest` also tries the file by its number
  on the disk (`/.vol/...`). What it could still do:
  - say to lzrprf what the window says (`sub hear`): "go ADDRESS" as if you had typed it, a
    press of either button of the question that is open ("Send", "Yes, look", "Install it",
    "Clear the log" and the buttons that keep less among them), or a request for the
    log. Each of these that fetches is in the log before it has an effect outside your Mac,
    and "Install it" runs the installer of the published release, the same from both places,
    in lzrprf's own modal. A
    press cannot make lzrprf keep more: the buttons that change what is kept only keep less
    (`sub choose_keeping`), and the change is a line of the log (`sub changed`). Two presses
    clear the log on this computer: a kept log then says so in its first line, and with
    nothing kept no log is left and only that window's lines say so. lzrprf has no way of its
    own to tell such a line from your Return or your click: the log shows it as typed or
    pressed;
  - say that a page it was handed could not be drawn. That opens the question about a report,
    once for each page (`sub behind`), and "Send" is one of the presses above;
  - look up by name 41 of the system's services (Mach services) and one local name, the
    clipboard's. It could read what you copied, and put text on the clipboard, which other
    programs read and which macOS may carry to your other devices (Universal Clipboard). The
    one way out that lzrprf itself gives it is an address it asks lzrprf to fetch, which is
    logged first. From release 19 on its container refuses the lookup by name of every
    other service (`(deny mach-lookup)` and the list after it in `$WINDOW_CONTAINER`).
    The 41 are services a window's process was seen to ask for on macOS build 26B123;
    that each is needed was not tested, except the graphics shader compiler, added in
    release 34: the system draws a window's pictures on the graphics card and has the
    compiler teach it each new way of drawing one, and without it the system ended the
    window the moment a tile, a scaled picture or a full-screen window needed one.
    `selftest` compiles a shader from inside the container (`shaders`). One more that a window asks for, the helper of the
    Services menu, is left off the list and so refused, because it lets another
    application act on what the window hands it. macOS is asked at every start whether the
    container refuses a system service by default; that question names no service, so it
    says nothing about the list. From the real window `selftest` asks for six by name: the
    clipboard is answered, and the system's downloader, the keeper of certificates, the
    network's settings, the resolver of names and the watcher of files are refused. A copy
    without the refusal and without that question is answered as a program outside every
    container is (`openservices`), a copy with the refusal alone taken out shows no page
    (`lostservices`), and a copy whose list names the downloader too is caught by the same
    try (`widerservices`). Before release 19 the container refused one service, the
    system's downloader, and allowed every other.
    What this does not cover: a connection that a listed service hands back, a port the
    process was started with, and the drivers of devices (IOKit) are not lookups by name.
    And each of the 41 is a program of macOS that the window's process may talk to. Four
    kinds of them, named because nothing here tests what they would do for a window that
    was taken over: launch services (three names) keep the list of which application opens
    which kind of address; the keepers of input methods (four names) hand out connections
    to other processes; the system's log and its notifications (six names) take what the
    process writes, the log keeps it on disk, and a notification reaches any program of
    yours that listens; sound, the window server and the keeper of privacy permissions
    answer by macOS's own permissions, which this container neither adds to nor takes
    away. Nothing here proves that none of the 41 is another way out. In the one run of a
    window on screen that was made with this list (with the Services helper still on it),
    the window asked for more, the graphics shader compiler among it, and was refused: it
    still drew and took typing then, but from release 31 on its pictures needed a shader
    that was not ready, and the system ended the window; the compiler is listed since
    release 34. Where a window asks
    for a service that is not on the list, that service is refused, the window may then
    not work, and the container holds as before;
  - make shared memory, open devices and reach their drivers (IOKit): the window's container (`allow default`) does not
    deny these. A signal to another process it does deny (`(deny signal)`, with a signal to
    itself allowed): macOS is asked about that at every start, and from the real window
    `selftest` asks to send one to its own process (signal 0, which delivers nothing) and
    sees it refused;
  - read the four folders it is allowed (your settings, fonts, keyboard layouts and input
    methods), and what any program of yours can read outside `/Users` and other disks. From
    release 18 on `selftest` puts a file of its own among your settings
    (`~/Library/Preferences`) and shows the difference: read outside every container, refused
    in the page and fetch containers, and what the real window's process got is printed in
    its line (`settings=read`, while macOS allows it what the container allows). The run that
    made that file removes it; a run killed outright leaves it there, one line long, as
    `lzrprf-selftest.NUMBER`;
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
- **What the site learns.** Your internet address, the time, the address you typed with its
  path and query, and how this macOS and the system's `curl` speak TLS and TCP. lzrprf keeps
  the closed program from sending what it reads; it does not make your Mac look like any other
  Mac. The name lookup is seen by your resolver.
- **The parts lzrprf stands on.** The macOS kernel and its sandbox, and the system's `perl`,
  `sh`, `env`, `ps`, `curl` with its TLS library and list of authorities, `route`, `sysctl`,
  `open`, `xattr` and `osascript`. A flaw in one of these is a flaw here. A flaw in `curl` can reach one place
  only: the connection lzrprf made for the address you typed (`selftest` puts the hostile
  application in curl's place). A `curl` taken over by a site's answer could send that one host
  other bytes than the fixed request, through that one connection, within the 64 KB and the 30
  seconds a fetch carries (`sub fetch`): lzrprf does not read inside the encryption `[C7]`.
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
  nothing appears. There is no second road that runs it without the container in lzrprf itself; a start by another hand is under "What it does not prove". LZRBRWSR then does not work on that build until a
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
  can still load this computer, with as many threads as it starts. The window's process and
  lzrprf itself have no limit on memory or processor time. A flaw in macOS
  itself is outside what lzrprf can refuse. See "It cannot reach other applications".
- **What is kept, and where else it can go.** The lines of a window that keeps nothing are in
  memory, which the system can write to its swap or into a crash report. A log of hosts still
  shows habits. Time Machine's honouring of the mark is Apple's. See "What is kept".
- **Time.** How long a page container runs is the application's choice, up to 30 seconds after
  it is handed the answer, and about a second more. The
  request is over before the application sees the answer, so it cannot shape a request by it.
- **A question left open.** A question in the window that is still open after 10 minutes counts
  as answered with its first button. A window closed while it asks ends lzrprf: nothing is
  fetched or sent. The first button never fetches or sends anything, never
  replaces the application or the log, and never keeps more. Two such answers are written
  down: a "No" to looking for newer releases, like a no you pressed (delete `~/.lzrprf/look` to
  be asked again), and, after you pressed "Keep less", "Keep nothing", or after "Keep a log"
  from full addresses, "Hosts only".
- **Lines the test could not try.** An `UNTESTED` line does not stop an install. There are four
  such lines in `selftest`. Two depend on the network of the moment: whether `curl` opens
  its encryption with the same bytes each time, and how this Mac would send to an address on
  the internet. Neither is about what holds the program, and a Mac that is offline would
  otherwise never be allowed to show a page. The third, from release 17 on, is about the
  container: when the test was itself started with a limit below 300 open files that no
  process may raise, a try at 300 is refused with or without a container, so the limit of
  256 cannot be shown there. A Terminal as macOS sets it up has no such limit. The fourth,
  also from release 17 on, comes when this macOS holds no file of code for its perl that
  the test could copy into the hostile application's folder: then the refusal to load one
  cannot be shown. So a run whose other lines held still writes the
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
- **A page process left behind.** From release 17 on, when lzrprf is ended by force while a
  page is laid out, the page's keeper ends the application at once (`sub keeper`). If another
  program of your account killed the keeper first, nothing ends the application when lzrprf
  is killed later, and the same holds when both are killed at once: it stays in its container,
  with no network and no file of yours, until it ends, uses up its processor time, or you log
  out. Processor time is counted only while a program computes, so one that sleeps is not
  ended by that limit. Two smaller moments are named under
  "The end of lzrprf". `curl` has no keeper: it ends by its own
  limit of 30 seconds, or when lzrprf's socket closes.
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
    perl lzrprf incognito [/path/to/program]  the same in an incognito window, which leaves nothing behind when it closes [C16]
    perl lzrprf log                      what the log on this computer holds, and what is kept
    perl lzrprf keep                     what is kept after a window closes, in words
    perl lzrprf keep MODE [DAYS]         choose it: nothing, hosts or all; DAYS 0 keeps until you clear it. The one place where more is chosen
    perl lzrprf address TEXT             what would be fetched if TEXT were typed into the bar
    perl lzrprf request TEXT             the exact bytes a site is sent for TEXT
    perl lzrprf public NUMBER            whether a numeric address is public, and how this computer sends to it
    perl lzrprf mark                     this build of macOS, this lzrprf and the selftest beside it, as one line
    perl selftest                        probe it on this computer; about half a minute, no window

Three lines of the log, for one request (time, number of the run, what happened), as a log of
full addresses holds them; a log of hosts only holds `https://example.com` in each:

    2026-11-18T09:14:03Z  4711  you typed https://example.com/
    2026-11-18T09:14:03Z  4711  https://example.com/ -> lzrprf connects to the first that answers of: 93.184.215.14
    2026-11-18T09:14:04Z  4711  https://example.com/ answered: 931 bytes from 93.184.215.14

The Log button of the window shows the lines of that window, from memory, and the log on this
computer when there is one, with the button that clears it and, while a log is kept, the
questions that keep less (`sub log_shown`).

`selftest` prints six kinds of line under eleven numbered headings, then a count and a
verdict. `now`: what the test is doing at this moment, printed while it runs; the installer
shows these as its steps. `ran`: one of the runs of lzrprf, as it ends: its number of all of
them, its seconds and what it tries (`%about`); a run is judged after all have ended, and the
installer shows each under its step. `works`: a probe tried outside every container, where it must
succeed. `held`: a probe that failed inside, or a promise checked against what the test site
itself received. `UNTESTED`: something this Mac gave no way to try, with the reason; the mark
the run writes names each. `FAILED`:
a probe that succeeded, or a promise that did not hold. A line that begins `selftest:` says
why the test could not run at all. The hostile application is the text `$hostile` in
`selftest`: read it, add a probe of your own, run it again. The test uses no host outside
this computer. Its tries at an address outside go to 192.0.2.1, which is kept for
documentation and which no host answers: made outside every container, where they must not
be refused, they can put the opening packet of a connection on your network, with nothing of
yours in it. `selftest-output.txt` is the
record of the run of this release's `lzrprf` on the maker's Mac, written when the release was
made; its last line names the build of macOS and the SHA-256 of the `lzrprf` and `selftest`
that were run, and a record that names another sum than `release.txt` is not of this release.
It shows what a run looks like; the proof for your computer is your own run.

## The installer

`install.sh` in this repository is the installer that https://lzrbrwsr.com/install.sh serves, and
`release.txt` holds the SHA-256 of it, of the download, and of each file in the download. The
installer runs from a file and never from a pipe, so that what runs is something you can read
and check first:

    curl -q -fsSO https://lzrbrwsr.com/install.sh &&
    curl -q -fsS https://raw.githubusercontent.com/lzrbrwsr/lzrprf/main/install.sh | cmp - install.sh &&
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
GitHub. They are two separate systems, and this one keeps every change with its date, as far
as ordinary git history does (see "What "on record" is worth" below). Three
comparisons use that. Each is a line you can read:

| what is compared | who compares | the line |
| --- | --- | --- |
| the installer, before it runs | your own shell | the second of the three lines above |
| the download | the installer | in `install.sh`: `fetch "$SECOND/$FILE" "$tmp/second"`, then `cmp -s "$tmp/$FILE" "$tmp/second"`; `SECOND` is this repository |
| the installer of a newer release | lzrprf | `sub installed`: two fetches through `sub fixed`, then `$copies[0] ne $copies[1]`, before anything is written or run |

What each is worth, and no more:

- **The installer is the root.** It carries the SHA-256 of the download, of `lzrprf` and of
  `selftest` (the lines `SHA256=`, `LZRPRF_SHA256=` and `SELFTEST_SHA256=`) and stops on a file
  that does not match (`get` in `install.sh`). So with the true installer, no changed file is
  installed, wherever it was fetched from. That leaves one question: is this the true installer?
  Before a first install, nothing on your Mac knows. The first comparison answers it as far as
  it can be answered without a key: two separate systems serve the same bytes. That shows
  that the two agree, not who wrote the bytes: both places are the maker's, so whoever holds
  both is not found by it, nor is one who stands between you and both with a certificate
  your Mac trusts.
- **The second comparison adds a record, not strength.** A changed installer would skip it, and
  against a changed download the checksum already stands. What it adds: the installer stops
  unless the file it is about to install is the file on record here. So every release anyone
  installed is in this repository's history, with its date, for anyone to fetch and take apart,
  as long as nobody rewrote that history (see "What "on record" is worth").
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
- **https.** Both fetches rest on TLS and on macOS's list of certificate authorities: an
  authority that can speak for both hosts can change both copies on their way to you.
- **Your shell.** The three lines start `curl` from your shell, with your shell's variables (a
  proxy, a file of certificates): `-q` keeps curl from a settings file and no more. The same
  three lines with no variable of your shell:

      /usr/bin/env -i /usr/bin/curl -q -fsSO https://lzrbrwsr.com/install.sh &&
      /usr/bin/env -i /usr/bin/curl -q -fsS https://raw.githubusercontent.com/lzrbrwsr/lzrprf/main/install.sh | /usr/bin/cmp - install.sh &&
      /usr/bin/env -i /bin/sh install.sh

- **`main` moves.** The second line compares with `main` as it is in that moment, which shows
  that the two places agree now, not that this is the installer somebody read. Whoever read
  one release keeps two things from that reading: the full hash of the commit, and the
  SHA-256 of its `install.sh` (`release.txt` at that commit names it). Then
  `shasum -a 256 install.sh` on the file about to run must print that value.
- **The installer's word about itself.** What the installer promises to check proves nothing
  about the installer itself. Read it, or compare its SHA-256 with the one from somebody's
  reading, before you run it.
- **A hash and a branch.** A commit hash names content; a branch name such as `main` names
  whatever is newest there. Neither says who put it there.
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
- Needs no password and no `sudo`. Before anything else it looks at what it would hand on to
  a program it starts, and goes on only when that is your home folder (as this Mac's list of
  accounts gives it), the system's own `PATH`, the kind of terminal as one plain word, names a
  shell sets for itself, each in its plain shape (`PWD`, `SHLVL`, `_`; zsh also `OLDPWD` and
  `LOGNAME`), and nothing else; with anything else there, or with a line break or another
  control character inside one of those values, it starts itself once more through
  `/usr/bin/env -i` with the first three (a test keeps its six settings too). So the curl, the
  perl and the `selftest` it starts get no variable of your shell (`PERL5OPT`, `PERL5LIB`,
  `SSL_CERT_FILE`, …). No mark says "already clean" that a starter could set (releases before
  15 used the number of the process as one): what is there is read by a perl that is itself
  started through `env -i`, and the lines before it name their tools by full path and use
  words of the shell that no function can give another meaning. What those first lines cannot
  see or undo is what `/bin/sh` took in for itself at its own start and does not hand on. On
  macOS `/bin/sh` is bash: it reads `SHELLOPTS` and `PS4`, and with those a command written
  into `PS4` runs before each of these lines, as the starter's own program. The second start
  has neither; started as `/usr/bin/env -i /bin/sh install.sh` (see "Your shell" under the
  three lines), the first has neither as well. Where an administrator made zsh the `/bin/sh`,
  it reads more for itself: the one found to act (`ARGV0`, the name it gives the programs it
  starts) is unset at the top, and `IFS` with it. What stays from the starter to the end and
  is no variable: the current folder, open files, limits, and signals set to be ignored. From
  a folder whose name holds a control character the installer does not start, and says so.
  It fetches over https
  only, with `/usr/bin/curl -q`, and follows no
  redirect: each file comes from the address written in the installer, or not at all (the
  function `fetch` in `install.sh`).
- Has six settings for its own test, read from variables of your shell whose names begin
  `LZRBRWSR_` or `LZRPRF_`. They are taken only when every file then comes from this computer
  (`file:///`), that is, opened through this computer's file names; a network volume mounted
  on this Mac has such names too, and every SHA-256 must still match. With one of them set and
  an https address in play, it stops and says so. So a
  variable somebody put into your shell cannot point a real install elsewhere or answer a
  question for you. With them in use, those six and the test's home folder are the only
  variables it keeps.
- Refuses to put an older release over a newer one: it looks in `/Applications` and in
  `~/Applications`, whichever of them it installs to.
- Fetches `lzrprf` and `selftest` from this repository at one fixed commit and checks their
  SHA-256. Fetches the download from the site and checks its SHA-256, fetches it again from
  this repository, and stops unless the two are the same file.
- Checks that the download holds exactly six files and no link, and that three of them are,
  byte for byte, texts written out in the installer: the launcher the icon runs (its one
  command starts perl through `env -i`; that perl finds your home folder in this Mac's list
  of accounts and starts `lzrprf run` with the `lzrbrwsr-bin` beside it, or shows an alert
  when lzrprf is missing), the property list that names the launcher to
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
- Places files alone. Right after its questions, before it compares releases or tests anything, the
  installer takes a lock: a link `~/.lzrprf/.installing` whose text is its process number and
  the moment that process started, read in one time zone whatever the Mac is set to. A second
  installer stops while the first one lives. The lock is in your home folder, so it holds for
  your account: an installer that another account of this Mac runs at the same moment is not
  seen by it, and both can write `/Applications`. A lock whose installer is gone (killed, or the
  power failed) is taken over, by one installer at a time. The lock is taken away as
  soon as the new parts stand at their names and the removal of the older ones was tried
  (whether or not it worked), before the installer removes `rules` and `refused`, prints its
  last lines and asks about the Dock; and at a failure, at Ctrl-C, Ctrl-\
  or a closed Terminal. A kill
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
  is not and where it is kept. That is true of the installer's own steps. It cannot undo a disk that fails
  in that moment, or another program that removes files then. An install that was killed outright, or lost power, between
  its renames can also leave a mixed pair. From release 12 on such a pair is noticed at the
  next start, when both parts know the line: lzrprf finds its own SHA-256 is not the one the
  app's `release` file names. The lzrprf of release 12 says so and asks, and can be told to
  start anyway; from release 13 on lzrprf says so and does not start, with one button, Quit.
  An app of release 11 or earlier names no lzrprf: from release 15 on lzrprf does not start
  such an app either. An lzrprf of release 11 or earlier does not look, so a mixed pair with
  that older lzrprf in it, as an update from release 11 that was cut off would leave, is not
  noticed. An lzrprf of release 16 or later also compares the launcher and the program, each
  with its line `file` in the app's `release` file, and from release 17 on stops at a file
  beside them that no line names. Installing again mends it in every case.
- Removes two files an earlier lzrprf kept and this one does not: `~/.lzrprf/rules` and
  `~/.lzrprf/refused`. A log an earlier release wrote is not removed: while nothing is
  kept, the installer says that it is there, and the Log button of the window offers to clear
  it.
- Never runs the closed program. Installs no other program, service, extension or updater,
  and leaves nothing running: no login item, no helper, nothing that runs by itself. What it
  does besides placing the app, `~/.lzrprf/lzrprf` and `~/.lzrprf/selftest`, each said above:
  it makes the folder `~/.lzrprf` and sets its rights to 700, makes the folder the app goes
  into when that is missing, and keeps there the mark
  `proven` and the empty file `selftest.lock` that `selftest` writes, and its own lock until
  the files are placed; it removes `~/.lzrprf/rules` and `~/.lzrprf/refused` of older releases; it leaves
  a log that is there alone; and it asks before it touches the Dock, and on a yes adds one
  entry and starts the Dock again so that it shows (`killall Dock`). Its temporary folder is taken away when it ends, its lock already when the files are
  placed (above); a kill no program can catch, or a power
  failure, leaves them, and with them the staging folders in which it readied the new parts,
  beside the installed ones: the next install removes those, or names them when they hold an
  older part. A folder that holds an older part it could not put back stays, and is named.

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
under `/Users`). That the same source gives the same program whichever folder it is built
from, and that a program with the same SHA-256 across releases was built the same way, cannot
be checked without the source: it is the maker's word. What you can check is the SHA-256 of
the packed file and of each file in it against `release.txt`.

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
| Apple's scan found no known malware in the program. | Nothing is assumed about the program. It runs with no network, no file of yours, nowhere to write and no other program, in a container whose every line is in this repository, and that container is probed on your Mac before a file is put in place (`selftest`) and proves itself again at every start `[C2]`. |
| The bytes are the ones the maker handed in. | The SHA-256 of the installer, of the download and of each file in it is on public record here (`release.txt`). The installer and the download stand in two places that must agree, and the installer stops on any other byte (`get` in `install.sh`). |
| A named maker, and a ticket Apple can take back. | Not here. No identity stands behind a release, nothing is signed with a key, and a release cannot be taken back from a Mac it is on: a newer one can only be offered. A signing key of the maker's own, kept away from the computer that builds, would give the first half. It is not built. |

A signature says who made a program, not what it does, and whoever gives it can take it back.

## Check it yourself

Give this to an AI agent you trust, or follow it by hand. If the agent takes files, attach
`lzrprf`, `selftest`, `install.sh`, `release.txt`, `README.md`, `selftest-output.txt` and
`lzrbrwsr-macos-arm64.tar.gz` as you downloaded them from the newest commit of `main`. An
agent that reads the repository through a web tool is often shown parts of a long file only,
and cannot take the SHA-256 of what it was shown; with the files it can read every line and
take each SHA-256 itself.

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
tools can read the raw files whole (a web tool that shows parts of a long file, for example),
say which files you read in part, and ask me for `lzrprf`, `selftest`, `install.sh` and
`release.txt` as files. Files I attached are the ones to read: read them whole, take their
SHA-256 yourself, and check them against the commit where a tool of yours reaches it. Never
audit from memory or from a summary. Before you report that two
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
   Under which limits do the closed program and curl run (processor time, memory, files,
   processes), who sets them, can either raise one again, and what happens when one cannot
   be set? Which variables does
   each of the two see? Which files can the closed program load as code, which line refuses
   the others, and does `selftest` try one? Read `sub laid_out` to its end: on every way out of it, is the page
   process ended and waited for, also when a later step of starting fails? Read `sub keeper`:
   what ends the closed program when lzrprf itself is killed, and what if the keeper is
   killed first? By which names does
   `selftest` try to read a file of the home folder in the page and fetch containers?
3. The first lines of `lzrprf` list sixteen conditions, [C1] to [C16], and each is marked again
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
6. Read `sub newer`, `sub beside`, `sub installed` and `sub fault`. Is anything fetched or
   sent without a yes? Is anything piped into a shell? Can lzrprf replace itself or the
   program? What exactly does a report hold, where does it go, and can the closed program
   choose any part of it? What does lzrprf do at its start when the app beside it names
   another lzrprf than the one that runs, or names none (does it start at all?), and when
   the launcher or the program is another file than the app's `release` file names: by what
   is that measured, when is it looked at, and what is it worth against whoever can change
   both? Is every file in the program's folder named, and is the program read again before
   every page, before the site is asked and before it is started? With which
   variables does `sub installed` run the installer, what reaches the window of what it
   prints (`sub install_line`), and does its fetch follow a redirect?
7. Read `install.sh` and `release.txt`. Confirm that the installer refuses to run from a pipe,
   asks before it runs, takes no test setting from the shell unless every file comes from this
   computer, fetches lzrprf from this repository at one fixed commit, that the
   SHA-256 values it carries match `lzrprf` and `selftest` at that commit and the download
   `lzrbrwsr-macos-arm64.tar.gz` here, that it fetches the download from two places and stops
   unless they are the same file, that it runs `selftest` before installing anything, never
   runs the closed program, refuses an older release, asks before it replaces lzrprf, and
   looks for a newer release in both folders an install can be in, goes on only when its
   environment holds nothing of my shell but the kind of terminal (the home folder must be
   the one this Mac's list of accounts gives, the PATH the system's own; read how the first
   lines decide that, and whether a mark or a variable of whoever starts it could get past
   them), follows no redirect, lets one installer of my
   account place files at a time (when does it let go of its lock?), puts the
   older app and the older lzrprf back as a pair when it cannot finish, removes nothing older
   when it cannot put everything back and says where it is, and installs no other program,
   service, extension or updater (what else does it change in my home folder and Dock?). Read
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
   say then, and what does `sub proven` do with such a mark before an address is taken?
9. If you can run commands on my Mac, ask me first, then:
   - clone the repository and run `perl selftest`; show me the result, every `UNTESTED` line
     included; add one probe of your own to `$hostile` and run it again;
   - if LZRBRWSR is installed, compare `shasum -a 256 ~/.lzrprf/lzrprf` with the file at the
     commit the installer names, and the files in /Applications/LZRBRWSR.app with `release.txt`;
   - print `/Applications/LZRBRWSR.app/Contents/MacOS/lzrbrwsr`. It must be the short plain-text
     launcher: one command, perl through `env -i`, that starts `lzrprf run` from my home
     folder as this Mac's list of accounts gives it, and only shows an alert when lzrprf is
     missing;
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
