# TouchOSC template for the OB-Xd Virtual Analog Synthesizer

[TouchOSC](https://hexler.net/touchosc/) template for the
[Oberheim OB-Xd Virtual Analog Synthesizer](https://www.discodsp.com/obxd/) (and
possibly other Oberheim OB-X/OB-Xa software emulations).

The layout and functionality of this template were created using OB-Xd versions
3.5.3 through 3.6.

## Contents

- [TouchOSC template for the OB-Xd Virtual Analog Synthesizer](#touchosc-template-for-the-ob-xd-virtual-analog-synthesizer)
  - [Contents](#contents)
  - [Screenshots](#screenshots)
  - [Supported features](#supported-features)
    - [Integrated keyboard](#integrated-keyboard)
  - [Usage](#usage)
  - [Download](#download)
  - [Bug reports, Feature Suggestions or Contributing](#bug-reports-feature-suggestions-or-contributing)
  - [Links](#links)
  - [Donations](#donations)


## Screenshots

![image](https://github.com/user-attachments/assets/493e5e03-a45f-44b0-95d1-2519832f6de6)

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
  
  *The "discoDSP" folder is located in the "Documents" folder in your user's
  `$HOME` directory. The exact naming and location of the "Documents" folder
  differ between operating systems and distributions. Consult the discoDSP
  documentation if you are unsure about the folder location.*

  Restart OB-Xd. The MIDI menu should now show **"TouchOsc"** as a new MIDI mappings
  option.

- All faders use a small lua script to ensure high-precision, smooth input
  curves. This script minimizes sudden value "jumps" when starting to
  manipulate a control, and allows for reliable fine-tuning of each fader's
  current position.

  - Double-tapping on a fader will reset it to its default zero or center
    position.

- MIDI and true value display:

  Upon touch, all faders show a value tooltip with
  the current MIDI value, or for some faders, a true control value to aid in
  fine-tuning.
  
  **Note:** True value displays are only approximations of the actual value in
  OB-Xd. If the value is a little bit off ..just go by ear ;)

- Surface zoom:

  Double-tap on a section heading or on background/borders to zoom into that
  section. Swipe to move around the surface. Double-tap again to zoom out. (The
  zoom feature is based on the awesome zoom scripts found in this
  [GitHub repository](https://github.com/tshoppa/touchOSC/tree/main) by
  tshoppa!)

- Preset manager:

  The template comes with its own preset manager. These presets are not linked
  to the OB-Xd presets, but, if you enable MIDI OUT feedback in OB-Xd (v3.5 and
  higher), you can copy over and save your favorite presets into the surface.

  The preset manager offers a direct access mode for live switching between
  existing presets, copy and paste presets between slots, as well as a basic
  preset crossfader.

  For a full feature list and usage description, check out the
  [Shiva Preset Manager README at GitHub](https://github.com/bobbadshy/touchosc_shiva_preset_manager)!
  (I desigend the preset manager to be modular. So, you can also re-use it
  separately for your own TouchOSC surfaces.)

### Integrated keyboard

The integrated keyboard currently includes:

- Pitchbend slider, with toggle switch for half or full MIDI range. Full MIDI
  range by default maps to two semitones, so the toggle will switch between one
  semitone and a full tone.

- Octave and transpose buttons.

- Positional velocity, and optional aftertouch modulation support on the keys.

  Velocity is controlled by the initial touch position on the keys: bottom of
  keys is loudest, top is the most quiet.
  
  Modulation (MIDI cc1) is engaged by sliding up or down on the keys. The
  modulation will stay active after releasing the keys. It will automatically
  reset when all keys are released and then a new key is pressed. This behaviour
  seemed the most intuitive, so modulation stays active after releasing the
  keys, but when you continue playing again, it will do so without modulation.

  **Extended keyboard features:** In addition, the keyboard also supports global
  MIDI channel pressure, and individual keys polyphonic aftertouch, as well as
  registering *horizontal* movement on pressed keys. These features are disabled
  by default, since (to my knowledge) OB-Xd does not support MIDI aftertouch. If
  however, you want to play some other synth with the keyboard, you can enable
  these features in the keyboard's settings panel. :)

- "Keys Sustain" button (MIDI cc66 "Sustenuto pedal").

  When Sustenuto is engaged, all currently pressed keys *are held* on releasing
  the keys. So, for example, you can hold a chord, and then play some melody
  over it. The "Keys Sustain" button supports stacking: Tap once to sustain all
  currently pressed keys. Tap again to add new keys. Double-tap or hold and
  release to cancel the sustenuto (hold and release for exactly timed cancel
  upon button release). You can also switch octaves on the keyboard while
  sustain is being held! Play a bass note and sustain it, switch octave, and
  play a melody on top. :)


## Usage

- Download and open the `.tosc` file in TouchOSC.
- Start up OB-Xd and the rest of your music setup and enjoy!


## Download

Check the [Releases](https://github.com/bobbadshy/touchosc_obxd_template/releases) section.

## Bug reports, Feature Suggestions or Contributing

*This is currently a brand new project. First RC release was Jan 2025. So, while
it seems to work well already, please keep in mind that it is **currently in
testing and not ready for production**. Thank you!*

Please file an issue in the [Issues](https://github.com/bobbadshy/touchosc_obxd_template/issues) section.

As this is just a hobby project in my freetime, I cannot promise I will get to
any of them, but nevertheless, suggestions and bug reports are welcome! 🙂

If you have any ideas or want to contribute to the project yourself, feel free
to fork it and submit the changes back to me.

## Links

- [OB-Xd Virtual Analog Synthesizer from discoDSP](https://www.discodsp.com/obxd/)
- [Hexler TouchOSC](https://hexler.net/touchosc)
- [TouchOSC Scripting API](https://hexler.net/touchosc/manual/script)
- Zoom script and many other useful TouchOSC [modules and plugins by tshoppa](https://github.com/tshoppa/touchOSC/tree/main)

## Donations

This is an Open Source software and free to use for everyone in any which way possible (..well, as long as it stays Open Source, licensed under GPL-3.0 license)! 🙂

|    |  PayPal  |
| -- | -------- |
|  If you feel this template made your life a lot easier, and that it is exacly the thing you were looking for, then you can buy me a beer 🍺 (..or beers 🍻..) and I will merrily put out a toast to you for saving yet another evening! 😃<br><br>*(I currently only have a PayPal button, but I may check out getting a Patreon or some "Buy me a coffee" in the future.)* |  [![image](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/donate?hosted_button_id=CGDJVVGG5V8LU&)  |


Many Thanx and Enjoy!
