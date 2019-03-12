// -*- mode: c++ -*-
// Copyright 2016 Keyboardio, inc. <jesse@keyboard.io>
// Copyright 2019 Burke Libbey <burke@libbey.me>
// See "LICENSE" for license details

#include "Kaleidoscope.h"
#include "Kaleidoscope-Macros.h"
#include "Kaleidoscope-LEDControl.h"
#include "Kaleidoscope-SpaceCadet.h"
#include "Kaleidoscope-Focus.h"
#include "LEDUtils.h" // for hsvToRgb

enum { R_M, R_Q, R_H, R_J, R_S, R_N, R_Y, R_P, R_V, B_O, B_T, B_F, B_N, B_I, B_R, B_P };
enum { ROOT, K_FN, K_ANY, K_BF, K_NUM };

// To realign a block using vim-easy-align, type `gaip* `
KEYMAPS(
  [ROOT] = KEYMAP_STACKED (

   ___,                Key_1,         Key_2,       Key_3,         Key_4, Key_5, ShiftToLayer(K_NUM),
   Key_Backtick,       Key_Q,         Key_W,       Key_E,         Key_R, Key_T, Key_Tab,
   Key_PageUp,         Key_A,         Key_S,       Key_D,         Key_F, Key_G, /**/
   Key_PageDown,       Key_Z,         Key_X,       Key_C,         Key_V, Key_B, Key_Escape,
   Key_LeftControl,    Key_Backspace, Key_LeftGui, Key_LeftShift, /**/   /**/   /**/
   ShiftToLayer(K_FN), /**/           /**/         /**/           /**/   /**/   /**/

   ShiftToLayer(K_ANY), Key_6,       Key_7,        Key_8,            Key_9,      Key_0,         ShiftToLayer(K_NUM),
   Key_Enter,           Key_Y,       Key_U,        Key_I,            Key_O,      Key_P,         Key_Equals,
   /**/                 Key_H,       Key_J,        Key_K,            Key_L,      Key_Semicolon, Key_Quote,
   ShiftToLayer(K_BF),  Key_N,       Key_M,        Key_Comma,        Key_Period, Key_Slash,     Key_Minus,
   Key_RightShift,      Key_LeftAlt, Key_Spacebar, Key_RightControl, /**/        /**/           /**/
   ShiftToLayer(K_FN)   /**/         /**/          /**/              /**/        /**/           /**/

   ), [K_FN] = KEYMAP_STACKED (

   ___,      Key_F1,          Key_F2,     Key_F3, Key_F4, Key_F5, Key_CapsLock,
   Key_Tab,  ___,             ___,        ___,    ___,    ___,    ___,
   Key_Home, ___,             ___,        ___,    ___,    ___,    /**/
   Key_End,  Key_PrintScreen, Key_Insert, ___,    ___,    ___,    ___,
   ___,      Key_Delete,      ___,        ___,    /**/    /**/    /**/
   ___,      /**/             /**/        /**/    /**/    /**/    /**/

   Consumer_ScanPreviousTrack, Key_F6,                 Key_F7,                   Key_F8,                   Key_F9,          Key_F10,          Key_F11,
   Consumer_PlaySlashPause,    Consumer_ScanNextTrack, Key_LeftCurlyBracket,     Key_RightCurlyBracket,    Key_LeftBracket, Key_RightBracket, Key_F12,
   /**/                        Key_LeftArrow,          Key_DownArrow,            Key_UpArrow,              Key_RightArrow,  ___,              ___,
   Key_PcApplication,          Consumer_Mute,          Consumer_VolumeDecrement, Consumer_VolumeIncrement, ___,             Key_Backslash,    Key_Pipe,
   ___,                        ___,                    Key_Enter,                ___,                      /**/             /**/              /**/
   ___                         /**/                    /**/                      /**/                      /**/             /**/              /**/

  ), [K_ANY] =  KEYMAP_STACKED (

   ___, ___, ___, ___, ___,    ___,    ___,
   ___, ___, ___, ___, M(B_R), M(B_T), ___,
   ___, ___, ___, ___, M(B_F), ___,    /**/
   ___, ___, ___, ___, ___,    ___,    ___,
   ___, ___, ___, ___, /**/    /**/    /**/
   ___, /**/ /**/ /**/ /**/    /**/    /**/

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
   ___, ___,    ___, ___, /**/    /**/ /**/
   ___, /**/    /**/ /**/ /**/    /**/ /**/

   ___, ___,    ___,    ___,    ___, ___,    ___,
   ___, ___,    ___,    M(R_Y), ___, M(R_P), ___,
   /**/ M(R_H), M(R_J), ___,    ___, ___,    ___,
   ___, M(R_N), M(R_M), ___,    ___, ___,    ___,
   ___, ___,    ___,    ___,    /**/ /**/    /**/
   ___  /**/    /**/    /**/    /**/ /**/    /**/


  ), [K_NUM] = KEYMAP_STACKED (

   ___, ___, ___, ___, ___, ___, ___,
   ___, ___, ___, ___, ___, ___, ___,
   ___, ___, ___, ___, ___, ___, /**/
   ___, ___, ___, ___, ___, ___, ___,
   ___, ___, ___, ___, /**/ /**/ /**/
   ___, /**/ /**/ /**/ /**/ /**/ /**/

   ___, ___, ___, ___, ___, ___, ___,
   ___, ___, ___, ___, ___, ___, ___,
   /**/ ___, ___, ___, ___, ___, ___,
   ___, ___, ___, ___, ___, ___, ___,
   ___, ___, ___, ___, /**/ /**/ /**/
   ___  /**/ /**/ /**/ /**/ /**/ /**/

  )
)

static const int spaceCadetTimeout = 250;
static kaleidoscope::SpaceCadet::KeyBinding spaceCadetMap[] = {
  {  Key_LeftShift,     Key_LeftParen,          spaceCadetTimeout}
  , {Key_RightShift,    Key_RightParen,         spaceCadetTimeout}
  , {Key_LeftGui,       Key_LeftCurlyBracket,   spaceCadetTimeout}
  , {Key_LeftAlt,       Key_RightCurlyBracket,  spaceCadetTimeout}
  , {Key_LeftControl,   Key_LeftBracket,        spaceCadetTimeout}
  , {Key_RightControl,  Key_RightBracket,       spaceCadetTimeout}
  , SPACECADET_MAP_END
};

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

const macro_t *macroAction(uint8_t macroIndex, uint8_t keyState) {
  switch (macroIndex) {

  BROWSE_MACRO(B_O, O);
  BROWSE_MACRO(B_N, N);
  BROWSE_MACRO(B_T, T);
  BROWSE_MACRO(B_F, F);
  BROWSE_MACRO(B_I, I);
  BROWSE_MACRO(B_R, R);
  BROWSE_MACRO(B_P, P);

  SLACK_MACRO(R_M, "memo");
  SLACK_MACRO(R_Q, "+1");
  SLACK_MACRO(R_H, "heart");
  SLACK_MACRO(R_J, "joy");
  SLACK_MACRO(R_S, "sciencedog");
  SLACK_MACRO(R_N, "neat");
  SLACK_MACRO(R_Y, "eyes");
  SLACK_MACRO(R_V, "wave");

  case R_P:
    SLACK_REACT("parrotwave1", true);
    SLACK_REACT("parrotwave2", true);
    SLACK_REACT("parrotwave3", true);
    SLACK_REACT("parrotwave4", true);
    SLACK_REACT("parrotwave5", true);
    SLACK_REACT("parrotwave6", true);
    SLACK_REACT("parrotwave7", false);
    break;

  }
  return MACRO_NONE;
}

uint8_t alert1 = 0;
uint8_t alert2 = 0;
uint8_t alert3 = 0;
uint8_t alert4 = 0;
uint8_t alert5 = 0;
uint8_t alert6 = 0;
uint8_t alert7 = 0;

class : public kaleidoscope::LEDMode {
  public:
    kaleidoscope::EventHandlerResult afterEachCycle() {
      tryLayer(K_BF) || tryLayer(K_ANY) || tryLayer(K_NUM) || tryLayer(K_FN);
      return kaleidoscope::EventHandlerResult::OK;
    }

  protected:
    void update(void) {
      uint16_t now = Kaleidoscope.millisAtCycleStart();
      if ((now - this->last_update) < 20/*ms;50fps*/) return;
      this->last_update = now;
      this->hue = (uint16_t)millis() >> 7; // like breathe, ~1cpm
      cRGB color = hsvToRgb(this->hue, 80, breathe(5));
      ::LEDControl.set_all_leds_to(color);
      if (alert1 != 0) {
        LEDControl.setCrgbAt(0, 9, hsvToRgb(alert1, 255, 255));
      }
      if (alert2 != 0) {
        LEDControl.setCrgbAt(0, 10, hsvToRgb(alert2, 255, 255));
      }
      if (alert3 != 0) {
        LEDControl.setCrgbAt(0, 11, hsvToRgb(alert3, 255, 255));
      }
      if (alert4 != 0) {
        LEDControl.setCrgbAt(0, 12, hsvToRgb(alert4, 255, 255));
      }
      if (alert5 != 0) {
        LEDControl.setCrgbAt(0, 13, hsvToRgb(alert5, 255, 255));
      }
      if (alert6 != 0) {
        LEDControl.setCrgbAt(0, 14, hsvToRgb(alert6, 255, 255));
      }
      if (alert7 != 0) {
        LEDControl.setCrgbAt(0, 15, hsvToRgb(alert7, 255, 255));
      }
    }

  private:
    uint16_t last_update = 0;
    uint8_t hue;

    // Mostly lifted from LEDUtils. value changes each 2^shift milliseconds,
    // meaning total period is 255*(2^shift) milliseconds,
    // thus, cycles per minute is 60000/(255*(2^shift)).
    // 2: ~58cpm; 4: ~14cpm; 5: ~7cpm; 7: ~1cpm.
    uint8_t breathe(uint8_t shift) {
      uint8_t i = (uint16_t)millis() >> shift;
      if (i & 0b10000000) i = 0xFF - i;
      i = i << 1;
      uint8_t ii = (i * i) >> 8;
      uint8_t iii = (ii * i) >> 8;
      return (((3 * (uint16_t)(ii)) - (2 * (uint16_t)(iii))) / 2) + 80;
    }

    bool tryLayer(uint8_t layer) {
      if (!Layer.isOn(layer)) return false;
      // partially-borrowed from https://github.com/bjc/Kaleidoscope-LayerHighlighter
      for (uint8_t r = 0; r < ROWS; r++) {
        for (uint8_t c = 0; c < COLS; c++) {
          Key k = Layer.lookupOnActiveLayer(r, c);
          Key layer_key = Layer.getKey(layer, r, c);
          // r:0;c:0 is program, which we don't want to show as a layer key really.
          uint8_t brightness = ((k != layer_key) || (k == Key_NoKey) || (r == 0 && c == 0)) ? 0 : 255;
          LEDControl.setCrgbAt(r, c, hsvToRgb(this->hue, 80, brightness));
        }
      }
      return true;
    }
} myLEDEffect;

KALEIDOSCOPE_INIT_PLUGINS(
  LEDControl,
  myLEDEffect,
  Macros,
  Focus,
  SpaceCadet
);

bool alertFocusHook(const char *command) {
  if (strcmp_P(command, PSTR("alert")) != 0)
    return false;

  long which = Serial.parseInt();
  long hue   = Serial.parseInt();

  if (which == 1) {
    alert1 = hue;
  } else if (which == 2) {
    alert2 = hue;
  } else if (which == 3) {
    alert3 = hue;
  } else if (which == 4) {
    alert4 = hue;
  } else if (which == 5) {
    alert5 = hue;
  } else if (which == 6) {
    alert6 = hue;
  } else if (which == 7) {
    alert7 = hue;
  }

  return true;
}

void setup() {
  Serial.begin(9600);

  Kaleidoscope.setup();

  Focus.addHook(FOCUS_HOOK(alertFocusHook, "alert"));

  SpaceCadet.map = spaceCadetMap;
  myLEDEffect.activate();
}

void loop() {
  Kaleidoscope.loop();
}
