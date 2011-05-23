/* Sim Asset Editor by  Revlin John (2011) - stylogicalmaps@gmail.com http://stylogicalmaps.blogspot.com */
/* Please share under CC-Attribution-ShareAlike-3.0 (US) http://creativecommons.org/licenses/by-sa/3.0/ */

Purpose:

This program was created to edit assets like textures, shapes, sculpties and animations associated with OpenSim and SecondLife. Obviously it's a work-in-progress in the very early stages. The main api used is Processing which you can find out more about at http://processing.org

Running:

To run, just double click the shortcut for your os (maybe a windows person can help me out here, sry; the exe is in "application.windows") or you can open "SimEdit.pde" if you have Processing installed on your machine. The "data" folder contains all the .png files which SimEdit needs to start up.

Saving:

Press the 's' key to save. At the moment I have not implemented a way to name the file you're working on when you save, so each type of file gets a generic name and successive saves WILL OVERWRITE previous saves. To avoid this just change the name of the file after you save it. 

Example: You are working on a skin for the head of an avatar and you press 's' 
-> "./data/skin/Sim-Test-Head-512.png" 
-> "./data/skin/Sim-Test-Top-512.png" 
-> "./data/skin/Sim-Test-Bottom-512.png" 
^ All three of these files will be saved if you are working on any portion of a skin ^

Example: You are painting an eyeball for your avatar and you press 's' 
-> "./data/eyes/Sim-Test-Eyes-256.png"

...and so on

Opening:

Since I haven't implemented a module for selecting and loading files, you'll have to have Processing installed and go into the source, "SimEdit.pde". Look for a group of lines in the setup() function, like:

sl_skin_head = loadImage("Blank-512.png");

If you wanted to load a head texture, you would place your .png or .tga file in the "data" folder and then change "Blank-512.png" in the above line to the name of your file. Then hit the run button in Processing, go to the appropriate editing canvas and you should see your texture. Remember, though that saving will not change your original texture, but instead load to the generic type-named file in "./data/skin" or "./data/hair", etc. "Blank-512.png" is the name of a fully transparent .png file located in the "data" folder. 

Controls:

Briefly. when editing textures, mouse press draws to the main canvas with the currently selected color. All you get is a blunt mark, so work slow and attentively  ;-). The selected color is shown in a triangle to the right of the canvas, in between the two color palettes. Mouse press within the palettes will select the color that the cursor is on. Holding 'SHIFT' and clicking in the palette will give a grayscale value of the color, which is only useful with the top palette because the bottom one has a constant brightness range (all colors are the same intensity value). 

F1, F2, F3 	- Switch between types of textures, respectively Skin, Hair and Eyes. Additional modes (shape, sculpty) have not been implemented, yet.

TAB 	- Switch between normal and alpha mode, in order to edit the alpha channel of a texture using grayscale marks (white is opaque; black is transparent)

G 	- Grab color from canvas

Shift + G 	- Grab grayscale value from canvas

F 	- Fill all pixels matching the color of the the cursor selection with selected color

Shift + F 	- Fill all pixels matching the brightness (whiteness) of the cursor selection with selected color

S 	- Save current canvas

U 	- Undo to initial state of current canvas

N 	- Next portion of skin In skin mode (head, upper, lower)

B 	- Previous portion of skin in skin mode

That's all folks. If you have any questions don't hesitate to send me some mail with a clear SUBJECT line, like "SimEdit: how do I work this thing?"

Play and have fun.

Rev



