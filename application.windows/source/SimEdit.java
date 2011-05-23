import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class SimEdit extends PApplet {

/* Sim Asset Editor by  Revlin John (2011) - stylogicalmaps@gmail.com http://stylogicalmaps.blogspot.com */
/* Please share under CC-Attribution-ShareAlike-3.0 (US) http://creativecommons.org/licenses/by-sa/3.0/ */

/* Global variables */
int time_t = 0;
int oldMX = 0, oldMY = 0;
float offx = 1.5f, offy = 1.5f;
int offw = 512;
byte current_mode = 0;
byte skin_mode = 0;
byte hair_mode = 1;
byte eye_mode = 2;
byte shape_mode = 3;
int current_clr;
boolean no_load = false;
boolean show_save = false;
boolean open_new = false;
boolean ctrl_key = false;
boolean tab_key = false;
boolean mouse_up = false;
PGraphics a_canvas;

/* Text dialogue vars */
PFont font;
boolean[] loaded = { false, false, false, false, false };
String[] filename = new String[5];
byte file_type = 0;
byte sk_head_file = 0;
byte sk_top_file = 1;
byte sk_bottom_file = 2;
byte hair_file = 3;
byte eyes_file = 4;

/* Skin mode vars */
PGraphics sk_canvas;
byte current_skin = 0;
byte sk_head = 0;
byte sk_top = 1;
byte sk_bottom = 2;
PImage sl_skin_head;
PImage sl_skin_top;
PImage sl_skin_bottom;
PImage sl_base_head;
PImage sl_base_top;
PImage sl_base_bottom;

/* Hair mode vars */
PGraphics hr_canvas;
PImage sl_hair;
PImage sl_base_hair;

/* Eye mode vars */
PGraphics i_canvas;
PImage sl_eyes;
PImage sl_base_eyes;


public void setup() {
  size(1024, 768);
  frameRate(30);
  font = loadFont("font/LucidaGrande-48.vlw");
  filename[0] = "Sim-Test-Head-512.png";
  filename[1] = "Sim-Test-Top-512.png";
  filename[2] = "Sim-Test-Bottom-512.png";
  filename[3] = "Sim-Test-Hair-512.png";
  filename[4] = "Sim-Test-Eyes-256.png";
  sl_base_head = loadImage("skin/SL-Avatar-Head-512.png");
  sl_base_top = loadImage("skin/SL-Avatar-Top-512.png");
  sl_base_bottom = loadImage("skin/SL-Avatar-Bottom-512.png");
  sl_skin_head = loadImage("blank/Blank-512.png");
  sl_skin_top = loadImage("blank/Blank-512.png");
  sl_skin_bottom = loadImage("blank/Blank-512.png");
  sl_base_hair = loadImage("hair/SL-Avatar-Hair-512.png");
  sl_hair = loadImage("blank/Blank-512.png");
  sl_base_eyes = loadImage("eyes/SL-Avatar-Eyes-256.png");
  sl_eyes = loadImage("blank/Blank-256.png");
  
  if (current_mode == skin_mode) {
    current_skin = sk_head;
    skinMode(true);
  }
}

public void draw() {
  time_t += 1;
  if (time_t < 0) {
    time_t = 3;
  }
  
  if (show_save) {
    if (time_t < 60) {
      return;
    } else {
      show_save = false;
      if (current_mode == skin_mode) {
        graphSkin();
      } else if (current_mode == hair_mode) {
        graphHair();
      } else if (current_mode == eye_mode) {
        graphEyes();
      }
    }
  }
  
  if (no_load) {
    if (time_t < 60) {
      return;
    } else {
      no_load = false;
      if (current_mode == skin_mode) {
        skinMode(true);
      } else if (current_mode == hair_mode) {
        hairMode(true);
      } else if (current_mode == eye_mode) {
        eyeMode(true);
      }
    }
  }
  
  if (current_mode == skin_mode) {
    if (open_new) {
      openDialogue(false);
      return;
    } else if (tab_key) {
      showAlpha(sk_canvas, false);
    } else skinMode(false);
  } else if (current_mode == hair_mode) {
    if (open_new) {
      openDialogue(false);
      return;
    } else if (tab_key) {
      showAlpha(hr_canvas, false);
    } else hairMode(false);
  } else if (current_mode == eye_mode) {
    if (open_new) {
      openDialogue(false);
      return;
    } else if (tab_key) {
      showAlpha(i_canvas, false);
    } else eyeMode(false);
  }
  
  /* Check keyboard */
  if (time_t >= 3 && keyPressed) {
    time_t = 0;
    
    /* Open/New Dialogue */
    if (key == 'o' || key == 'O') {
      if (!open_new) {
        open_new = true;
        saveTemp();
        if (current_mode == skin_mode) {
          if (current_skin == 0) {
            file_type = 0;
          } else if (current_skin == 1) {
            file_type = 1;
          } else if (current_skin == 2) {
            file_type = 2;
          }
        } else if (current_mode == hair_mode) {
          file_type = 3;
        } else if (current_mode == eye_mode) {
          file_type = 4;
        }
        openDialogue(true);
      }
    }
    
    /* Show and Draw Alpha channel */
    else if (key == TAB) {
      if (tab_key) {
        tab_key = false;
        if (current_mode == skin_mode) {
          saveAlpha(sk_canvas);
          skinMode(true);
        } else if (current_mode == hair_mode) {
          saveAlpha(hr_canvas);
          hairMode(true);
        } else if (current_mode == eye_mode) {
          saveAlpha(i_canvas);
          eyeMode(true);
        }
      } else {
        saveTemp();
        tab_key = true;
        if (current_mode == skin_mode) {
          showAlpha(sk_canvas, true);
        } else if (current_mode == hair_mode) {
          showAlpha(hr_canvas, true);
        } else if (current_mode == eye_mode) {
          showAlpha(i_canvas, true);
        }
      }
    } else if (key == CODED && keyCode == KeyEvent.VK_F1) {
      saveTemp();
      current_mode = skin_mode;
      skinMode(true);
    } else if (key == CODED && keyCode == KeyEvent.VK_F2) {
      saveTemp();
      current_mode = hair_mode;
      hairMode(true);
    } else if (key == CODED && keyCode == KeyEvent.VK_F3) {
      saveTemp();
      current_mode = eye_mode;
      eyeMode(true);
    } else if (key == CODED && keyCode == KeyEvent.VK_F4) {
      saveTemp();
      current_mode = shape_mode;
    } 
    
    else if (current_mode == skin_mode) {
      if (key == 'n' || key == 'N') {
        nextKey();
        ctrl_key = false;
      }
      if (key == 'b' || key == 'B') {
        backKey();
        ctrl_key = false;
      }
      if (key == 'f' || key == 'F') {
        if (key == 'F') ctrl_key = true;
        if (mouseX < 768 && mouseY < 768) {
          colorFill(sk_canvas); 
          ctrl_key = false;
        }
      }
      if (key == 'g' || key == 'G') {
        if (key == 'G') ctrl_key = true;
        if (mouseX < 768 && mouseY < 768) {
          colorGrab(sk_canvas); 
          ctrl_key = false;
        }
      }
      if (key == 's' || key == 'S') {
        if (key == 'S') ctrl_key = true;
        saveKey(); 
        ctrl_key = false;
      }
      if (key == 'u' || key == 'U') {
        undoTemp(); 
        ctrl_key = false;
      }
    }
    
    else if (current_mode == hair_mode) {
      if (key == 'f' || key == 'F') {
        if (mouseX < 768 && mouseY < 768) {
          if (key == 'F') ctrl_key = true;
          colorFill(hr_canvas); 
          ctrl_key = false;
        }
      }
      if (key == 'g' || key == 'G') {
        if (key == 'G') ctrl_key = true;
        if (mouseX < 768 && mouseY < 768) {
          colorGrab(hr_canvas); 
          ctrl_key = false;
        }
      }
      if (key == 's' || key == 'S') {
        if (key == 'S') ctrl_key = true;
        saveKey(); 
        ctrl_key = false;
      }
      if (key == 'u' || key == 'U') {
        undoTemp(); 
        ctrl_key = false;
      }
    }
    
    else if (current_mode == eye_mode) {
      if (key == 'f' || key == 'F') {
        if (mouseX < 768 && mouseY < 768) {
          if (key == 'F') ctrl_key = true;
          colorFill(i_canvas); 
          ctrl_key = false;
        }
      }
      if (key == 'g' || key == 'G') {
        if (key == 'G') ctrl_key = true;
        if (mouseX < 768 && mouseY < 768) {
          colorGrab(i_canvas); 
          ctrl_key = false;
        }
      }
      if (key == 's' || key == 'S') {
        if (key == 'S') ctrl_key = true;
        saveKey(); 
        ctrl_key = false;
      }
      if (key == 'u' || key == 'U') {
        undoTemp(); 
        ctrl_key = false;
      }
    }
  }
         
  oldMX = mouseX;
  oldMY = mouseY;
}

public void skinMode(boolean mode_init) {
  
  if (mode_init) {
    offx = 1.5f;
    offy = 1.5f;
    offw = 512;
    drawPallette();
    graphSkin();
    saveTemp();
    
  } else {
  
    getColor();
  
    /*Draw on sk_canvas*/
    if (mousePressed && (mouseX < 768)) {
      sk_canvas.beginDraw();
      sk_canvas.colorMode(HSB, 256);
      colorMode(HSB, 256);
      sk_canvas.stroke(current_clr, 222);
      stroke(current_clr, 222);
      sk_canvas.strokeWeight(2);
      strokeWeight(3);
      float strkA, strkB, strkC, strkD;
      strkA = oldMX/offx;
      strkB = oldMY/offy;
      strkC = mouseX/offx;
      strkD = mouseY/offy;
      sk_canvas.line(strkA, strkB, strkC, strkD);
      line(oldMX, oldMY, mouseX, mouseY);
      sk_canvas.endDraw();
    }
  }
  
  if (current_skin == 0) {
    file_type = 0;
    if (!loaded[sk_head_file]) {
      loaded[sk_head_file] = true;
      open_new = true;
      openDialogue(true);
      return;
    }
  } else if (current_skin == 1) {
    file_type = 1;
    if (!loaded[sk_top_file]) {
      loaded[sk_top_file] = true;
      open_new = true;
      openDialogue(true);
      return;
    }
  } else if (current_skin == 2) {
    file_type = 2;
    if (!loaded[sk_bottom_file]) {
      loaded[sk_bottom_file] = true;
      open_new = true;
      openDialogue(true);
      return;
    }
  }
}

public void hairMode(boolean mode_init) {
  
  if (mode_init) {
    offx = 1.5f;
    offy = 1.5f;
    offw = 512;
    drawPallette();
    graphHair();
    saveTemp();
    
  } else {
    
    getColor();
   
    /*Draw on hr_canvas*/
    if (mousePressed && (mouseX < 768)) {
      hr_canvas.beginDraw();
      hr_canvas.colorMode(HSB, 256);
      colorMode(HSB, 256);
      hr_canvas.stroke(current_clr, 222);
      stroke(current_clr, 222);
      hr_canvas.strokeWeight(2);
      strokeWeight(3);
      float strkA, strkB, strkC, strkD;
      strkA = oldMX/offx;
      strkB = oldMY/offy;
      strkC = mouseX/offx;
      strkD = mouseY/offy;
      hr_canvas.line(strkA, strkB, strkC, strkD);
      line(oldMX, oldMY, mouseX, mouseY);
      hr_canvas.endDraw();
    }
  }
  
  file_type = 3;
  if (!loaded[hair_file]) {
    loaded[hair_file] = true;
    open_new = true;
    openDialogue(true);
    return;
  }
}

public void eyeMode(boolean mode_init) {
  
  if (mode_init) {
    offx = 3;
    offy = 3;
    offw = 256;
    drawPallette();
    graphEyes();
    saveTemp();
    
  } else {
    
    getColor();
  
    /*Draw on i_canvas*/
    if (mousePressed && (mouseX < 768)) {
      i_canvas.beginDraw();
      i_canvas.colorMode(HSB, 256);
      colorMode(HSB, 256);
      i_canvas.stroke(current_clr, 222);
      stroke(current_clr, 222);
      i_canvas.strokeWeight(2);
      strokeWeight(6);
      float strkA, strkB, strkC, strkD;
      strkA = oldMX/offx;
      strkB = oldMY/offy;
      strkC = mouseX/offx;
      strkD = mouseY/offy;
      i_canvas.line(strkA, strkB, strkC, strkD);
      line(oldMX, oldMY, mouseX, mouseY);
      i_canvas.endDraw();
    }
  }
  
  file_type = 4;
  if (!loaded[eyes_file]) {
    loaded[eyes_file] = true;
    open_new = true;
    openDialogue(true);
    return;
  }
}

/* Draw Pallette in side bar */
public void drawPallette() {
  noStroke();
  colorMode(HSB, 256);
  current_clr = color( 0, 0, 0);
  for (int i = 0; i < 255; i++) {
    for (int j = 0; j < 255; j++) {
      stroke(j, i, 255 - i);
      point((i+768),j);
      stroke(j, i, (255 - (int)(i/2)));
      for (int z = 0; z < 2; z++) {
        point((i+768),2*j+z+256);
      }
    }
  }
}

/*Get color from pallete*/
public void getColor() {
  if (mousePressed && (mouseX >= 768)) {
    int h_clr, b_clr, s_clr = mouseX - 768;
    if (mouseY < 256) {
      h_clr = mouseY; 
      b_clr = 1024 - mouseX;
    } else {
      h_clr = (mouseY - 256)/2;
      b_clr = 255;
    }
    if (keyPressed && key == CODED && keyCode == KeyEvent.VK_SHIFT) { 
      current_clr = color(h_clr, 0, b_clr);
      ctrl_key = false;
    } else {
      current_clr = color(h_clr, s_clr, b_clr);
    }
  }

  /* Show color */
  noStroke();
  colorMode(HSB, 256);
  fill(current_clr);
  triangle(768, 224, 800, 256, 768, 286);
  stroke(current_clr);
  strokeWeight(2);
  line(800, 256, 1024, 256); 
}

/* Graph Skin to Background */
public void graphSkin() {
  sk_canvas = createGraphics(512, 512,JAVA2D);
  sk_canvas.beginDraw();
  if (current_skin == sk_bottom) {
    image(sl_base_bottom, 0, 0, 768, 768);
    sk_canvas.image(sl_skin_bottom, 0, 0);
  } else if (current_skin == sk_top) {
    image(sl_base_top, 0, 0, 768, 768);
    sk_canvas.image(sl_skin_top, 0, 0);
  } else if (current_skin == sk_head) {
    image(sl_base_head, 0, 0, 768, 768);
    sk_canvas.image(sl_skin_head, 0, 0);
  }
  sk_canvas.endDraw();
  image(sk_canvas, 0, 0, 768, 768);
}

/* Graph Hair to Background */
public void graphHair() {
  hr_canvas = createGraphics(512, 512, JAVA2D);
  fill(255);
  rect(0, 0, 768, 768);
  image(sl_base_hair, 0, 0, 768, 768);
  hr_canvas.beginDraw();
  hr_canvas.image(sl_hair, 0, 0);
  hr_canvas.endDraw();
  image(hr_canvas, 0, 0, 768, 768);
}

/* Graph Eyes to Background */
public void graphEyes() {
  i_canvas = createGraphics(256, 256, JAVA2D);
  image(sl_base_eyes, 0, 0, 768, 768);
  i_canvas.beginDraw();
  i_canvas.image(sl_eyes, 0, 0);
  i_canvas.endDraw();
  image(i_canvas, 0, 0, 768, 768);
}

/* Show alpha channel */
public void showAlpha(PGraphics canvas, boolean init) {
  if (init) {
    a_canvas = createGraphics(offw, offw, JAVA2D);
    canvas.loadPixels();
    a_canvas.loadPixels();
    a_canvas.background(0);
    for (int i = 0; i < offw; i++) {
      for (int j = 0; j < offw; j++) {
        int z = canvas.pixels[(i + j * offw)];
        a_canvas.pixels[(i + j * offw)] = color(0, 0, alpha(z));
      }
    }
    a_canvas.updatePixels();
    image(a_canvas, 0, 0, 768, 768);
  }
  
  getColor();
  
  /*Draw on a_canvas*/
  if (mousePressed && (mouseX < 768)) {
    a_canvas.beginDraw();
    a_canvas.colorMode(HSB, 256);
    colorMode(HSB, 256);
    a_canvas.stroke(brightness(current_clr), 192);
    stroke(brightness(current_clr), 192);
    a_canvas.strokeWeight(2);
    strokeWeight((int)(2*offx));
    float strkA, strkB, strkC, strkD;
    strkA = oldMX/offx;
    strkB = oldMY/offy;
    strkC = mouseX/offx;
    strkD = mouseY/offy;
    a_canvas.line(strkA, strkB, strkC, strkD);
    line(oldMX, oldMY, mouseX, mouseY);
    a_canvas.endDraw();
  }
}

/* Save Alpha channel */
public void saveAlpha(PGraphics canvas) {
  a_canvas.loadPixels();
  canvas.loadPixels();
  for (int i = 0; i < offw; i++) {
    for (int j = 0; j < offw; j++) {
      int q = i + j * offw;
      int z = canvas.pixels[q];
      if (alpha(z) > 0) {
        canvas.pixels[q] = color(hue(z), saturation(z), brightness(z), brightness(a_canvas.pixels[q]));
      }
    }
  }
  //canvas.background(current_clr);
  canvas.updatePixels();
  saveTemp();
}

/* Color fill command */
public void colorFill(PGraphics canvas) {
  if((mouseX > 0) && (mouseY > 0)) {
    PGraphics tmp_canvas = createGraphics(offw, offw, JAVA2D);
    int pnt_clr = mouseX + mouseY * width;
    loadPixels();
    int fill_clr = pixels[pnt_clr];
    tmp_canvas.loadPixels();
    for (int i = 0; i < 768; i++) {
      for (int j = 0; j < 768; j++) {
        int z = pixels[(i + j * width)];
        if ((brightness(z) <= brightness(fill_clr) + 127) && (brightness(z) >= brightness(fill_clr) - 127)) {
           if(ctrl_key && (brightness(z) <= brightness(fill_clr) + 15) && (brightness(z) >= brightness(fill_clr) - 15) && (saturation(z) <= 32) ) { 
            tmp_canvas.pixels[((int)(i/offx) + (int)(j/offy) * offw)] = current_clr;
          } else if ((hue(z) <= hue(fill_clr) + 3) && (hue(z) >= hue(fill_clr) - 3) && (saturation(z) <= saturation(fill_clr) + 27) && (saturation(z) >= saturation(fill_clr) - 27)) {
            tmp_canvas.pixels[((int)(i/offx) + (int)(j/offy) * offw)] = current_clr;
          }
        }
      }
    }
    tmp_canvas.updatePixels();
    canvas.image(tmp_canvas, 0, 0);
    image(tmp_canvas, 0, 0, 768, 768);
  }
}

/* Color grab command */
public void colorGrab(PGraphics canvas) {
  if((mouseX > 0) && (mouseY > 0)) {
    int pnt_clr = mouseX + mouseY * width;
    loadPixels();
    if (ctrl_key) {
      current_clr = color(0, 0, brightness(pixels[pnt_clr]));
    } else {
      current_clr = pixels[pnt_clr];
    }
  }
}

/* Open/New Dialogue box */
public void openDialogue(boolean init) {
  String prompt = "FILE NAME:",
  open_button = "OPEN",
  new_button = "NEW";
  fill(12);
  rect(256, 240, 512, 32);
  fill(255);
  rect(364, 242, 256, 28);
  textFont(font, 18);
  fill(208);
  text(prompt, 260, 264);
  if(mouseX > 640 && mouseX < 680 && mouseY > 248 && mouseY < 266) {
    fill(255);
    if (mousePressed) {
      if (openNew(true)) {
        open_new = false;
        return;
      } else {
        undoTemp();
        noloadBox();
        no_load = true;
        return;
      }
    }
  }
  text(open_button, 640, 264);
  fill(208);
  if(mouseX > 692 && mouseX < 730 && mouseY > 248 && mouseY < 266) {
    fill(255);
    if (mousePressed) { 
      openNew(false);
      open_new = false;
      return;
    }
  }
  text(new_button, 692, 264);
  if (!init) {
    fill(0);
    text(filename[file_type], 370, 264);
  }
  
  /* Text input */
  if (time_t >= 4 && keyPressed) {
    if ((key == BACKSPACE) && (filename[file_type].length() > 0)) {
      time_t = 0;
      filename[file_type] = filename[file_type].substring(0, (filename[file_type].length()-1));
    } else if (key != CODED) {
      time_t = 0;
      filename[file_type] = filename[file_type] + key;
    }
  }
  
}

public boolean openNew(boolean openfile) {
  
  /* Check that the name is valid */
  String file_ext = filename[file_type].substring((filename[file_type].length() - 4));
  if ((!file_ext.equals(".png")) && (!file_ext.equals(".jpg")) && (!file_ext.equals(".tga")) ){
    filename[file_type] = filename[file_type] + ".png";
  }
  
  /* Open existing file */
  if(openfile) {
    if (current_mode == skin_mode ) {
      if (current_skin == sk_bottom) {
        sl_skin_bottom = loadImage("skin/" + filename[file_type]);
        if (sl_skin_bottom == null) return false;
      } else if (current_skin == sk_top) {
        sl_skin_top = loadImage("skin/" + filename[file_type]);
        if (sl_skin_top == null) return false;
      } else if (current_skin == sk_head) {
        sl_skin_head = loadImage("skin/" + filename[file_type]);
        if (sl_skin_head == null) return false;
      } 
      graphSkin();
    } else if (current_mode == hair_mode) {
      sl_hair = loadImage("hair/" + filename[file_type]);
      if (sl_hair == null) return false;
      graphHair();
    } else if (current_mode == eye_mode) {
      sl_eyes = loadImage("eyes/" + filename[file_type]);
      if (sl_eyes == null) return false;
      graphEyes();
    }     
  }
  
  /* Initiate new file or overwrite existing file */
  else if (current_mode == skin_mode ) {
    if (current_skin == sk_bottom) {
      sl_skin_bottom = loadImage("blank/Blank-512.png");
    } else if (current_skin == sk_top) {
      sl_skin_top = loadImage("blank/Blank-512.png");
    } else if (current_skin == sk_head) {
      sl_skin_head = loadImage("blank/Blank-512.png");
    }
    graphSkin();
  } else if (current_mode == hair_mode) {
    sl_hair = loadImage("blank/Blank-512.png");
    graphHair();
  } else if (current_mode == eye_mode) {
    sl_eyes = loadImage("blank/Blank-256.png");
    graphEyes();
  }
  
  return true;
}

/* No Load Box */
public void noloadBox() {
  String not_loaded = "Could Not Load File";
  fill(12);
  rect(256, 240, 308, 32);
  textFont(font, 18);
  fill(208);
  text(not_loaded, 260, 264);
}

/* Save key command */
public void saveKey () {
  saveTemp();
  if(ctrl_key) {
    if (current_mode == skin_mode) {
      for(int i = 0; i < 3; i++) {
        nextKey();
        if (current_skin == sk_head) {
          sk_canvas.save("data/skin/" + filename[0]);
        } else if (current_skin == sk_top) {
          sk_canvas.save("data/skin/" + filename[1]);
        } else if (current_skin == sk_head) {
          sk_canvas.save("data/skin/" + filename[0]);
        }
        savingBox();
      }
    } else if (current_mode == hair_mode) {
      savingBox();
      hr_canvas.save("data/hair/" + filename[3]);
    } else if (current_mode == eye_mode) {
      savingBox();
      i_canvas.save("data/eyes/" + filename[4]);
    }
    show_save = true;
  }
}

/* Saving Box */
public void savingBox() {
  String saving = "SAVING";
  fill(12);
  rect(256, 240, 308, 32);
  textFont(font, 18);
  fill(208);
  text(saving, 260, 264);
}

/* Next key command */
public void nextKey() {
  saveTemp();
  if(current_skin < 2) {
    current_skin += 1;
   } else current_skin = 0;
   graphSkin();
   saveTemp();
}

/* Back key command */
public void backKey() {
   saveTemp();
   if(current_skin > 0) {
      current_skin -= 1;
    } else current_skin = 2;
    graphSkin();
    saveTemp();
}
  
/* Save temp command */
public void saveTemp () {
  if (current_mode == skin_mode) {
    if (current_skin == sk_head) {
      sk_canvas.save("data/temp/Sim-Temp-Head-512.png");
      sl_skin_head = loadImage("temp/Sim-Temp-Head-512.png");
    } else if (current_skin == sk_top) {
      sk_canvas.save("data/temp/Sim-Temp-Top-512.png");
      sl_skin_top = loadImage("temp/Sim-Temp-Top-512.png");
    } else if (current_skin == sk_bottom) {
      sk_canvas.save("data/temp/Sim-Temp-Bottom-512.png");
      sl_skin_bottom = loadImage("temp/Sim-Temp-Bottom-512.png");
    }
  } else if (current_mode == hair_mode) {
    hr_canvas.save("data/temp/Sim-Temp-Hair-512.png");
    sl_hair = loadImage("temp/Sim-Temp-Hair-512.png");
  } else if (current_mode == eye_mode) {
    i_canvas.save("data/temp/Sim-Temp-Eyes-256.png");
    sl_eyes = loadImage("temp/Sim-Temp-Eyes-256.png");
  }
}

/* Undo key command */
public void undoTemp () {
  if (current_mode == skin_mode ) {
    if (current_skin == sk_head) {
      sl_skin_head = loadImage("temp/Sim-Temp-Head-512.png");
    } else if (current_skin == sk_top) {
      sl_skin_top = loadImage("temp/Sim-Temp-Top-512.png");
    } else if (current_skin == sk_bottom) {
      sl_skin_bottom = loadImage("temp/Sim-Temp-Bottom-512.png");
    }
    graphSkin();
  } else if (current_mode == hair_mode) {
    sl_hair = loadImage("temp/Sim-Temp-Hair-512.png");
    graphHair();
  } else if (current_mode == eye_mode) {
    sl_eyes = loadImage("temp/Sim-Temp-Eyes-256.png");
    graphEyes();
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#C0C0C0", "SimEdit" });
  }
}
