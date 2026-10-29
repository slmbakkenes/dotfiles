"""Render the sven keymaps into a self-contained cheat sheet page.

Keymapp only shows Oryx layouts, so this preprocesses both keymap.c files with
a stub LAYOUT macro, pairs every key with its position from qmk_firmware's
keyboard.json and fills the result into template.html.

    python3 cheatsheet/gen.py [out.html]    # default: .build/keymap.html
"""

import json
import re
import subprocess
import sys
import tempfile
from pathlib import Path

USERSPACE = Path(__file__).resolve().parent.parent
QMK = Path.home() / "qmk_firmware" / "keyboards" / "zsa"
LAYERS = 5  # _BASE, _SYM, _NAV, _NUM, _SYS


def keyboard(kb, tmp):
    layout = json.loads((QMK / kb / "keyboard.json").read_text())["layouts"]["LAYOUT"]["layout"]
    n = len(layout)

    # LAYOUT(k0, k1, ...) expands to "@@0:k0 @@1:k1 ...", so every key keeps its
    # physical index after the preprocessor has resolved the shared macros.
    stub = tmp / f"{kb}_stub.h"
    args = ",".join(f"k{i}" for i in range(n))
    body = " ".join(f"@@{i}:k{i}" for i in range(n))
    stub.write_text(f"#define LAYOUT({args}) {{ {body} }}\n")

    keymap = USERSPACE / "keyboards" / "zsa" / kb / "keymaps" / "sven" / "keymap.c"
    text = subprocess.run(
        ["cc", "-E", "-P", f'-DQMK_KEYBOARD_H="{stub}"', f"-I{USERSPACE / 'users' / 'sven'}", keymap],
        capture_output=True, text=True, check=True,
    ).stdout

    layers = []
    for block in re.findall(r"\{([^{}]*@@[^{}]*)\}", text)[:LAYERS]:
        keys = {
            int(m.group(1)): re.sub(r"\s+", "", m.group(2))
            for m in re.finditer(r"@@(\d+):(.*?)(?=\s*@@|\s*$)", block.strip())
        }
        layers.append([keys[i] for i in range(n)])
    if len(layers) != LAYERS:
        sys.exit(f"{kb}: found {len(layers)} layers, expected {LAYERS}")

    keys = [{"x": k["x"], "y": k["y"], "w": k.get("w", 1), "h": k.get("h", 1)} for k in layout]
    return {"keys": keys, "layers": layers}


def main():
    out = Path(sys.argv[1]) if len(sys.argv) > 1 else USERSPACE / ".build" / "keymap.html"
    with tempfile.TemporaryDirectory() as tmp:
        data = {kb: keyboard(kb, Path(tmp)) for kb in ["moonlander", "voyager"]}

    template = (Path(__file__).parent / "template.html").read_text()
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(template.replace("__DATA__", json.dumps(data)))
    print(out)


if __name__ == "__main__":
    main()
