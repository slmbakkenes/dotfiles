// Voyager: the shared core from users/sven/sven.h, one to one.

#include "sven.h"

// Indirection so the LAYER_* macros expand before LAYOUT counts its arguments.
#define VOYAGER(...) LAYOUT(__VA_ARGS__)

// clang-format off

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [_BASE] = VOYAGER(LAYER_BASE),
    [_SYM]  = VOYAGER(LAYER_SYM),
    [_NAV]  = VOYAGER(LAYER_NAV),
    [_NUM]  = VOYAGER(LAYER_NUM),
    [_SYS]  = VOYAGER(LAYER_SYS),
};

// Chordal Hold: home row mods only become modifiers with the other hand.
// Thumbs are '*' so a thumb layer works with keys on either hand.
const char chordal_hold_layout[MATRIX_ROWS][MATRIX_COLS] PROGMEM = LAYOUT(
    'L', 'L', 'L', 'L', 'L', 'L',    'R', 'R', 'R', 'R', 'R', 'R',
    'L', 'L', 'L', 'L', 'L', 'L',    'R', 'R', 'R', 'R', 'R', 'R',
    'L', 'L', 'L', 'L', 'L', 'L',    'R', 'R', 'R', 'R', 'R', 'R',
    'L', 'L', 'L', 'L', 'L', 'L',    'R', 'R', 'R', 'R', 'R', 'R',
                            '*', '*',    '*', '*'
);

// clang-format on
