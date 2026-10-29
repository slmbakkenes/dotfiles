// Shared layout for the ZSA Moonlander and Voyager.
//
// Every layer is written once, in the shape of the Voyager (4 rows of 6 keys
// per half, 2 thumb keys per half). Each keyboard's keymap.c maps that core
// onto its own LAYOUT; the Moonlander adds its extra keys on top. Anything you
// need daily belongs in the core, so it moves to the Voyager unchanged.
//
// macOS input source: ABC. Accents come from macOS dead keys (see ACC_*).

#pragma once

#include QMK_KEYBOARD_H

enum layers { _BASE, _SYM, _NAV, _NUM, _SYS };

// Home row mods, macOS order: Cmd Opt Ctrl Shift | Shift Ctrl Opt Cmd.
// The right-hand Option is LALT on purpose: kitty only treats left Option as
// Alt (macos_option_as_alt left), so zsh's Alt+b/f keep working.
#define HM_A    LGUI_T(KC_A)
#define HM_S    LALT_T(KC_S)
#define HM_D    LCTL_T(KC_D)
#define HM_F    LSFT_T(KC_F)
#define HM_J    RSFT_T(KC_J)
#define HM_K    RCTL_T(KC_K)
#define HM_L    LALT_T(KC_L)
#define HM_SCLN RGUI_T(KC_SCLN)

// Thumbs: tap for the key, hold for the layer. NAV + SYM together give SYS.
#define TH_SPC LT(_NAV, KC_SPC)
#define TH_TAB LT(_NUM, KC_TAB)
#define TH_ENT LT(_SYM, KC_ENT)

// macOS dead keys, sent with right Option so they also work in kitty.
// Tap the accent, then the letter: ACC_ACU e -> é, ACC_UML e -> ë.
#define ACC_GRV RALT(KC_GRV) // è à ù
#define ACC_ACU RALT(KC_E)   // é á ó
#define ACC_UML RALT(KC_U)   // ë ï ö ü
#define ACC_CIR RALT(KC_I)   // ê â ô
#define ACC_TIL RALT(KC_N)   // ñ ã õ
#define ACC_CED RALT(KC_C)   // ç
#define ACC_EUR S(RALT(KC_2)) // €
#define ACC_SZ  RALT(KC_S)   // ß

// macOS shortcuts
#define M_UNDO  G(KC_Z)
#define M_CUT   G(KC_X)
#define M_COPY  G(KC_C)
#define M_PASTE G(KC_V)
#define M_REDO  S(G(KC_Z))
#define M_TABP  G(S(KC_LBRC)) // previous tab (kitty, browsers)
#define M_TABN  G(S(KC_RBRC)) // next tab
#define M_WINN  G(KC_GRV)     // next window of the same app
#define M_SPOT  G(KC_SPC)     // Spotlight / launcher
#define M_SHOT  S(G(KC_4))    // screenshot of a selection
#define M_LOCK  C(G(KC_Q))    // lock screen
#define M_WORDL A(KC_LEFT)
#define M_WORDR A(KC_RGHT)
#define M_DELW  A(KC_BSPC)    // delete word

// clang-format off

// Key order of every LAYER_* macro, per half from the outer column inwards on
// the left and from the inner column outwards on the right:
//   row 0-3: 6 left, 6 right
//   thumbs:  left primary, left secondary, right secondary, right primary
// "Primary" is the thumb key closest to the letter keys.

#define LAYER_BASE \
    KC_GRV,  KC_1,    KC_2,    KC_3,    KC_4,    KC_5,        KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    KC_MINS, \
    KC_TAB,  KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,        KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_BSLS, \
    KC_ESC,  HM_A,    HM_S,    HM_D,    HM_F,    KC_G,        KC_H,    HM_J,    HM_K,    HM_L,    HM_SCLN, KC_QUOT, \
    KC_LSFT, KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,        KC_N,    KC_M,    KC_COMM, KC_DOT,  KC_SLSH, KC_RSFT, \
                                        TH_SPC,  TH_TAB,      KC_BSPC, TH_ENT

// Symbols for code, after Pascal Getreuer's symbol layer: brackets and
// operators on the home row, accents on the number row.
#define LAYER_SYM \
    _______, ACC_GRV, ACC_CIR, ACC_ACU, ACC_UML, ACC_TIL,     ACC_CED, ACC_EUR, ACC_SZ,  _______, _______, _______, \
    _______, KC_GRV,  KC_LT,   KC_GT,   KC_MINS, KC_PIPE,     KC_CIRC, KC_LCBR, KC_RCBR, KC_DLR,  KC_BSLS, KC_UNDS, \
    _______, KC_EXLM, KC_ASTR, KC_SLSH, KC_EQL,  KC_AMPR,     KC_HASH, KC_LPRN, KC_RPRN, KC_SCLN, KC_DQUO, KC_QUES, \
    _______, KC_TILD, KC_PLUS, KC_LBRC, KC_RBRC, KC_PERC,     KC_AT,   KC_COLN, KC_COMM, KC_DOT,  KC_QUOT, _______, \
                                        _______, _______,     _______, _______

// Arrows on hjkl like vim, plain modifiers under the left hand for
// Shift+arrow selection, editing shortcuts where Z X C V already are.
#define LAYER_NAV \
    _______, _______, _______, _______, _______, _______,     KC_MPRV, KC_VOLD, KC_VOLU, KC_MNXT, KC_MPLY, KC_MUTE, \
    _______, XXXXXXX, M_TABP,  M_TABN,  M_WINN,  M_SPOT,      KC_HOME, KC_PGDN, KC_PGUP, KC_END,  XXXXXXX, _______, \
    _______, KC_LGUI, KC_LALT, KC_LCTL, KC_LSFT, XXXXXXX,     KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT, XXXXXXX, _______, \
    _______, M_UNDO,  M_CUT,   M_COPY,  M_PASTE, M_REDO,      M_WORDL, M_DELW,  KC_DEL,  M_WORDR, XXXXXXX, _______, \
                                        _______, _______,     _______, _______

// Numpad under the right hand (0 on the thumb), F-keys mirrored on the left.
#define LAYER_NUM \
    _______, _______, _______, _______, _______, _______,     _______, _______, _______, _______, _______, _______, \
    _______, KC_F12,  KC_F7,   KC_F8,   KC_F9,   XXXXXXX,     KC_SLSH, KC_7,    KC_8,    KC_9,    KC_ASTR, _______, \
    _______, KC_F11,  KC_F4,   KC_F5,   KC_F6,   XXXXXXX,     KC_MINS, KC_4,    KC_5,    KC_6,    KC_PLUS, _______, \
    _______, KC_F10,  KC_F1,   KC_F2,   KC_F3,   XXXXXXX,     KC_COMM, KC_1,    KC_2,    KC_3,    KC_DOT,  _______, \
                                        _______, _______,     _______, KC_0

// Hold both primary thumbs. Bootloader sits in the two far corners.
#define LAYER_SYS \
    QK_BOOT, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,     XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, QK_BOOT, \
    XXXXXXX, RM_TOGG, RM_VALD, RM_VALU, XXXXXXX, XXXXXXX,     M_LOCK,  KC_BRID, KC_BRIU, XXXXXXX, XXXXXXX, XXXXXXX, \
    XXXXXXX, KC_LGUI, KC_LALT, KC_LCTL, KC_LSFT, XXXXXXX,     XXXXXXX, KC_RSFT, KC_RCTL, KC_LALT, KC_RGUI, XXXXXXX, \
    XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,     XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, \
                                        _______, _______,     _______, _______

// clang-format on
