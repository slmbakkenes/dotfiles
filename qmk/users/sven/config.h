#pragma once

// Home row mods, tuned as qmk_firmware/docs/tap_hold.md recommends. If mods
// still fire while typing, raise FLOW_TAP_TERM; if they feel slow to engage,
// lower TAPPING_TERM.
#define TAPPING_TERM 220
#define PERMISSIVE_HOLD // nested tap on the other hand = modifier
#define CHORDAL_HOLD    // same-hand rolls stay letters
#define FLOW_TAP_TERM 150 // while typing fast, home row keys are always letters
#define QUICK_TAP_TERM 120 // tap then hold repeats the key (e.g. space, jjjj)
#define SPECULATIVE_HOLD   // Shift/Ctrl + mouse click without lag

// Tap both Shifts (or the F and J home row mods) for CAPS_WORD.
#define BOTH_SHIFTS_TURNS_ON_CAPS_WORD
