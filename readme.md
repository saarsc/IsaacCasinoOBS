# Path randomizer for the Binding Of Isaac: Repentance - OBS overlay

This project is a plugin for OBS studios which allows you to generate a random objective(path) for each run and will display the path on screen so your viewers can stop asking you about the path.

## Features

* Allows to modify the chances for each character/ boss/ extra thing in the middle
* Allows to register hotkey in the settings of the OBS
* Allows for custom mods
* Doesn't support greed / greeder

## Installation

1) Download this repo
2) extrat the files somewhere on your computer
3) In OBS: Select Tools -> Scripts ->  select the + sign the bottom left of the new window -> select the isaac-casino.lua file from where put it in step 2

## Usage

1) In the plugins window (where you added the script in the step 3 of the installation) select which mode you want to edit(Characters, Extras, Bosses)
2) Edit the % for each thing as you choose(0 disabels it)
3) At the bottom of the settings you can edit the X, Y positions of where the overlay will be disaplyed, and below that the size of each image(scaler)
4) **OPTIONAL** to set a hotkey: File -> Settings -> Hotkeys-> search for Isaac -> Edit the hot key for "Generates a new Isaac path"
5) **OPTIONAL** to add any new thing (boss, something in the middle, character) just add an image of it to the relevent folder in the Images folder and reload the script

## Credits

 [Where I got the idea after Northernlion started to use it](https://trpgstuff.com/isaac/)
 [Took a lot of code from here](https://obsproject.com/forum/threads/tips-and-tricks-for-lua-scripts.132256/)
 [Images are taken from here](https://bindingofisaacrebirth.fandom.com/wiki/Binding_of_Isaac:_Rebirth_Wiki)

### Disclaimer

I'm not affiliated with anyone who worked on this game.
This shouldn't harm your setup in any way, but as always use at your own risk
