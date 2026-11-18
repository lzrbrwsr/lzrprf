```
    ██╗     ███████╗██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚══███╔╝██╔══██╗██╔══██╗██╔══██╗██╔════╝
▒▓█ ██║       ███╔╝ ██████╔╝██████╔╝██████╔╝█████╗   ▒▓█
    ██║      ███╔╝  ██╔══██╗██╔═══╝ ██╔══██╗██╔══╝
    ███████╗███████╗██║  ██║██║     ██║  ██║██║
    ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚═╝
```

# lzrprf

An open container for a closed application.

lzrprf starts one application so that the operating system, and not the application, decides what
it can do, and it keeps a list of every address that was reached. It was written for
[LZRBRWSR](https://lzrbrwsr.com), a browser whose source is closed, so that anyone can check what
that browser can and cannot do on their computer without seeing its source.

The whole project is two files you can read in one sitting:

- `lzrprf`: the container and its gateway, about 270 lines of Perl.
- `selftest`: a hostile application that attacks the container and says what it managed to do.

It runs on macOS and uses only what macOS already has.

## What the application is held to

Everything below is decided in `lzrprf` and attacked by `selftest`.

- **No network.** The application cannot open a connection, look up a name, send a datagram or
  listen. Its one way out is to name an `https://` address to lzrprf's gateway.
- **Every address is written down first.** The gateway writes the address in the log, and only then
  connects. The line shows the address the user typed and, beside it, what was connected to. A call
  that a page asks for to another host is refused unless the user allowed that host, and it is
  written down either way, beside the address the user typed.
- **Nothing on your computer.** The application cannot read your files or list your folders, cannot
  create or change any file, cannot start another program or a second process, cannot signal
  another process, cannot ask another program to open anything, and sees none of your environment
  variables. It cannot read or change the log, the rules, or lzrprf itself.
- **A site's answer is read somewhere else.** What talks to a site is a second copy of the
  application in a page container: no window, no keyboard, no clipboard, no system service, no
  gateway, one connection, at most 30 seconds of processor and 60 seconds in all. Bytes go from
  that container to the window's side and never the other way.
- **So everything the application can send out is the request line, and the request line is in the
  log in full.**

## Use

    perl lzrprf run /path/to/program     start a program, contained
    perl lzrprf log                      what was reached
    perl lzrprf rules                    which other hosts pages may call
    perl selftest                        attack it on this computer; every line must say "held"

A line of the log:

    2026-11-18T09:14:03Z    2    https://example.com/ -> example.com:443

Last time asked, how many times, the address the application gave as typed, what the gateway
connected to. The log holds one line for each different request and never grows past 256 KB: the
oldest lines go first, and one line says how many have gone. That is several thousand different
addresses, which is more than a few hours of use.

## What it does not prove

- lzrprf cannot see your keyboard. It cannot know that you typed an address, only that the
  application named it. What it gives you is the full list: an address you did not type would be
  in the log.
- The application shows a window, so it speaks to the system's window server and to the clipboard.
  Recording the screen or watching other programs' keys is refused by macOS's own privacy
  permissions, not by lzrprf.
- The application can ask whether a file exists at a path it guesses. It cannot read it or list
  what is there.
- A host you typed or allowed may point to an address inside your own network.
- Memory use is not capped; macOS offers no way to do that from outside.
- The walls are made with macOS's `sandbox-exec`, which Apple marks as deprecated while still
  using the same mechanism for its own programs.
- It holds only for a program that was started through it. Check what the icon runs (below).

## Check it yourself

Give this to an AI agent you trust, or follow it by hand.

```text
Audit https://github.com/henryverlin/lzrprf and tell me whether it is safe to run the
closed-source browser LZRBRWSR (https://lzrbrwsr.com) on my Mac. Trust nothing the README says
until the code shows it.

1. Read every line of the two files `lzrprf` and `selftest`. They are the whole project.
2. From the sandbox profiles and the gateway code in `lzrprf`, list exactly what a program started
   with `lzrprf run` can and cannot do: network, files, other programs and processes, devices,
   system services, environment. Name every allowance and say whether it is a risk.
3. Check each claim in the README against the code. Say which hold, which do not, and which you
   cannot decide.
4. Read the installer at https://lzrbrwsr.com/install.sh. Confirm that it downloads lzrprf from
   this repository at one fixed commit, that the SHA-256 values it carries match `lzrprf` and
   `selftest` at that commit, that it runs `selftest` before installing anything, and that it
   installs nothing else. Report anything it does beyond that.
5. If you can run commands on my Mac, ask me first, then:
   - clone the repository and run `perl selftest`; show me the result;
   - if LZRBRWSR is installed, compare `shasum -a 256 ~/.lzrprf/lzrprf` with the file at the
     commit the installer names;
   - print `/Applications/LZRBRWSR.app/Contents/MacOS/lzrbrwsr`. It must be a short plain-text
     launcher whose one command starts the program through `~/.lzrprf/lzrprf run`;
   - show `perl ~/.lzrprf/lzrprf log` and explain each line.
6. The browser's source is closed. Assume nothing good about it. Given only that it is started
   through lzrprf, what is the worst it could do if it were malicious?
7. Give a verdict: safe, not safe, or safe under conditions you name, with the limits that remain.
```

## Licence

MIT. See `LICENSE`.
