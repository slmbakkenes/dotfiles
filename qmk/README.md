# qmk

QMK firmware for the ZSA Moonlander and Voyager, as a QMK
[external userspace](https://docs.qmk.fm/newbs_external_userspace). Not a stow
package: QMK reads it from here.

| Path | What |
| ---- | ---- |
| `users/sven/sven.h` | The layout: every layer, written once in Voyager shape |
| `users/sven/sven.c` | Tri-layer (NAV + SYM = SYS) and Gruvbox layer colors |
| `users/sven/config.h` | Home row mod tuning |
| `keyboards/zsa/voyager/keymaps/sven/` | Core 1:1 onto the Voyager |
| `keyboards/zsa/moonlander/keymaps/sven/` | Core plus the Moonlander's extra keys |

Change the layout in `sven.h` and both keyboards follow. Keys only the
Moonlander has (inner columns, bottom row, red keys, third thumb key) live in
its `keymap.c` as `EXTRAS_BASE`; keep those to conveniences.

## Setup

```bash
brew tap osx-cross/arm && brew trust osx-cross/arm
brew bundle --file=~/.dotfiles/homebrew/.Brewfile   # arm compiler, make, dfu-util
mise install                                        # qmk CLI, installed with uv
qmk setup -y                                        # qmk_firmware in ~/qmk_firmware
qmk config user.overlay_dir="$HOME/.dotfiles/qmk"
```

The ARM compiler is keg-only; `zsh/.zprofile` puts it on the PATH. `qmk
doctor` still complains about avr-gcc and dos2unix, neither of which ZSA
boards need.

## Build and flash

```bash
flash-keyboard                               # build + flash whichever board is plugged in
qmk userspace-compile                        # build both boards -> qmk/*.bin
```

`flash-keyboard` (from the `bin` stow package) wraps `qmk flash` and waits for
the bootloader: hold Space + Enter and tap the top-left key, or press the reset
button. Keymapp is not needed.

## Cheat sheet

Keymapp only shows Oryx layouts, so `cheatsheet/gen.py` renders both keymaps
into one page (layer tabs, key search, Moonlander/Voyager toggle):

```bash
python3 cheatsheet/gen.py    # -> .build/keymap.html
```

Rerun it after changing a layer. The page lives as a Claude artifact, so ask
Claude to republish it.

## macOS

- Input source: **ABC** only. The firmware sends US key positions; with Dutch
  or another layout active, symbols land on the wrong keys.
- Accents are macOS dead keys on the SYM number row: tap the accent, then the
  letter (` ´ ` then `e` = é, ` ¨ ` then `e` = ë). They are sent with right
  Option, which kitty leaves alone (`macos_option_as_alt left`).

## Layers

Voyager shape; `▽` = held thumb, `·` = falls through to base.

```
BASE
 `   1   2   3   4   5        6   7   8   9   0   -
Tab  Q   W   E   R   T        Y   U   I   O   P   \
Esc  A   S   D   F   G        H   J   K   L   ;   '
Sft  Z   X   C   V   B        N   M   ,   .   /  Sft
              Spc Tab          Bsp Ent
             (NAV)(NUM)           (SYM)

home row hold:  A Cmd  S Opt  D Ctrl  F Shift | J Shift  K Ctrl  L Opt  ; Cmd
both Shifts:    Caps Word, capitals until the next space

SYM (hold Enter), number row = dead keys
 ·   `   ^   ´   ¨   ~        ç   €   ß   ·   ·   ·
 ·   `   <   >   -   |        ^   {   }   $   \   _
 ·   !   *   /   =   &        #   (   )   ;   "   ?
 ·   ~   +   [   ]   %        @   :   ,   .   '   ·

NAV (hold Space)
 ·   ·   ·   ·   ·   ·       prv vol- vol+ nxt ply mute
 ·   ×  tab< tab> win  ⌘Spc  Home PgDn PgUp End  ×   ·
 ·  Cmd Opt Ctrl Sft  ×       ←   ↓   ↑   →   ×   ·
 ·  undo cut copy paste redo  ⌥←  ⌥⌫  Del  ⌥→  ×   ·

NUM (hold Tab)
 ·   ·   ·   ·   ·   ·        ·   ·   ·   ·   ·   ·
 ·  F12  F7  F8  F9  ×        /   7   8   9   *   ·
 ·  F11  F4  F5  F6  ×        -   4   5   6   +   ·
 ·  F10  F1  F2  F3  ×        ,   1   2   3   .   ·
                               ·   0 (right thumb)

SYS (hold Space + Enter)
boot ×   ×   ×   ×   ×        ×   ×   ×   ×   ×  boot
 ×  rgb  rgb- rgb+ ×  ×      lock bri- bri+ ×  ×   ×
 ×  Cmd Opt Ctrl Sft  ×       ×  Sft Ctrl Opt Cmd  ×
```

Moonlander extras on BASE: `⌘⇧4` `[` `(` / `=` `]` `)` on the inner
columns, plain Ctrl Opt Cmd Shift bottom left (for mouse work), arrows bottom
right, Caps Word and Spotlight on the red keys, Esc and Del on the outer thumb
keys.

## Home row mods

Settings in `users/sven/config.h`. Chordal Hold means a home row key only
turns into a modifier together with a key on the **other** hand: Cmd+C is
`;` + C, Ctrl+hjkl is D + hjkl. For a same-hand chord use the other side's
modifier, or NAV's plain modifiers.

Expect a week or two of adjusting. Tuning:

- mods fire while typing: raise `FLOW_TAP_TERM` (150 → 175)
- letters come out when you want a mod: lower `TAPPING_TERM` (220 → 200)
