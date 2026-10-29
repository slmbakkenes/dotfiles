#include "sven.h"

#ifdef RGB_MATRIX_ENABLE
// Gruvbox accents as hue and saturation (QMK scale, 0-255), so the board
// shows which layer is active. Brightness stays whatever RM_VALD/RM_VALU set.
static const struct {
    uint8_t hue, sat;
} layer_colors[] = {
    [_BASE] = {17, 238},  // orange #d65d0e
    [_SYM]  = {87, 86},   // aqua   #689d6a
    [_NAV]  = {129, 126}, // blue   #458588
    [_NUM]  = {236, 114}, // purple #b16286
    [_SYS]  = {2, 219},   // red    #cc241d
};

static void show_layer(uint8_t layer) {
    rgb_matrix_sethsv_noeeprom(layer_colors[layer].hue, layer_colors[layer].sat, rgb_matrix_get_val());
}

void keyboard_post_init_user(void) {
    rgb_matrix_mode_noeeprom(RGB_MATRIX_SOLID_COLOR);
    show_layer(_BASE);
}
#endif

layer_state_t layer_state_set_user(layer_state_t state) {
    state = update_tri_layer_state(state, _NAV, _SYM, _SYS);
#ifdef RGB_MATRIX_ENABLE
    show_layer(get_highest_layer(state));
#endif
    return state;
}
