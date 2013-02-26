/* Sim Asset Editor by  Revlin John (2011) - stylogicalmaps@gmail.com
 * http://stymaps.universalsoldier.ca
 * Please share under CC-Attribution-ShareAlike-3.0 (US)
 * http://creativecommons.org/licenses/by-sa/3.0/
 */

Purpose:

This program was created to edit assets like textures, shapes, sculpties and animations associated with OpenSim and SecondLife. Obviously it's a work-in-progress in the very early stages. The main api used is Processing which you can find out more about at http://processing.org

Running:

Once you have Processing installed on your machine, open 'SimEdit.pde'. The 'data' folder contains all the .png files which SimEdit needs to start up.

Opening:

When you first load into any mode (Skin, Eyes, Hair, UV, etc.) the Open/New dialogue box will appear. Here you can type a file name and either this name will be a file that you choose to open by clicking 'OPEN' or it will be the name for your new file if you click 'NEW'. If a file fails to open (probably because it has not been placed in the correct folder within './data/') then you are returned to the Open/New dialogue to try again. 
NOTE: Windows version places the 'data' folder in 'application.windows'.

Additionally, when opening or starting a new file in UV mode, you must select the size of your texture and choose a map for the background. The map can be one of the built-in selections (i.e. 'GRID') or you can choose a file saved in './data/uv' by selecting 'CUSTOM' and typing the file name. This allows you to use a baked UV map from a 3d editing program as your background. The size options are 128x128, 256x256, 512x512. I know that 1024x1024 is also desired, but until I implement a zoom function, working on a 1024x1024 texture at %75 of it's actual size is pretty useless.

Saving:

Since you've already chosen the name of the file you are working on, pressing Shift + S will save the canvas to a file under that name. Thus, choose the name carefully when you begin editing because it will stick until you start over with a new file or open an existing file.
Files are saved in specific folders, chosen by type and must be opened in the same way. If you are working on a skin texture, the saved file will be located in './data/skin'. If you are working on an eye texture,  look in './data/eyes' ...and so on. 
NOTE: Windows version places the 'data' folder in 'application.windows'.

Controls:

Briefly: when editing textures, if the mouse cursor is positioned over the drawing area (canvas) Spacebar draws on the main canvas with the currently selected color. All you get is a blunt mark, so work slow and attentively :p . The selected color is shown in a triangle, which is located to the right of the canvas in between the two color palettes. Mouse press within the color palettes will select the color that the cursor is on. Holding 'SHIFT' and clicking in the palette will give a grayscale value of the color, which is only useful with the top palette because the bottom one has a constant brightness range (all colors in the bottom palette are the same brightness value). If you loose the mouse cursor when drawing on the canvas, just mouse click without pressing any other keys and it should re-appear.

ESC		- Quit SimEdit

H		- Show/Hide Help screen w/list of key commands

SPACE		- Mark/Draw on main canvas
ENTER

Num 0...9	- Changethe tone (darkness) of current color. 
		1 to 9 is darkest to lightest; 0 resets to original

+/-		- Increase/Decrease the size of the drawing mark (up to 32 pixels wide)

O		- Open file or initiate a New file with the given name 
	   To open, the file must be placed in the appropriate folder ( i.e. './data/skin', './data/uv', etc.)

G 		- Grab color from canvas (based on position of cursor)

Shift + G 	- Grab grayscale value from canvas (based on position of cursor)

F 		- Fill all pixels matching the color at the cursor position with selected color

Shift + F 	- Fill all pixels matching the brightness (whiteness) of the color at the cursor position

S 		- Temporarily save canvas for later retrieval via undo (see below; this does NOT save to file)

Shift + S 	- Save current canvas to file (normal save)

U 		- Undo to last saved state of current canvas

F1		- Skin mode texturing. File's are opened/saved to './data/skin/'

N/B 		- Next/Previous portion of skin In skin mode (head, upper, lower)

F2		- Hair mode texturing. Files are open/saved to './data/hair/'

F3		- Eyes mode texturing. Files are open/saved to './data/eyes/'

F4 		- UV mode texturing. Files are open/saved to './data/uv/'

TAB 	- Switch between normal and alpha mode. 
	   Edit the alpha channel of a texture using grayscale values
	   White is opaque; Black is transparent (erase)



That's all folks. If you have any questions don't hesitate to send me some mail with a clear SUBJECT line, like 'SimEdit: how do I work this thing?'

Play and have fun.

Rev



