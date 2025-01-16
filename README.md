# TouchOSC template for the OB-Xd Virtual Analog Synthesizer

[TouchOSC](https://hexler.net/touchosc/) template for the
[Oberheim OB-Xd Virtual Analog Synthesizer](https://www.discodsp.com/obxd/) (and
possibly other Oberheim OB-X/OB-Xa software emulations).

The layout and functionality of this template were created using OB-Xd versions
3.5.3 through 3.6.



## Contents

- [TouchOSC template for the OB-Xd Virtual Analog Synthesizer](#touchosc-template-for-the-ob-xd-virtual-analog-synthesizer)
  - [Contents](#contents)
  - [Supported features](#supported-features)
    - [Integrated Keyboard](#integrated-keyboard)
  - [Preliminary screenshots](#preliminary-screenshots)
  - [Download](#download)
  - [Bug reports, Feature Suggestions or Contributing](#bug-reports-feature-suggestions-or-contributing)
  - [Links](#links)
  - [Donations](#donations)


## Supported features

- All controls of the OB-Xd virtual synth have been implemented. The control
  layout closely follows the OB-Xd "IIkka Rosma Dark" default skin.

- MIDI mappings match the default mappings found in OB-Xd v3.6. So all
  controls should work out of the box, with no further setup neccessary.

  The template also contains a MIDI mappings XML file for OB-Xd. If some MIDI
  mappings do not work as expected (OB-Xd versions below 3.6), try to copy:
  
  [./midi_mapping/TouchOsc.xml](./midi_mapping/TouchOsc.xml)
  
  from this template into your documents "discoDSP" folder:
  
   ... /discoDSP/OB-Xd 3/MIDI/TouchOsc.xml
  
  *This "discoDSP" folder is located in the "Documents" folder in your user's
  `$HOME` directory. The exact naming of the "Documents" folder differs between
  operating systems and distributions. Consult the discoDSP documentation if you
  are unsure about the folder location.*

  Restart OB-Xd. The MIDI menu should now show **"TouchOsc"** as a new MIDI mappings
  option.

- All faders use a small lua script to ensure high-precision, smooth input
  curves. This script minimizes sudden value "jumps", when starting to
  manipulate a control, and allows for reliable fine-tuning of each fader's
  current position.

  - Double-tapping on a fader will reset it to its default zero position.

- MIDI and true value display:

  Upon touch, all faders show a value tooltip with
  the current MIDI value, or for some faders, a true control value to aid in
  fine-tuning.
  
  **Note:** True value displays are only approximations of the actual value in OB-Xd. If the value is a little bit off ..just go by ear ;)

- Surface zoom:

  Double-tap on a section heading or on background/borders to zoom into that
  section. Swipe to move around the surface. Double-tap again to zoom out. (The
  zoom feature is based on the awesome zoom scripts found in this
  [Github repository](https://github.com/tshoppa/touchOSC/tree/main) by
  tshoppa.)

- Preset manager:

  The template comes with its own preset manager. These presets are not linked
  to the OB-Xd presets, but, if you enable MIDI OUT feedback in OB-Xd (v3.5 and
  higher), you can copy over and save your favorite factory presets into the
  surface.

  The preset manager offers a Direct access mode for live switching between
  existing presets, copy and paste presets between slots, as well as a basic
  preset crossfader.

  For a full feature list and usage description, check out the
  [Shiva Preset Manager README at GitHub](https://github.com/bobbadshy/touchosc_shiva_preset_manager)!
  (The preset manager is another one of my TouchOSC template projects, and is
  designed to be modular. So, you can also re-use it separately for your own
  TouchOSC surfaces.)

### Integrated Keyboard

The integrated keyboard currently includes:

- Pitchbend slider, with toggle switch for half or full MIDI range. Full MIDI
  range by default maps to two semitones, so the toggle will switch between one
  semitone and a full tone by default.
- Octave and transpose buttons
- Optional aftertouch modulation support on the keys. If enabled, sliding up or
  down on the keys will engage modulation (MIDI cc1). The modulation is held
  after releasing all keys, and resets once you press a new key.

- Velocity, Aftertouch, and optional modulation support *on each key*.
- 
- , as well
  as a keys sustain button (MIDI cc66 "sustenuto").

  Velocity, aftertouch and modulation are controlled by the vertical and
  horizontal touch position on the keys. The initial touch point controls
  velocity. Then, move up/down, or left/right on the key to control aftertouch
  and modulation.

  The "Keys Sustain" button supports stacking: Tap once to sustain all currently
  pressed keys. Tap again to add new keys. Long-tap or double-tap to cancel
  sustain.

  **Note:** The keyboard supports both MIDI global channel aftertouch, as well
  as polyphonic aftertouch on each key. OB-Xd only registers channel aftertouch,
  but, if you want to play some other synth with the keyboard, polyphonic
  aftertouch is available.

## Preliminary screenshots

![image](https://github.com/user-attachments/assets/412b9422-2c19-4239-a6b8-747798dd9e60)

## Download

First alpha release available in the [Releases](https://github.com/bobbadshy/touchosc_obxd_template/releases) section. Expect bugs!! ;)

## Bug reports, Feature Suggestions or Contributing

This is currently in dev alpha state .. let me fix some bugs first and get a beta ready. At that point, suggestions and bug reports will be very welcome! 🙂

## Links

- [OB-Xd Virtual Analog Synthseizer from discoDSP](https://www.discodsp.com/obxd/)
- [Hexler TouchOSC](https://hexler.net/touchosc)
- [TouchOSC Scripting API](https://hexler.net/touchosc/manual/script)

## Donations

This is an Open Source software and free to use for everyone in any which way possible! :)

|    |  PayPal  |
| -- | -------- |
|  If you feel this template made your life a lot easier, and that it is exacly the thing you were looking for, then you can buy me a beer 🍺 (..or beers 🍻..) and I will merrily put out a toast to you for saving yet another evening! 😃<br><br>*(I currently only have a PayPal button, but I may check out getting a Patreon or some "Buy me a coffee" in the future.)* |  [![image](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/donate?hosted_button_id=CGDJVVGG5V8LU&)  |


Many Thanx and Enjoy!
