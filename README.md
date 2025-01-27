# TouchOSC template for the OB-Xd Virtual Synthesizer

[TouchOSC](https://hexler.net/touchosc/) template for the
[Oberheim OB-Xd Virtual Synthesizer](https://www.discodsp.com/obxd/) (and
possibly other Oberheim OB-X/OB-Xa software emulations).

Layout and functionality of this template were created using OB-Xd versions
3.5.3 through 3.6. Check out the detailed feature list below!

If you like this software, and use it frequently or in a commercial context,
please consider donating to support further development! Check out the
[Donations](#donations) section at the end of this Readme. Thank you! 🙂

## Contents

- [TouchOSC template for the OB-Xd Virtual Synthesizer](#touchosc-template-for-the-ob-xd-virtual-synthesizer)
  - [Contents](#contents)
  - [Screenshots](#screenshots)
  - [Supported features](#supported-features)
    - [OB-Xd support](#ob-xd-support)
    - [Controls and faders](#controls-and-faders)
    - [Surface zoom](#surface-zoom)
    - [Shiva Preset manager](#shiva-preset-manager)
  - [Integrated keyboard](#integrated-keyboard)
    - [Keyboard settings panel](#keyboard-settings-panel)
    - [Positional velocity and modulation support](#positional-velocity-and-modulation-support)
    - [MIDI channelpressure and polyphonic aftertouch](#midi-channelpressure-and-polyphonic-aftertouch)
    - [Keys Sustain – MIDI cc66 "Sustenuto"](#keys-sustain--midi-cc66-sustenuto)
    - [Mapping up to five additional MIDI cc controls to keys aftertouch](#mapping-up-to-five-additional-midi-cc-controls-to-keys-aftertouch)
    - [Floating keyboard controls panel](#floating-keyboard-controls-panel)
  - [MIDI Looper control button](#midi-looper-control-button)
    - [Supported looper software](#supported-looper-software)
      - [Tested software](#tested-software)
    - [Loop button configuration](#loop-button-configuration)
    - [Loop button states](#loop-button-states)
    - [Loop button operation](#loop-button-operation)
    - [Planned loop button features](#planned-loop-button-features)
  - [Usage](#usage)
  - [Download](#download)
  - [Bug reports, Feature Suggestions or Contributing](#bug-reports-feature-suggestions-or-contributing)
  - [Planned features](#planned-features)
  - [Links](#links)
  - [Donations](#donations)


## Screenshots

![alt text](./docs/images/main-view-logo.png?raw=true)

## Supported features

### OB-Xd support

- All controls of the OB-Xd virtual synth have been implemented. The control
  layout closely follows the OB-Xd "IIkka Rosma Dark" default skin.

- MIDI mappings match the default mappings found in OB-Xd v3.6. So all
  controls should work out of the box, with no further setup neccessary.

  The template also contains a MIDI mappings XML file for OB-Xd. If some MIDI
  mappings do not work as expected (OB-Xd versions below 3.6), try to copy:
  
  [./extra_files/obxd_midi_mapping/TouchOsc.xml](./extra_files/obxd_midi_mapping/TouchOsc.xml?raw=true)
  
  from this template into your documents "discoDSP" folder:
  
   ... /discoDSP/OB-Xd 3/MIDI/TouchOsc.xml
  
  *The "discoDSP" folder is located in the "Documents" folder in your user's
  `$HOME` directory. The exact naming and location of the "Documents" folder
  differ between operating systems and distributions. Consult the discoDSP
  documentation if you are unsure about the folder location.*

  Restart OB-Xd. The MIDI menu should now show **"TouchOsc"** as a new MIDI mappings
  option.

- Limitations on manipulating the two oscillators in OB-Xd:

  MIDI has the well-known limitation of only supporting 128 discrete steps on CC
  messages, this resolution is, of course, not enough for true continuous
  manipulation of the available oscillator ranges.
  
  While OB-Xd does offer a fine-control setting in the GUI, at the current
  version 3.6, this control is also limited to discrete steps. As such, the
  controls in this surface are *almost on-par* with the resolution available in
  the OB-Xd GUI. Maybe in a future version, OB-Xd will improve the oscillator
  controls, and also add high resolution MIDI support. (MIDI has the option to
  send high resolution values encoded in MSB and LSB bit values, as for example,
  is the default mode for MIDI pitchbend message.)


### Controls and faders

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

### Surface zoom

Double-tap on a section heading or on background/borders to zoom into that
section. Swipe to move around the surface. Double-tap again to zoom out.

The zoom feature is based on the awesome zoom scripts found in this
[GitHub repository](https://github.com/tshoppa/touchOSC/tree/main) by tshoppa!)

### Shiva Preset manager

The template comes with its own preset manager. These presets are not linked to
the OB-Xd presets, but, if you enable MIDI OUT feedback in OB-Xd (v3.5 and
higher), you can copy over and save your favorite presets into the surface.

The preset manager offers a direct access mode for live switching between
existing presets, copy and paste presets between slots, as well as a basic
preset crossfader.

For a full feature list and usage description, check out the
[Shiva Preset Manager README at GitHub](https://github.com/bobbadshy/touchosc_shiva_preset_manager)!
(I designed the preset manager to be modular. So, you can also re-use it
separately for your own TouchOSC surfaces.)

**Preset manager screenshots**

| | Preset manager | |
| --- | --- | -- |
| Extended mode | Direct Access mode | Crossfader active |
| ![alt text](./docs/images/presets_main.jpeg?raw=true) | ![alt text](./docs/images/presets_direct.jpeg?raw=true) | ![alt text](./docs/images/presets_fading.jpeg?raw=true) |
|  Preset name entry  |  Settings panel  | "Restore Work" button and<br>**\*changed\*** controls indication |
| ![alt text](./docs/images/presets_name_entry.jpeg?raw=true) | ![alt text](./docs/images/presets_settings.jpeg?raw=true) | ![alt text](./docs/images/presets_changed_notice.jpeg?raw=true) |

## Integrated keyboard

The integrated keyboard currently includes:

- Pitchbend slider, with toggle switch for half or full MIDI range. Full MIDI
  range by default maps to two semitones, so the toggle will switch between one
  semitone and a full tone.

- Octave and transpose buttons.

### Keyboard settings panel

The keyboard features can be configured on the "Keyboard settings" panel. Tap
the arrow button on the right of the keyboard controls section to show or hide
the panel.

### Positional velocity and modulation support

The keys support registering vertical, as well as horizontal touch movement.

Velocity is controlled by the initial touch position on the keys: bottom of keys
is loudest, top is the most quiet.

Modulation (MIDI cc1) is engaged by sliding up or down on the keys. The
modulation will stay active after releasing the keys. It will reset only after
all keys have been released, and then when a new key is pressed. This behaviour
seemed the most intuitive, so modulation stays active on the sound after
releasing the keys. When playing is continued, modulation will reset to zero.

**Note:** If you wish to have finer, and full manual control of modulation, the
pitchbend slider can be switched to control modulation instead of pitch.

### MIDI channelpressure and polyphonic aftertouch

The keyboard also supports both global MIDI channel pressure, and individual
keys polyphonic aftertouch. These options can be enabled in the keyboard
settings, to control hardware or software instruments with support for these
features.

- ***Note:** OB-Xd does not support MIDI aftertouch. Read below for alternative
  options to use aftertouch support with OB-Xd!*

### Keys Sustain – MIDI cc66 "Sustenuto"

The keyboard features a "Keys Sustain" control which engages MIDI cc66
"Sustenuto".

When Sustenuto is activated, all currently pressed keys *are held* on releasing
the keys. So, for example, you can hold a chord, and then play some melody over
it. The "Keys Sustain" button supports stacking: Tap once to sustain all
currently pressed keys. Tap again to add new keys. Double-tap or hold and
release to cancel the sustenuto (hold and release for exactly timed cancel upon
button release). You can also switch octaves on the keyboard while sustain is
being held! Play a bass note and sustain it, switch octave, and play a melody on
top. :)

- ***Note:** The keyboard will also respond to MIDI cc66 messages when received
  over MIDI!*

### Mapping up to five additional MIDI cc controls to keys aftertouch

As an advanced feature, the keyboard supports mapping arbitrary MIDI cc messages
onto the vertical or horizontal axis. The horizontal axis offers one slot, the
vertical axis offers to slots that disengage on key release, and two slots that
disengage on the next key press after releasing all keys (same as the modulation
feature).

- **Important:** This feature is not tied to the controls of this control
  surface, but uses regular MIDI messages. Because of this, MIDI Input *must be
  connected* in order to sense the MIDI CC number of a control! If you already
  have MIDI feedback from OB-Xd routed back to the template, you should be able
  to sense controls without problems. If you do not have MIDI input connected,
  use MIDI Through to loop the control surface *back to itself* so that it can
  read the MIDI CC messages sent by its controls.

With this feature, you can add aftertouch functionality when playing any
hardware or software instrument. For example, to control aftertouch volume,
bind to Master volume, to the envelope's sustain control, or to one of the
osclillator mix controls. Manipulate the sound shape by binding to the cutoff
frequency, resonance mix, etc.

### Floating keyboard controls panel

The keyboard features an additional floating controls panel. This panel offers
bigger controls for some of the keyboard functions. Currently, the panel
includes bigger versions of the "Keys Sustain" and the "Midi Looper" control
button. 

*(In future versions, I will probably also add an XY pad, and maybe some other
faders to the floating panel, to allow easy control of modulation and filter
parameters.)*

Tap the detach button on the right of the keyboard controls section to show or
hide the floating controls panel.

**Keyboard screenshots**

- Main controls:

![alt text](./docs/images/kbd_main_controls.png?raw=true)

- Keyboard settings panel:

![alt text](./docs/images/kbd_settings.jpeg?raw=true)

- Keyboard floating controls panel:

![alt text](./docs/images/kbd-floating-controls.png?raw=true)

## MIDI Looper control button

The keyboard offers an optional "MIDI Looper" button that can be used to control
external looping software over MIDI. The button uses a complex control scheme to
allow manipulating most looping operations through a single control. The
button's control scheme is based on control schemes commonly found on
single-button hardware loopers.

### Supported looper software

The loop button should work with most looping software, as long as the software
supports binding to its functions with MIDI note_on messages. To be used with
the button, the software needs to expose all or a subset of these functions:

- Record start/stop
  - Bind to MIDI note_on 36, value 0/127
- Overdub start/stop
  - *Bind to MIDI note_on 37, value 0/127*
- Mute/Unmute
  - *Bind to MIDI note_on 38, value 0/127*
- Undo
  - *Bind to MIDI note_on 39, value 127*
- Redo
  - *Bind to MIDI note_on 40, value 127*
- Pause_ON (or Reset)
  - *Bind to MIDI note_on 41, value 0/127*

#### Tested software

The loop button was programmed and tested in detail with the
[SooperLooper](https://sonosaurus.com/sooperlooper/features.html) software on
Linux.

The template contains a ready-made MIDI mappings file for SooperLooper at:

- [extra_files/sooperlooper/midi.slb](extra_files/sooperlooper/midi.slb)

Open "Preferences" > "MIDI Bindings" in SooperLooper to load the MIDI mappings.
After loading, all button operations should work fine with SooperLooper.

### Loop button configuration

The loop button uses its own MIDI channel, separate from the template's main
channel. Open the "Keyboard settings" panel, and scroll down to the "Looper"
section to edit the MIDI channel for the loop button.

### Loop button states

The button will indidcate several different play and recording states through
color and/or pulsing.

**The possible button states are:**

- **Initialized** – Corners shown, and half-lit in base color:
  
  *No initial loop has been recorded, yet.*

- **Playing** – Button lights up green:

  *Recorded loop material is being played.*

- **Muted** – Button pulses green:

  *The loop continues playing, but output is muted.*

- **Record armed** – Button pulses red:

  *When recording starts, previous loop material will be replaced with the new loop.*

- **Record** – Button lights up red:

  *Material is being recorded into a new loop.*

- **Overdub armed** – Button pulses orange:

  *When recording starts, new material will be added to existing loop.*

- **Overdub** – Button lights up orange:

  *Material is being added to the existing loop.*

- **Undo triggered** – Button lights up yellow:

  *If the looper supports it, the last recorded material is removed form the
  loop.*

- **Redo triggered** – Button lights up purple:

  *If the looper supports it, the previously removed material is is re-added to the loop.*

  **Important:** The button will toggle between Undo and Redo based on its own
  internal state, and will not process any feedback info from the looper.
  Usually, this should not present a problem, as long as the Undo and Redo
  actions are correctly bound to and processed by the respective functions in
  the looper.

### Loop button operation

To start looping, tap once to initialize the button into looping mode. The
button shows corners, and is half-lit once initalized.

After initialization, tap once to arm for the first loop recording (button
pulses red). Only record arm is available immediately after initializing (no
overdub), as no starting loop is present in the looper, yet.

Once you're ready, tap again to start recording the initial loop. After
initializing and recording the first loop, the following actions can be
triggered:


- When in  state **"Playing"** or **"Muted"** (button is green):

  - **Double-tap** to toggle between muted and play state.

  - **Long-tap (tap and hold)** to trigger "Undo" or "Redo" action. So, this
    toggles between removing the last played material, and re-adding it to the
    loop.

  - **Tap once** to switch to "Overdub armed" mode.

  - **Double-tap and hold** to switch to "Record armed" mode.

- When in state **"Overdub armed"** or **"Record armed"** (button pulses orange or red):

  - **Tap once** to start recording or overdubbing.

  - **Long-tap (tap and hold)** to cancel armed mode, and return to previous
    play or muted state.

- When in state **"Overdub"** or **"Record"** (button is orange or red):

  - **Tap once** to stop recording or overdubbing.

  - **Double-tap** to stop recording or overdubbing, and also immediately switch
    to "Muted" state afterwards.

- When in **ANY** state, except for recording or overdubbing:

  - **Long-tap and hold for ~3 seconds** will unarm the looper and do a full
    reset (as far as the used looper allows it).
    
    The looper will send MIDI note_on 41, value 127, to the looper. So,
    depending on what the looper supports, this can be bound to the looper's
    "pause" or "reset" function.

### Planned loop button features

- Additional buttons to extend the supported range of functions, e.g. multiple
  loops with solo and mute support, record in "replace" or "multiply" mode etc.
- Test with other looper software to ensure the MIDI message scheme plays well
  also with other loopers.
- Add support (switchable option) for loopers that go from record stop directly
  back into overdub mode. (For now, please configure your software to switch to
  normal play after record stop, for it to stay in sync with the loop button
  state.)
- ...


## Usage

- Download the latest release.
- Open `obxd.tosc` or `obxd_plain.tosc` in TouchOSC. The "plain" version uses a
  simple background, instead of stylized backdrops.

- Start up OB-Xd and the rest of your music setup, and enjoy!


## Download

Check the [Releases](https://github.com/bobbadshy/touchosc_obxd_template/releases) section.

## Bug reports, Feature Suggestions or Contributing

*This is currently a brand new project. First RC release was Jan 2025. So, while
it seems to work well already, please keep in mind that it is **currently still
in testing**. Thank you!*

Please file issues or feature suggestions in the
[Issues](https://github.com/bobbadshy/touchosc_obxd_template/issues) section.

As this is just a hobby project in my freetime, I cannot promise I will get to
any of them, but nevertheless, suggestions and bug reports are welcome! 🙂

If you have any ideas or want to contribute to the project yourself, feel free
to fork it and submit the changes back to me.

## Planned features

- Light color scheme
- Randomize button, with a toggle to individually include/exclude each controls
  section from randomize. The preset manager actually already has a randomize
  button in its settings panel. However, "Randomize" is a very nice thing to
  have to get started on a sound, and I want to add a button directly next to
  the fader controls.
- More keyboard features:
  - Extra panel with xy pad and faders for all midi supported modulations
    (pitch, vibrato, tremolo, etc.)
  - Separate keyboard zoom ..less octaves, but bigger keys :)
- ...

## Links

- [OB-Xd Virtual Analog Synthesizer from discoDSP](https://www.discodsp.com/obxd/)
- [Hexler TouchOSC](https://hexler.net/touchosc)
- [TouchOSC Scripting API](https://hexler.net/touchosc/manual/script)
- Zoom script and many other useful TouchOSC [modules and plugins by tshoppa](https://github.com/tshoppa/touchOSC/tree/main)

## Donations

This is an Open Source software and free to use for everyone under the GPL-3.0 license! 🙂

|    |  PayPal  |
| -- | -------- |
|  If you feel this software made your life a little easier, and that it is exacly the thing you were looking for, then you can buy me a beer 🍺 (..or beers 🍻..) and I will merrily put out a toast to you for saving yet another evening! 😃<br><br>*(I currently only have a PayPal button, but I may check out getting a Patreon or some "Buy me a coffee" in the future.)* |  [![image](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/donate?hosted_button_id=CGDJVVGG5V8LU&)  |


Many Thanks and Enjoy!
