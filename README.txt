/* Sim Asset Editor by  Revlin John (2011) - stylogicalmaps@gmail.com http://stylogicalmaps.blogspot.com */
/* Please share under CC-Attribution-ShareAlike-3.0 (US) http://creativecommons.org/licenses/by-sa/3.0/ */

Purpose:

This program was created to edit assets like textures, shapes, sculpties and animations associated with OpenSim and SecondLife. Obviously it's a work-in-progress in the very early stages. The main api used is Processing which you can find out more about at http://processing.org

Running:

To run, just double click the shortcut for your os (maybe a windows person can help me out here, sry; the exe is in "application.windows") or you can open "SimEdit.pde" if you have Processing installed on your machine. The "data" folder contains all the .png files which SimEdit needs to start up.

Opening:

When you first load into any mode (skin, eye, hair, etc.) the Open/New dialogue box will appear. Here you can type a file name and either this name will be a file that you choose to open by clicking 'OPEN' or it will be the name for your new file if you click 'NEW'. If a file fails to open (probably because it has not been placed in the correct folder within "./data/") then you are returned to the Open/New dialogue to try again.

Saving:

Since you've already chosen the name of the file you are working on, pressing Shift + S will save the canvas to a file under that name. Thus, choose the name carefully when you begin editing because it will stick until you start over with a new file or open an existing file. 

Files are saved in specific folders, chosen by type and must be opened in the same way. If you are working on a skin texture, the saved file will be located in "./data/skin". If you are working on an eye look in "./data/eyes" ...and so on.

Controls:

Briefly. when editing textures, mouse press draws to the main canvas with the currently selected color. All you get is a blunt mark, so work slow and attentively  ;-). The selected color is shown in a triangle to the right of the canvas, in between the two color palettes. Mouse press within the palettes will select the color that the cursor is on. Holding 'SHIFT' and clicking in the palette will give a grayscale value of the color, which is only useful with the top palette because the bottom one has a constant brightness range (all colors are the same intensity value). 

F1, F2, F3 	- Switch between types of textures, respectively Skin, Hair and Eyes. Additional modes (shape, sculpty) have not been implemented, yet.

TAB 	- Switch between normal and alpha mode, in order to edit the alpha channel of a texture using grayscale marks (white is opaque; black is transparent)

O	- Open file (which has been placed in the appropriate folder, i.e. "./data/...") or initiate a New file with the given name 

G 	- Grab color from canvas

Shift + G 	- Grab grayscale value from canvas

F 	- Fill all pixels matching the color of the the cursor selection with selected color

Shift + F 	- Fill all pixels matching the brightness (whiteness) of the cursor selection with selected color

S 	- Temporarily save canvas for later retrieval via undo (see below; this does NOT save to file)

Shift + S 	- Save current canvas to file (normal save)

U 	- Undo to initial state of current canvas

N 	- Next portion of skin In skin mode (head, upper, lower)

B 	- Previous portion of skin in skin mode

That's all folks. If you have any questions don't hesitate to send me some mail with a clear SUBJECT line, like "SimEdit: how do I work this thing?"

Play and have fun.

Rev



