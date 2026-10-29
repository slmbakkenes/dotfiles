// Moonlander: the shared core from users/sven/sven.h, plus the keys the
// Voyager lacks. Keep those extras convenient, not essential: anything you
// rely on daily belongs in the core.

#include "sven.h"

// clang-format off

// Places the 52-key core on the Moonlander and appends its 20 extra keys:
//   IL*/IR*  inner columns (rows 0-2) next to T and Y
//   BL*/BR*  bottom row under the letters
//   RDL/RDR  the big red thumb keys
//   LT3/RT3  third key of each thumb arc, furthest from the letters
#define LAYOUT_sven( \
    L00, L01, L02, L03, L04, L05,   R00, R01, R02, R03, R04, R05, \
    L10, L11, L12, L13, L14, L15,   R10, R11, R12, R13, R14, R15, \
    L20, L21, L22, L23, L24, L25,   R20, R21, R22, R23, R24, R25, \
    L30, L31, L32, L33, L34, L35,   R30, R31, R32, R33, R34, R35, \
                        LT1, LT2,   RT2, RT1, \
    IL0, IL1, IL2,   IR0, IR1, IR2, \
    BL0, BL1, BL2, BL3, BL4, RDL,   RDR, BR0, BR1, BR2, BR3, BR4, \
    LT3, RT3 \
) LAYOUT( \
    L00, L01, L02, L03, L04, L05, IL0,   IR0, R00, R01, R02, R03, R04, R05, \
    L10, L11, L12, L13, L14, L15, IL1,   IR1, R10, R11, R12, R13, R14, R15, \
    L20, L21, L22, L23, L24, L25, IL2,   IR2, R20, R21, R22, R23, R24, R25, \
    L30, L31, L32, L33, L34, L35,             R30, R31, R32, R33, R34, R35, \
    BL0, BL1, BL2, BL3, BL4,      RDL,   RDR,      BR0, BR1, BR2, BR3, BR4, \
                        LT1, LT2, LT3,   RT3, RT2, RT1 \
)

// Indirection so the LAYER_* macros expand before LAYOUT_sven counts them.
#define MOONLANDER(...) LAYOUT_sven(__VA_ARGS__)

#define EXTRAS_BASE \
    M_SHOT,  KC_LBRC, KC_LPRN,   KC_EQL,  KC_RBRC, KC_RPRN, \
    KC_LCTL, KC_LALT, KC_LGUI, KC_LSFT, XXXXXXX, CW_TOGG, \
    M_SPOT,  KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT, XXXXXXX, \
    KC_ESC,  KC_DEL

#define EXTRAS_TRANS \
    _______, _______, _______,   _______, _______, _______, \
    _______, _______, _______, _______, _______, _______, \
    _______, _______, _______, _______, _______, _______, \
    _______, _______

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [_BASE] = MOONLANDER(LAYER_BASE, EXTRAS_BASE),
    [_SYM]  = MOONLANDER(LAYER_SYM,  EXTRAS_TRANS),
    [_NAV]  = MOONLANDER(LAYER_NAV,  EXTRAS_TRANS),
    [_NUM]  = MOONLANDER(LAYER_NUM,  EXTRAS_TRANS),
    [_SYS]  = MOONLANDER(LAYER_SYS,  EXTRAS_TRANS),
};

// Chordal Hold: home row mods only become modifiers with the other hand.
// Thumbs and red keys are '*' so a thumb layer works with either hand.
const char chordal_hold_layout[MATRIX_ROWS][MATRIX_COLS] PROGMEM = LAYOUT(
    'L', 'L', 'L', 'L', 'L', 'L', 'L',    'R', 'R', 'R', 'R', 'R', 'R', 'R',
    'L', 'L', 'L', 'L', 'L', 'L', 'L',    'R', 'R', 'R', 'R', 'R', 'R', 'R',
    'L', 'L', 'L', 'L', 'L', 'L', 'L',    'R', 'R', 'R', 'R', 'R', 'R', 'R',
    'L', 'L', 'L', 'L', 'L', 'L',              'R', 'R', 'R', 'R', 'R', 'R',
    'L', 'L', 'L', 'L', 'L',      '*',    '*',      'R', 'R', 'R', 'R', 'R',
                        '*', '*', '*',    '*', '*', '*'
);

// clang-format on
