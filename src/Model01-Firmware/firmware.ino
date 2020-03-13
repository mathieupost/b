// -*- mode: c++ -*-
// Copyright 2016 Keyboardio, inc. <jesse@keyboard.io>
// Copyright 2019 Burke Libbey <burke@libbey.me>
// See "LICENSE" for license details

#include "Kaleidoscope.h"
#include "Kaleidoscope-Macros.h"
#include "Kaleidoscope-LEDControl.h"
#include "Kaleidoscope-SpaceCadet.h"
/* #include "Kaleidoscope-Focus.h" */
#include "kaleidoscope/plugin/LEDControl/LEDUtils.h" // hsvToRgb

enum {
  R_M, R_Q, R_H, R_J, R_S, R_N, R_Y, R_V, B_O, B_T, B_F, B_N, B_I, B_R, B_P,
  A_0, A_1, A_2, A_3, A_Q, A_W, A_E, A_R, A_T, A_A, A_S, A_D, A_F, A_Z, A_EN, A_I, A_P, A_H, A_J, A_K, A_L, A_N, A_CM, A_DT, A_SP,
  A2_SP, A2_H, A2_L, A2_K, A2_J, A2_1, A2_2, A2_3, A2_4, A2_5, A2_6, A2_7, A2_8, A2_9, A2_0, A2_W, A2_E, A2_R, A2_Q, A2_T, A2_AL, A2_AR
};
enum { ROOT, K_FN, K_ANY, K_BF, K_AMETHYST, K_AMETHYST2 };

// To realign a block using vim-easy-align, type `gaip* `
KEYMAPS(
  [ROOT] = KEYMAP_STACKED (

   ___,          Key_1, Key_2, Key_3,           Key_4,         Key_5,       ___,
   Key_Backtick, Key_Q, Key_W, Key_E,           Key_R,         Key_T,       Key_Tab,
   Key_PageUp,   Key_A, Key_S, Key_D,           Key_F,         Key_G,       /**/
   Key_PageDown, Key_Z, Key_X, Key_C,           Key_V,         Key_B,       Key_Escape,
   /**/          /**/   /**/   Key_LeftControl, Key_Backspace, Key_LeftGui, Key_LeftShift,
   /**/          /**/   /**/   /**/             /**/           /**/         ShiftToLayer(K_AMETHYST),

   ShiftToLayer(K_ANY), Key_6,       Key_7,        Key_8,            Key_9,      Key_0,         ___,
   Key_Enter,           Key_Y,       Key_U,        Key_I,            Key_O,      Key_P,         Key_Equals,
   /**/                 Key_H,       Key_J,        Key_K,            Key_L,      Key_Semicolon, Key_Quote,
   ShiftToLayer(K_BF),  Key_N,       Key_M,        Key_Comma,        Key_Period, Key_Slash,     Key_Minus,
   Key_RightShift,      Key_LeftAlt, Key_Spacebar, Key_RightControl, /**/        /**/           /**/
   ShiftToLayer(K_FN)   /**/         /**/          /**/              /**/        /**/           /**/

   ), [K_FN] = KEYMAP_STACKED (

   ___,      Key_F1,          Key_F2,     Key_F3, Key_F4,     Key_F5, Key_CapsLock,
   Key_Tab,  ___,             ___,        ___,    ___,        ___,    ___,
   Key_Home, ___,             ___,        ___,    ___,        ___,    /**/
   Key_End,  Key_PrintScreen, Key_Insert, ___,    ___,        ___,    ___,
   /**/      /**/             /**/        ___,    Key_Delete, ___,    ___,
   /**/      /**/             /**/        /**/    /**/        /**/    ___,

   Consumer_ScanPreviousTrack, Key_F6,                 Key_F7,                   Key_F8,                   Key_F9,          Key_F10,          Key_F11,
   Consumer_PlaySlashPause,    Consumer_ScanNextTrack, ___,                      ___,                      ___,             ___,              Key_F12,
   /**/                        Key_LeftArrow,          Key_DownArrow,            Key_UpArrow,              Key_RightArrow,  ___,              ___,
   Key_PcApplication,          Consumer_Mute,          Consumer_VolumeDecrement, Consumer_VolumeIncrement, ___,             Key_Backslash,    Key_Pipe,
   ___,                        ___,                    Key_Enter,                ___,                      /**/             /**/              /**/
   ___                         /**/                    /**/                      /**/                      /**/             /**/              /**/

  ), [K_ANY] =  KEYMAP_STACKED (

   ___, ___, ___, ___, ___,    ___,    ___,
   ___, ___, ___, ___, M(B_R), M(B_T), ___,
   ___, ___, ___, ___, M(B_F), ___,    /**/
   ___, ___, ___, ___, ___,    ___,    ___,
   /**/ /**/ /**/ ___, ___,    ___,    ___,
   /**/ /**/ /**/ /**/ /**/    /**/    ___,

   ___, ___,    ___, ___,    ___,    ___,    ___,
   ___, ___,    ___, M(B_I), M(B_O), M(B_P), ___,
   /**/ ___,    ___, ___,    ___,    ___,    ___,
   ___, M(B_N), ___, ___,    ___,    ___,    ___,
   ___, ___,    ___, ___,    /**/    /**/    /**/
   ___  /**/    /**/ /**/    /**/    /**/    /**/

  ), [K_BF] =  KEYMAP_STACKED (

   ___, ___,    ___, ___, ___,    ___, ___,
   ___, M(R_Q), ___, ___, ___,    ___, ___,
   ___, M(R_S), ___, ___, ___,    ___, /**/
   ___, ___,    ___, ___, M(R_V), ___, ___,
   /**/ /**/    /**/ ___, ___,    ___, ___,
   /**/ /**/    /**/ /**/ /**/    /**/ ShiftToLayer(K_AMETHYST2),

   ___, ___,    ___,    ___,    ___, ___, ___,
   ___, ___,    ___,    M(R_Y), ___, ___, ___,
   /**/ M(R_H), M(R_J), ___,    ___, ___, ___,
   ___, M(R_N), M(R_M), ___,    ___, ___, ___,
   ___, ___,    ___,    ___,    /**/ /**/ /**/
   ___  /**/    /**/    /**/    /**/ /**/ /**/

  ), [K_AMETHYST] =  KEYMAP_STACKED (

   ___, M(A_1), M(A_2), M(A_3), ___,    ___,    ___,
   ___, M(A_Q), M(A_W), M(A_E), M(A_R), M(A_T), ___,
   ___, M(A_A), M(A_S), M(A_D), M(A_F), ___,    /**/
   ___, M(A_Z), ___,    ___,    ___,    ___,    ___,
   /**/ /**/    /**/    ___,    ___,    ___,    ___,
   /**/ /**/    /**/    /**/    /**/    /**/    ___,

   ___,                       ___,    ___,     ___,     ___,     M(A_0), ___,
   M(A_EN),                   ___,    ___,     M(A_I),  ___,     M(A_P), ___,
   /**/                       M(A_H), M(A_J),  M(A_K),  M(A_L),  ___,    ___,
   ShiftToLayer(K_AMETHYST2), M(A_N), ___,     M(A_CM), M(A_DT), ___,    ___,
   ___,                       ___,    M(A_SP), ___,     /**/     /**/    /**/
   ___                        /**/    /**/     /**/     /**/     /**/    /**/

  ), [K_AMETHYST2] =  KEYMAP_STACKED (

  /* A2_AL, A2_AR */

   ___, M(A2_1), M(A2_2), M(A2_3), M(A2_4), M(A2_5), ___,
   ___, M(A2_Q), M(A2_W), M(A2_E), M(A2_R), M(A2_T), ___,
   ___, ___,     ___,     ___,     ___,     ___,     /**/
   ___, ___,     ___,     ___,     ___,     ___,     ___,
   /**/ /**/     /**/     ___,     ___,     ___,     ___,
   /**/ /**/     /**/     /**/     /**/     /**/     ___,

   ___, M(A2_6), M(A2_7),  M(A2_8), M(A2_9), M(A2_0), ___,
   ___, ___,     ___,      ___,     ___,     ___,     ___,
   /**/ M(A2_H), M(A2_J),  M(A2_K), M(A2_L), ___,     ___,
   ___, ___,     ___,      ___,     ___,     ___,     ___,
   ___, ___,     M(A2_SP), ___,     /**/     /**/     /**/
   ___  /**/     /**/      /**/     /**/     /**/     /**/

  )
)

static void slackReactMacro(const char * search) {
  Macros.play(MACRO(D(LeftGui), D(LeftShift), T(Backslash), U(LeftShift), U(LeftGui)));
  Macros.type(search);
  Macros.play(MACRO(W(255), W(255), T(Enter)));
}

#define SLACK_MACRO(key, str) \
  case key: \
    SLACK_REACT(str, false); \
    break;

#define SLACK_REACT(str, wait) \
  if (keyToggledOn(keyState)) { \
    slackReactMacro(PSTR(str)); \
    if ( wait ) { Macros.play(MACRO(W(255))); } \
  }

#define BROWSE_MACRO(macro, key) \
  case macro: \
    return MACRODOWN( \
      D(LeftGui), D(LeftShift), D(LeftControl), D(LeftAlt), \
      T(key), \
      U(LeftGui), U(LeftShift), U(LeftControl), U(LeftAlt) \
    );

#define AMETHYST_MACRO(macro, key) \
  case macro: \
    return MACRODOWN( \
      D(LeftShift), D(LeftAlt), \
      T(key), \
      U(LeftShift), U(LeftAlt) \
    );

#define AMETHYST_MACRO2(macro, key) \
  case macro: \
    return MACRODOWN( \
      D(LeftControl), D(LeftShift), D(LeftAlt), \
      T(key), \
      U(LeftControl), U(LeftShift), U(LeftAlt) \
    );

const macro_t *macroAction(uint8_t macroIndex, uint8_t keyState) {
  switch (macroIndex) {

  BROWSE_MACRO(B_O, O);
  BROWSE_MACRO(B_N, N);
  BROWSE_MACRO(B_T, T);
  BROWSE_MACRO(B_F, F);
  BROWSE_MACRO(B_I, I);
  BROWSE_MACRO(B_R, R);
  BROWSE_MACRO(B_P, P);

  AMETHYST_MACRO(A_0, 0);
  AMETHYST_MACRO(A_1, 1);
  AMETHYST_MACRO(A_2, 2);
  AMETHYST_MACRO(A_3, 3);
  AMETHYST_MACRO(A_A, A);
  AMETHYST_MACRO(A_CM, Comma);
  AMETHYST_MACRO(A_D, D);
  AMETHYST_MACRO(A_DT, Period);
  AMETHYST_MACRO(A_E, E);
  AMETHYST_MACRO(A_EN, Enter);
  AMETHYST_MACRO(A_F, F);
  AMETHYST_MACRO(A_H, H);
  AMETHYST_MACRO(A_I, I);
  AMETHYST_MACRO(A_J, J);
  AMETHYST_MACRO(A_K, K);
  AMETHYST_MACRO(A_L, L);
  AMETHYST_MACRO(A_N, N);
  AMETHYST_MACRO(A_P, P);
  AMETHYST_MACRO(A_Q, Q);
  AMETHYST_MACRO(A_R, R);
  AMETHYST_MACRO(A_S, S);
  AMETHYST_MACRO(A_SP, Spacebar);
  AMETHYST_MACRO(A_T, T);
  AMETHYST_MACRO(A_W, W);
  AMETHYST_MACRO(A_Z, Z);

  AMETHYST_MACRO2(A2_SP, Space);
  AMETHYST_MACRO2(A2_H, H);
  AMETHYST_MACRO2(A2_L, L);
  AMETHYST_MACRO2(A2_K, K);
  AMETHYST_MACRO2(A2_J, J);
  AMETHYST_MACRO2(A2_1, 1);
  AMETHYST_MACRO2(A2_2, 2);
  AMETHYST_MACRO2(A2_3, 3);
  AMETHYST_MACRO2(A2_4, 4);
  AMETHYST_MACRO2(A2_5, 5);
  AMETHYST_MACRO2(A2_6, 6);
  AMETHYST_MACRO2(A2_7, 7);
  AMETHYST_MACRO2(A2_8, 8);
  AMETHYST_MACRO2(A2_9, 9);
  AMETHYST_MACRO2(A2_0, 0);
  AMETHYST_MACRO2(A2_W, W);
  AMETHYST_MACRO2(A2_E, E);
  AMETHYST_MACRO2(A2_R, R);
  AMETHYST_MACRO2(A2_Q, Q);
  AMETHYST_MACRO2(A2_T, T);
  AMETHYST_MACRO2(A2_AL, LeftArrow);
  AMETHYST_MACRO2(A2_AR, RightArrow);

  SLACK_MACRO(R_M, "memo");
  SLACK_MACRO(R_Q, "+1");
  SLACK_MACRO(R_H, "heart");
  SLACK_MACRO(R_J, "joy");
  SLACK_MACRO(R_S, "sciencedog");
  SLACK_MACRO(R_N, "neat");
  SLACK_MACRO(R_Y, "eyes");
  SLACK_MACRO(R_V, "wave");

  }
  return MACRO_NONE;
}

/* uint8_t alert1 = 0; */
/* uint8_t alert2 = 0; */
/* uint8_t alert3 = 0; */
/* uint8_t alert4 = 0; */
/* uint8_t alert5 = 0; */
/* uint8_t alert6 = 0; */
/* uint8_t alert7 = 0; */

class : public kaleidoscope::plugin::LEDMode {
  public:
    kaleidoscope::EventHandlerResult afterEachCycle() {
      tryLayer(K_AMETHYST2) || tryLayer(K_BF) || tryLayer(K_ANY) || tryLayer(K_AMETHYST) || tryLayer(K_FN);
      return kaleidoscope::EventHandlerResult::OK;
    }

  protected:
    void update(void) {
      uint16_t now = Kaleidoscope.millisAtCycleStart();
      if ((now - this->last_update) < 20) return; //ms;50fps
      this->last_update = now;
      this->hue = 120;
      cRGB color = hsvToRgb(this->hue, 80, 80);
      ::LEDControl.set_all_leds_to(color);
      /* if (alert1 != 0) { */
      /*   LEDControl.setCrgbAt(0, 9, hsvToRgb(alert1, 255, 255)); */
      /* } */
      /* if (alert2 != 0) { */
      /*   LEDControl.setCrgbAt(0, 10, hsvToRgb(alert2, 255, 255)); */
      /* } */
      /* if (alert3 != 0) { */
      /*   LEDControl.setCrgbAt(0, 11, hsvToRgb(alert3, 255, 255)); */
      /* } */
      /* if (alert4 != 0) { */
      /*   LEDControl.setCrgbAt(0, 12, hsvToRgb(alert4, 255, 255)); */
      /* } */
      /* if (alert5 != 0) { */
      /*   LEDControl.setCrgbAt(0, 13, hsvToRgb(alert5, 255, 255)); */
      /* } */
      /* if (alert6 != 0) { */
      /*   LEDControl.setCrgbAt(0, 14, hsvToRgb(alert6, 255, 255)); */
      /* } */
      /* if (alert7 != 0) { */
      /*   LEDControl.setCrgbAt(0, 15, hsvToRgb(alert7, 255, 255)); */
      /* } */
    }

  private:
    uint16_t last_update = 0;
    uint8_t hue;

    bool tryLayer(uint8_t layer) {
      if (!Layer.isActive(layer)) return false;
      // partially-borrowed from https://github.com/bjc/Kaleidoscope-LayerHighlighter
      for (uint8_t r = 0; r < Kaleidoscope.device().matrix_rows; r++) {
        for (uint8_t c = 0; c < Kaleidoscope.device().matrix_columns; c++) {
          Key k = Layer.lookupOnActiveLayer(KeyAddr(r, c));
          Key layer_key = Layer.getKey(layer, KeyAddr(r, c));
          // r:0;c:0 is program, which we don't want to show as a layer key really.
          uint8_t brightness = ((k != layer_key) || (k == Key_NoKey) || (r == 0 && c == 0)) ? 0 : 255;
          LEDControl.setCrgbAt(KeyAddr(r, c), hsvToRgb(this->hue, 80, brightness));
        }
      }
      return true;
    }
} myLEDEffect;

/* bool alertFocusHook(const char *command) { */
/*   if (strcmp_P(command, PSTR("alert")) != 0) */
/*     return false; */

/*   long which = Serial.parseInt(); */
/*   long hue   = Serial.parseInt(); */

/*   if (which == 1) { */
/*     alert1 = hue; */
/*   } else if (which == 2) { */
/*     alert2 = hue; */
/*   } else if (which == 3) { */
/*     alert3 = hue; */
/*   } else if (which == 4) { */
/*     alert4 = hue; */
/*   } else if (which == 5) { */
/*     alert5 = hue; */
/*   } else if (which == 6) { */
/*     alert6 = hue; */
/*   } else if (which == 7) { */
/*     alert7 = hue; */
/*   } */

/*   return true; */
/* } */

KALEIDOSCOPE_INIT_PLUGINS(
  LEDControl,
  myLEDEffect,
  Macros,
  /* Focus, */
  SpaceCadet
);

static kaleidoscope::plugin::SpaceCadet::KeyBinding spaceCadetMap[] = {
  {  Key_LeftShift,     Key_LeftParen,          250}
  , {Key_RightShift,    Key_RightParen,         250}
  , {Key_LeftGui,       Key_LeftCurlyBracket,   250}
  , {Key_LeftAlt,       Key_RightCurlyBracket,  250}
  , {Key_LeftControl,   Key_LeftBracket,        250}
  , {Key_RightControl,  Key_RightBracket,       250}
  , SPACECADET_MAP_END
};

void setup() {
  /* Serial.begin(9600); */

  Kaleidoscope.setup();

  /* Focus.addHook(FOCUS_HOOK(alertFocusHook, "alert")); */

  SpaceCadet.map = spaceCadetMap;

  myLEDEffect.activate();
}

void loop() {
  Kaleidoscope.loop();
}
