# External Display Brightness Control

Control external displays brightness through different backends

# Features
- Step size
- Max & Min brightness

**Brightness backends**
  - [ddcutil](https://github.com/rockowitz/ddcutil)
  - [xrandr](https://www.x.org/releases/X11R7.6/doc/man/man1/xrandr.1.xhtml)

**Planned features**
- [ ] Add ACPI backend
- [ ] Test multi Monitor
- [ ] Saving monitor selection across sessions
- [ ] Check available backends
- [ ] Custom VCP codes for ddcutil


# Acknowledgements
[Misagh's (@Misaghlb)](https://github.com/Misaghlb) [plasma-applet-brighty](https://github.com/Misaghlb/plasma-applet-brighty), the base this plugin builds upon

[Ismael Asensio's (@ismailof)](https://github.com/ismailof) [mediacontroller_plus](https://github.com/ismailof/mediacontroller_plus) and [Chris Holland's (@Zren)](https://github.com/Zren)  [plasma-applet-commandoutput](https://github.com/Zren/plasma-applet-commandoutput) plugins for some configuration and command handling bits