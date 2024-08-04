"""
    This is my configuration for my Corne keyboard. 3x6.
"""
from kb import KMKKeyboard

from kmk.keys import KC
from kmk.modules.holdtap import HoldTap
from kmk.modules.layers import Layers
from kmk.modules.split import Split, SplitSide, SplitType
from kmk.extensions.peg_oled_Display import Oled,OledDisplayMode,OledReactionType,OledData

keyboard = KMKKeyboard()
holdtap = HoldTap()

# TODO Comment one of these on each side
split = Split(use_pio=True)
layers_ext = Layers()

keyboard.modules = [layers_ext, split, holdtap]
keyboard.extensions = []
#
# Cleaner key names
_______ = KC.TRNS
XXXXXXX = KC.NO

LOWER = KC.MO(2)
RAISE = KC.MO(3)
ADJUST = KC.SPC
C2Q = KC.HT(KC.TO(0), RAISE)
Q2C = KC.HT(KC.TO(1), RAISE)

keyboard.keymap = [
    [  #QWERTY
        KC.TAB,    KC.Q,    KC.W,    KC.E,    KC.R,    KC.T,                         KC.Y,    KC.U,    KC.I,    KC.O,   KC.P,  KC.BSPC,\
        KC.LCTL,   KC.A,    KC.S,    KC.D,    KC.F,    KC.G,                         KC.H,    KC.J,    KC.K,    KC.L, KC.SCLN, KC.QUOT,\
        KC.LSFT,   KC.Z,    KC.X,    KC.C,    KC.V,    KC.B,                         KC.N,    KC.M, KC.COMM,  KC.DOT, KC.SLSH, KC.RSFT,\
                                            LOWER,  ADJUST, KC.RALT,     KC.LGUI, KC.ENT,   Q2C,
    ],
    [  #COLEMAK_DH
    	KC.TAB,   KC.Q,  KC.W,  KC.F,  KC.P,  KC.B,                                  KC.J,  KC.L,  KC.U,  KC.Y,  KC.SCLN, KC.BSPC, \
    	KC.LCTL,  KC.A,  KC.R,  KC.S,  KC.T, KC.G,                                   KC.M,  KC.N,  KC.E,  KC.I,  KC.O, KC.QUOT, \
    	KC.LSFT,  KC.Z,  KC.X,  KC.C,  KC.D, KC.V,                                   KC.K,  KC.H,  KC.COMM,  KC.DOT,  KC.SLSH,  KC.RSFT, \
					                        LOWER,  ADJUST, KC.RALT,     KC.LGUI, KC.ENT,   C2Q,

    ],
    [  #LOWER
        KC.ESC,   KC.N1,   KC.N2,   KC.N3,   KC.N4,   KC.N5,                         KC.N6,   KC.N7,  KC.N8,   KC.N9,   KC.N0, KC.BSPC,\
        KC.LCTL, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                        KC.LEFT, KC.DOWN, KC.UP,   KC.RIGHT, XXXXXXX, XXXXXXX,\
        KC.LSFT, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                        XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,\
                                            LOWER,  ADJUST, KC.RALT,     KC.LGUI, KC.ENT,   RAISE,
    ],
    [  #RAISE
        KC.ESC, KC.EXLM,   KC.AT, KC.HASH,  KC.DLR, KC.PERC,                         KC.CIRC, KC.AMPR, KC.ASTR, KC.LPRN, KC.RPRN, KC.BSPC,\
        KC.LCTL, KC.UNDS, KC.MINS, KC.PLUS, KC.EQL, KC.COLN,                        KC.MINS,  KC.EQL, KC.LCBR, KC.RCBR, KC.PIPE,  KC.GRV,\
        KC.LSFT, KC.LABK, KC.RABK, KC.LBRC, KC.RBRC, KC.QUES,                       KC.UNDS, KC.PLUS, KC.LBRC, KC.RBRC, KC.BSLS, KC.TILD,\
                                              LOWER,  ADJUST, KC.RALT,     KC.LGUI, KC.ENT,   RAISE,
    ],
]

if __name__ == '__main__':
    keyboard.go()
