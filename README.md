# ColorConvert

This is a small application that takes `.itermcolors` files and
converts them into AppleScript statements for use with
https://github.com/Keithbsmiley/dotfiles/blob/master/scripts/itermcolors.applescript

This simple parses the plist format, converts the name to their correct
AppleScript bindings and converts the 0-1 RGB to 65535 flavored RGB and
then copies the output to your pasteboard.

For more info read the [blog
post](http://smileykeith.com/2013/09/03/iterm-theme-based-on-the-time-of-day/)
