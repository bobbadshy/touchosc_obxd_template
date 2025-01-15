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
  - [Preliminary screenshots](#preliminary-screenshots)
  - [Download](#download)
  - [Bug reports, Feature Suggestions or Contributing](#bug-reports-feature-suggestions-or-contributing)
  - [Links](#links)
  - [Donations](#donations)


## Supported features

- All controls of the OB-Xd virtual synth have been implemented. The control
  layout closely follows the OB-Xd "IIkka Rosma Dark" default skin.
- All MIDI mappings match the default mappings found in OB-Xd v3.6. So all
  controls should work out of the box, with no further setup neccessary.

  The template also contains a MIDI mappings XML file for OB-Xd. If some MIDI
  mappings do not work as expected (OB-Xd versions below 3.6), try to copy:
  
  [./midi_mapping/TouchOsc.xml](./midi_mapping/TouchOsc.xml)
  
  from this template's directory into your `discoDSP` documents folder:
  
  ... `discoDSP/OB-Xd 3/MIDI/TouchOsc.xml`
  
  *This folder is located in the "Documents" folder in your user's `$HOME`
  directory. The exact naming will differ between operating systems and
  distributions. Consult the discoDSP documentation if you are unsure about the
  folder location.*

  Restart OB-Xd. The MIDI menu should now show **"TouchOsc"** as a new MIDI mappings
  option.

- All TouchOSC faders use a 

double-tap controls
zoom 
tooltip and true value

Currently ***work in progress***. I'll add some detailed infos soon..

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
