/* Sim Asset Editor by  Revlin John (2011) - stylogicalmaps@gmail.com
 * http://stymaps.universalsoldier.ca
 * Please share under CC-Attribution-ShareAlike-3.0 (US)
 * http://creativecommons.org/licenses/by-sa/3.0/
 */

/* Global variables */
int time_t = 0;
int oldMX = 0, oldMY = 0;
float offx = 1.5, offy = 1.5;
int offw = 512;
byte current_mode = 0;
byte skin_mode = 0;
byte hair_mode = 1;
byte eye_mode = 2;
byte uv_mode = 3;
color current_clr;
int clr_tone;
int clr_hue;
int clr_sat;
boolean show_help = false;
boolean no_load = false;
boolean show_save = false;
boolean open_new = false;
boolean ctrl_key = false;
boolean tab_key = false;
boolean mouse_up = false;
boolean drawing = false;
PGraphics a_canvas;
PGraphics p_canvas;
byte mark_size = 2;

/* Text dialogue vars */
PFont font;
boolean[] loaded = { false, false, false, false, false, false };
Textline texturename[] = new Textline[6];
Textline alphaname;
byte file_type = 0;
byte sk_head_file = 0;
byte sk_top_file = 1;
byte sk_bottom_file = 2;
byte hair_file = 3;
byte eyes_file = 4;
byte uv_file = 5;

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

/* UV mode vars */
Textline uv_map_name;
int uv_map_size = 512;
int uv_map_x = 0;
int uv_map_y = 0;
boolean uv_trace = false;
byte uv_map_type = 0;
byte uv_grid = 0;
byte uv_box = 1;
byte uv_prism = 2;
byte uv_cylinder = 3;
byte uv_torus = 4;
byte uv_tube = 5;
byte uv_ring = 6;
byte uv_custom = 7;
PGraphics uv_canvas;
PImage uv_texture;
PImage uv_base_map;


void setup() {
  size(1024, 768);
  frameRate(30);
  cursor(CROSS);
  current_clr = color( 0, 0, 0);
  font = loadFont("font/LucidaGrande-48.vlw");
  texturename[0] = new Textline("Sim-Test-Head-512.png");
  texturename[1] = new Textline("Sim-Test-Top-512.png");
  texturename[2] = new Textline("Sim-Test-Bottom-512.png");
  texturename[3] = new Textline("Sim-Test-Hair-512.png");
  texturename[4] = new Textline("Sim-Test-Eyes-256.png");
  texturename[5] = new Textline("UV-Test-512.png");
  uv_map_name = new Textline("UV-Grid-512.png");
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
  uv_texture = loadImage("blank/Blank-512.png");
  uv_base_map = loadImage("uv/" + uv_map_name.content);
  
  if (current_mode == skin_mode) {
    current_skin = sk_head;
    skinMode(true);
  }
}

void draw() {
  time_t += 1;
  if (time_t < 0) {
    time_t = 3;
  }
  
  if (show_help) {
    if (time_t >= 3 && keyPressed) {
      time_t = 0;
    
      if (key == 'h' || key == 'H') {
        show_help = false;
        if (current_mode == skin_mode) {
          skinMode(true);
          if (tab_key) {
            showAlpha(sk_canvas, true);
          }
        } else if (current_mode == hair_mode) {
          hairMode(true);
          if (tab_key) {
            showAlpha(hr_canvas, true);
          }
        } else if (current_mode == eye_mode) {
          eyeMode(true);
          if (tab_key) {
            showAlpha(i_canvas, true);
          }
        } else if (current_mode == uv_mode) {
          uvMode(true);
          if (tab_key) {
            showAlpha(uv_canvas, true);
          }
        }
      } 
    }
    return;
  }
  
  if (show_save) {
    if (time_t < 30) {
      return;
    } else {
      show_save = false;
      if (current_mode == skin_mode) {
        graphSkin();
      } else if (current_mode == hair_mode) {
        graphHair();
      } else if (current_mode == eye_mode) {
        graphEyes();
      } else if (current_mode == uv_mode) {
        graphUV();
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
      } else if (current_mode == uv_mode) {
        uvMode(true);
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
  } else if (current_mode == uv_mode) {
    if (open_new) {
      openDialogue(false);
      return;
    } else if (tab_key) {
      showAlpha(uv_canvas, false);
    } else uvMode(false);
  }
  
  /* Check keyboard */
  if (time_t >= 3 && keyPressed) {
    time_t = 0;
    
    /* Show Help */
    if (key == 'h' || key == 'H') {
      if (!show_help) {
        saveTemp();
        if (tab_key) {
          if (current_mode == skin_mode) {
            saveAlpha(sk_canvas);
          } else if (current_mode == hair_mode) {
            saveAlpha(hr_canvas);
          } else if (current_mode == eye_mode) {
            saveAlpha(i_canvas);
          } else if (current_mode == uv_mode) {
            saveAlpha(uv_canvas);
          }
        }
        show_help = true;
        showHelp();
        return;
      }
    }
          
    /* Open/New Dialogue */
    if (key == 'o' || key == 'O') {
      if (!open_new) {
        open_new = true;
        if (tab_key) {
          if (current_mode == skin_mode) {
            saveAlpha(sk_canvas);
          } else if (current_mode == hair_mode) {
            saveAlpha(hr_canvas);
          } else if (current_mode == eye_mode) {
            saveAlpha(i_canvas);
          } else if (current_mode == uv_mode) {
            saveAlpha(uv_canvas);
          }
        }
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
        } else if (current_mode == uv_mode) {
          file_type = 5;
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
        } else if (current_mode == uv_mode) {
          saveAlpha(uv_canvas);
          uvMode(true);
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
        } else if (current_mode == uv_mode) {
          showAlpha(uv_canvas, true);
        }
      }
    } else if (key == CODED && keyCode == KeyEvent.VK_F1 && (!tab_key)) {
      saveTemp();
      current_mode = skin_mode;
      skinMode(true);
    } else if (key == CODED && keyCode == KeyEvent.VK_F2 && (!tab_key)) {
      saveTemp();
      current_mode = hair_mode;
      hairMode(true);
    } else if (key == CODED && keyCode == KeyEvent.VK_F3 && (!tab_key)) {
      saveTemp();
      current_mode = eye_mode;
      eyeMode(true);
    } else if (key == CODED && keyCode == KeyEvent.VK_F4 && (!tab_key)) {
      saveTemp();
      current_mode = uv_mode;
      uvMode(true);
    } 
    
    else if (current_mode == skin_mode) {
      if (!tab_key) {
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
        if (key == '0') {
          setTone(1.0);
        }
        if (key == '1') {
          setTone(0.1);
        }
        if (key == '2') {
          setTone(0.2);
        }
        if (key == '3') {
          setTone(0.3);
        }
        if (key == '4') {
          setTone(0.4);
        }
        if (key == '5') {
          setTone(0.5);
        }
        if (key == '6') {
          setTone(0.6);
        }
        if (key == '7') {
          setTone(0.7);
        }
        if (key == '8') {
          setTone(0.8);
        }
        if (key == '9') {
          setTone(0.9);
        }
      } 
      if ((key == '+') && (mark_size < 32)) {
        mark_size = (byte)(mark_size*2);
      }
      if ((key == '-') && (mark_size > 1)) {
        mark_size = (byte)(mark_size/2);
      }
    }
    
    else if (current_mode == hair_mode) {
      if (!tab_key) {
        if (key == 'f' || key == 'F') {
          if (key == 'F') ctrl_key = true;
          if (mouseX < 768 && mouseY < 768) {
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
        if (key == '0') {
          setTone(1.0);
        }
        if (key == '1') {
          setTone(0.1);
        }
        if (key == '2') {
          setTone(0.2);
        }
        if (key == '3') {
          setTone(0.3);
        }
        if (key == '4') {
          setTone(0.4);
        }
        if (key == '5') {
          setTone(0.5);
        }
        if (key == '6') {
          setTone(0.6);
        }
        if (key == '7') {
          setTone(0.7);
        }
        if (key == '8') {
          setTone(0.8);
        }
        if (key == '9') {
          setTone(0.9);
        }
      } 
      if ((key == '+') && (mark_size < 32)) {
        mark_size = (byte)(mark_size*2);
      }
      if ((key == '-') && (mark_size > 1)) {
        mark_size = (byte)(mark_size/2);
      }
    }
    
    else if (current_mode == eye_mode) {
      if (!tab_key) {
        if (key == 'f' || key == 'F') {
          if (key == 'F') ctrl_key = true;
          if (mouseX < 768 && mouseY < 768) {
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
        if (key == '0') {
          setTone(1.0);
        }
        if (key == '1') {
          setTone(0.1);
        }
        if (key == '2') {
          setTone(0.2);
        }
        if (key == '3') {
          setTone(0.3);
        }
        if (key == '4') {
          setTone(0.4);
        }
        if (key == '5') {
          setTone(0.5);
        }
        if (key == '6') {
          setTone(0.6);
        }
        if (key == '7') {
          setTone(0.7);
        }
        if (key == '8') {
          setTone(0.8);
        }
        if (key == '9') {
          setTone(0.9);
        }
      } 
      if ((key == '+') && (mark_size < 32)) {
        mark_size = (byte)(mark_size*2);
      }
      if ((key == '-') && (mark_size > 1)) {
        mark_size = (byte)(mark_size/2);
      }
    }
    
    else if (current_mode == uv_mode) {
      if (!tab_key) {
        if (key == 'f' || key == 'F') {
          if (key == 'F') ctrl_key = true;
          if (mouseX < 768 && mouseY < 768) {
            colorFill(uv_canvas); 
            ctrl_key = false;
          }
        }
        if (key == 'g' || key == 'G') {
          if (key == 'G') ctrl_key = true;
          if (mouseX < 768 && mouseY < 768) {
            colorGrab(uv_canvas); 
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
        if (key == '0') {
          setTone(1.0);
        }
        if (key == '1') {
          setTone(0.1);
        }
        if (key == '2') {
          setTone(0.2);
        }
        if (key == '3') {
          setTone(0.3);
        }
        if (key == '4') {
          setTone(0.4);
        }
        if (key == '5') {
          setTone(0.5);
        }
        if (key == '6') {
          setTone(0.6);
        }
        if (key == '7') {
          setTone(0.7);
        }
        if (key == '8') {
          setTone(0.8);
        }
        if (key == '9') {
          setTone(0.9);
        }
      } 
      if ((key == '+') && (mark_size < 32)) {
        mark_size = (byte)(mark_size*2);
      }
      if ((key == '-') && (mark_size > 1)) {
        mark_size = (byte)(mark_size/2);
      }
    }
    
  }
  
  /* Help Button */
  String help_button = "HELP";
  textFont(font, 14);
  if(mouseX > 986 && mouseX < 1022 && mouseY > 0 && mouseY < 10) {
    fill(255);
    if (mousePressed) {
      if (!show_help) {
        saveTemp();
        if (tab_key) {
          if (current_mode == skin_mode) {
            saveAlpha(sk_canvas);
          } else if (current_mode == hair_mode) {
            saveAlpha(hr_canvas);
          } else if (current_mode == eye_mode) {
            saveAlpha(i_canvas);
          } else if (current_mode == uv_mode) {
            saveAlpha(uv_canvas);
          }
        }
        show_help = true;
        showHelp();
        return;
      }      
    }
  } else fill(208, 255);
  text(help_button, 986, 12);
         
  oldMX = mouseX;
  oldMY = mouseY;
}

void mouseReleased() {
  cursor(CROSS);
  drawing = false;
}

void skinMode(boolean mode_init) {
  //cursor(CROSS);
  
  if (mode_init) {
    offx = 1.5;
    offy = 1.5;
    offw = 512;
    drawPallette();
    graphSkin();
    saveTemp();
    
  } else {
    
    if (current_skin == 0) {
      file_type = 0;
      if (!loaded[sk_head_file]) {
        open_new = true;
        openDialogue(true);
        return;
      }
    } else if (current_skin == 1) {
      file_type = 1;
      if (!loaded[sk_top_file]) {
        open_new = true;
        openDialogue(true);
        return;
      }
    } else if (current_skin == 2) {
      file_type = 2;
      if (!loaded[sk_bottom_file]) {
        open_new = true;
        openDialogue(true);
        return;
      }
    }
  
    if (!drawing) {
      getColor();
      showColor();
    }
  
    /*Draw on sk_canvas*/
    //if (mousePressed && (mouseX < 768)) {
    if ( (mouseX < 768) && (mouseY < 768) &&(keyPressed) && ((key == ' ')||(key == ENTER)) ) {
      drawing = true;
      noCursor();
      sk_canvas.beginDraw();
      sk_canvas.colorMode(HSB, 256);
      colorMode(HSB, 256);
      float strkA, strkB, strkC, strkD;
      strkA = oldMX/offx;
      strkB = oldMY/offy;
      strkC = mouseX/offx;
      strkD = mouseY/offy;
      sk_canvas.stroke(current_clr);
      stroke(current_clr);
      sk_canvas.strokeWeight(mark_size);
      strokeWeight((int)(mark_size*offx));
      sk_canvas.line(strkA, strkB, strkC, strkD);
      line(oldMX, oldMY, mouseX, mouseY);
      sk_canvas.endDraw();
    }
  }
}

void hairMode(boolean mode_init) {
  //cursor(CROSS);
  
  if (mode_init) {
    offx = 1.5;
    offy = 1.5;
    offw = 512;
    drawPallette();
    graphHair();
    saveTemp();
    
  } else {
    
    file_type = 3;
    if (!loaded[hair_file]) {
      open_new = true;
      openDialogue(true);
      return;
    }
    
    if (!drawing) {
      getColor();
      showColor();
    }
   
    /*Draw on hr_canvas*/
    if (mousePressed && (mouseX < 768)) {
      drawing = true;
      noCursor();
      hr_canvas.beginDraw();
      hr_canvas.colorMode(HSB, 256);
      colorMode(HSB, 256);
      hr_canvas.stroke(current_clr);
      stroke(current_clr);
      hr_canvas.strokeWeight(mark_size);
      strokeWeight((int)(mark_size*offx));
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
}

void eyeMode(boolean mode_init) {
  //cursor(CROSS);
  
  if (mode_init) {
    offx = 3;
    offy = 3;
    offw = 256;
    drawPallette();
    graphEyes();
    saveTemp();
    
  } else {
    
    file_type = 4;
    if (!loaded[eyes_file]) {
      open_new = true;
      openDialogue(true);
      return;
    }
    
    if (!drawing) {
      getColor();
      showColor();
    }
  
    /*Draw on i_canvas*/
    if (mousePressed && (mouseX < 768)) {
      drawing = true;
      noCursor();
      i_canvas.beginDraw();
      i_canvas.colorMode(HSB, 256);
      colorMode(HSB, 256);
      i_canvas.stroke(current_clr);
      stroke(current_clr);
      i_canvas.strokeWeight(mark_size);
      strokeWeight((int)(mark_size*offx));
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
}

void uvMode(boolean mode_init) {
  //cursor(CROSS);
  
  if (mode_init) {
    switch (uv_map_size) {
      case 512:
        offx = 1.5;
        offy = 1.5;
        offw = 512;
        break;
      case 256:
        offx = 3;
        offy = 3;
        offw = 256;
        break;
      case 128:
        offx = 6;
        offy = 6;
        offw = 128;
        break;
    }
    drawPallette();
    graphUV();
    saveTemp();
    
  } else {
    
    file_type = 5;
    if (!loaded[uv_file]) {
      open_new = true;
      openDialogue(true);
      return;
    }
    
    if (!drawing) {
      getColor();
      showColor();
    }
  
    /*Draw on uv_canvas*/
    if (mousePressed && (mouseX < 768)) {
      drawing = true;
      noCursor();
      uv_canvas.beginDraw();
      uv_canvas.colorMode(HSB, 256);
      colorMode(HSB, 256);
      uv_canvas.stroke(current_clr);
      stroke(current_clr);
      uv_canvas.strokeWeight(mark_size);
      strokeWeight((int)(mark_size*offx));
      float strkA, strkB, strkC, strkD;
      strkA = oldMX/offx;
      strkB = oldMY/offy;
      strkC = mouseX/offx;
      strkD = mouseY/offy;
      uv_canvas.line(strkA, strkB, strkC, strkD);
      line(oldMX, oldMY, mouseX, mouseY);
      uv_trace = false;
      uv_canvas.endDraw();
    }
  }
  
}

/* Show alpha channel */
void showAlpha(PGraphics canvas, boolean init) {
  //cursor(CROSS);
  
  if (init) {
    a_canvas = createGraphics(offw, offw, JAVA2D);
    canvas.loadPixels();
    a_canvas.loadPixels();
    a_canvas.background(0);
    for (int i = 0; i < offw; i++) {
      for (int j = 0; j < offw; j++) {
        color z = canvas.pixels[(i + j * offw)];
        a_canvas.pixels[(i + j * offw)] = color(0, 0, alpha(z), (int)(255 - alpha(z)/2));
      }
    }
    a_canvas.updatePixels();
    image(a_canvas, 0, 0, 768, 768);
  }
  
  else {
    
    if (!drawing) {
      getColor();
      showColor();
    }
  
    /*Draw on a_canvas*/
    if (mousePressed && (mouseX < 768)) {
      drawing = true;
      noCursor();
      a_canvas.beginDraw();
      a_canvas.colorMode(HSB, 256);
      colorMode(HSB, 256);
      a_canvas.stroke(brightness(current_clr));
      stroke(brightness(current_clr), (int)(255 - brightness(current_clr)/2));
      a_canvas.strokeWeight(mark_size);
      strokeWeight((int)(mark_size*offx));
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
}

/* Graph Skin to Background */
void graphSkin() {
  noStroke();
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
void graphHair() {
  noStroke();
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
void graphEyes() {
  noStroke();
  i_canvas = createGraphics(256, 256, JAVA2D);
  image(sl_base_eyes, 0, 0, 768, 768);
  i_canvas.beginDraw();
  i_canvas.image(sl_eyes, 0, 0);
  i_canvas.endDraw();
  image(i_canvas, 0, 0, 768, 768);
}

/* Graph UV Texture to Background */
void graphUV() {
  noStroke();
  uv_canvas = createGraphics(uv_map_size, uv_map_size, JAVA2D);
  fill(255);
  rect(0, 0, 768, 768);
  image(uv_base_map, uv_map_x, uv_map_y, (uv_map_x + 768), (uv_map_y + 768));
  uv_canvas.beginDraw();
  uv_canvas.image(uv_texture, 0, 0);
  uv_canvas.endDraw();
  image(uv_canvas, 0, 0, 768, 768);
}

/* Draw Pallette in side bar */
void drawPallette() {
  p_canvas = createGraphics(256, 512, JAVA2D);
  p_canvas.beginDraw();
  p_canvas.noStroke();
  p_canvas.colorMode(HSB, 256);
  for (int i = 0; i < 255; i++) {
    for (int j = 0; j < 255; j++) {
      p_canvas.stroke(j, i, 255 - i);
      p_canvas.point(i,j);
      p_canvas.stroke(j, i, (255 - (int)(i/2)));
      for (int z = 0; z < 2; z++) {
        p_canvas.point(i,j+z+256);
      }
    }
  }
  p_canvas.endDraw();
  image(p_canvas, 768, 0);
}

/*Get color from pallete*/
void getColor() {
  if (mousePressed && (mouseX >= 768)) {
    int h_clr, b_clr, s_clr = mouseX - 768;
    if (mouseY < 256) {
      h_clr = mouseY; 
      b_clr = 1024 - mouseX;
    } else {
      h_clr = (mouseY - 256);
      b_clr = 255;
    }
    if (keyPressed && key == CODED && keyCode == KeyEvent.VK_SHIFT) { 
      current_clr = color(h_clr, 0, b_clr);
      ctrl_key = false;
    } else {
      current_clr = color(h_clr, s_clr, b_clr);
    }
    clr_tone = b_clr;
    clr_hue = h_clr;
    clr_sat = s_clr;
  }
}

/* Show color */
void showColor () {
  image(p_canvas, 768, 0);
  noStroke();
  colorMode(HSB, 256);
  fill(current_clr);
  triangle(768, 224, 800, 256, 768, 286);
  stroke(current_clr);
  strokeWeight(mark_size);
  line(800, 256, 1024, 256); 
}

/* Change tone of current color*/
void setTone(float t) {
  int b = (int)(clr_tone * t);
  current_clr = color(clr_hue, clr_sat, b);
}

/* Save Alpha channel */
void saveAlpha(PGraphics canvas) {
  a_canvas.loadPixels();
  canvas.loadPixels();
  for (int i = 0; i < offw; i++) {
    for (int j = 0; j < offw; j++) {
      int q = i + j * offw;
      color z = canvas.pixels[q];
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
void colorFill(PGraphics canvas) {
  if((mouseX > 0) && (mouseY > 0)) {
    PGraphics tmp_canvas = createGraphics(offw, offw, JAVA2D);
    int pnt_clr = mouseX + mouseY * width;
    loadPixels();
    color fill_clr = pixels[pnt_clr];
    tmp_canvas.loadPixels();
    for (int i = 0; i < 768; i++) {
      for (int j = 0; j < 768; j++) {
        color z = pixels[(i + j * width)];
        if ((brightness(z) <= brightness(fill_clr) + 63) && (brightness(z) >= brightness(fill_clr) - 63)) {
           if(ctrl_key && (brightness(z) <= brightness(fill_clr) + 15) && (brightness(z) >= brightness(fill_clr) - 15) && (saturation(z) <= 31) ) { 
            tmp_canvas.pixels[((int)(i/offx) + (int)(j/offy) * offw)] = current_clr;
          } else if ((hue(z) <= hue(fill_clr) + 1) && (hue(z) >= hue(fill_clr) - 1) && (saturation(z) <= saturation(fill_clr) + 7) && (saturation(z) >= saturation(fill_clr) - 7)) {
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
void colorGrab(PGraphics canvas) {
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
void openDialogue(boolean init) {
  String prompt = "FILE NAME:",
  open_button = "OPEN",
  new_button = "NEW",
  cancel_button = "X"; 
  textFont(font, 18);  
  noStroke();
  fill(12);
  rect(256, 240, 512, 32);
  fill(208);
  text(prompt, 260, 264);
  fill(255);
  rect(364, 242, 256, 28);
  
  /* UV Map Open dialogue */
  if (current_mode == uv_mode) {
    String promptuv = "MAP TYPE:",
    grid_button = "GRID",
    box_button = "BOX",
    prism_button = "PRISM",
    cylinder_button = "CYLNDR",
    torus_button = "TORUS",
    tube_button = "TUBE",
    ring_button = "RING",
    custom_button = "CUTSTOM",
    size1_button = "128",
    size2_button = "256",
    size3_button = "512";
    fill(12);
    rect(256, 280, 512, 32);
    fill(208);
    text(promptuv, 260, 304);
    
    /* Custom map name prompt */
    if (uv_map_type == uv_custom) {
      fill(255);
      rect(364, 282, 256, 28);
      if (!init) {
        fill(0);
        text(uv_map_name.content, 370, 304);
      }
      /* Cancel custom button */
      if(mouseX > 628 && mouseX < 640 && mouseY > 288 && mouseY < 306) {
        fill(255);
        if (mousePressed) {
          uv_map_type = uv_grid;
        }
      } else fill(208);
      text(cancel_button, 628, 304);
    } 
    
    /*UV Map Selections */
    else {
      /* Grid button */
      if (mouseX > 362 && mouseX < 408 && mouseY > 288 && mouseY < 306) {
        fill(255);
        if (mousePressed) {
          uv_map_name.content = "UV-Grid-512.png";
          uv_base_map = loadImage("uv/" + uv_map_name.content);
        }
      } else fill(208);
      if (uv_map_type == uv_grid) fill(255);
      text(grid_button, 364, 304);
      /* Custom button */
      if (mouseX > 410 && mouseX < 496 && mouseY > 288 && mouseY < 306) {
        fill(255);
        if (mousePressed) {
          uv_map_type = uv_custom;
        }
      } else fill(208);
      text(custom_button, 412, 304);
    }
    
    /* 128 Size Button */
    if(mouseX > 644 && mouseX < 678 && mouseY > 288 && mouseY < 306) {
      fill(255);
      if (mousePressed) {
        uv_map_size = 128;
      }
    } else fill(208);
    if (uv_map_size == 128) fill (255);
    text(size1_button, 644, 304);
    
    /* 256 Size Button */
    if(mouseX > 680 && mouseX < 710 && mouseY > 288 && mouseY < 306) {
      fill(255);
      if (mousePressed) {
        uv_map_size = 256;
      }
    } else fill(208);
    if (uv_map_size == 256) fill (255);
    text(size2_button, 680, 304);
    
    /* 512 Size Button */
    if(mouseX > 714 && mouseX < 756 && mouseY > 288 && mouseY < 306) {
      fill(255);
      if (mousePressed) {
        uv_map_size = 512;
      }
    } else fill(208);
    if (uv_map_size == 512) fill (255);
    text(size3_button, 716, 304);
  }    
  
  /* Open Button */
  if(mouseX > 640 && mouseX < 680 && mouseY > 248 && mouseY < 266) {
    fill(255);
    if (mousePressed) {
      if (current_mode == uv_mode && uv_map_type == uv_custom) {
        /* Check that the uv map name is valid */
        String uv_ext = uv_map_name.content.substring((uv_map_name.content.length() - 4));
        if ((!uv_ext.equals(".png")) && (!uv_ext.equals(".jpg")) && (!uv_ext.equals(".tga")) ){
        uv_map_name.content = uv_map_name.content + ".png";
        }
        uv_base_map = loadImage("uv/" + uv_map_name.content);
        if (uv_base_map == null) {
          uv_base_map = loadImage("uv/UV-Grid-512.png");
          noUVBox();
          no_load = true;
          return;
        }
      }
      if (openNew(true)) {
        open_new = false;
        tab_key = false;
        return;
      } else {
        undoTemp();
        noloadBox();
        no_load = true;
        return;
      }
    }
  } else fill(208);
  text(open_button, 640, 264);
  
  /* New Button */
  if(mouseX > 692 && mouseX < 730 && mouseY > 248 && mouseY < 266) {
    fill(255);
    if (mousePressed) { 
      if (current_mode == uv_mode && uv_map_type == uv_custom) {
        /* Check that the uv map name is valid */
        String uv_ext = uv_map_name.content.substring((uv_map_name.content.length() - 4));
        if ((!uv_ext.equals(".png")) && (!uv_ext.equals(".jpg")) && (!uv_ext.equals(".tga")) ){
        uv_map_name.content = uv_map_name.content + ".png";
        }
        uv_base_map = loadImage("uv/" + uv_map_name.content);
        if (uv_base_map == null) {
          uv_base_map = loadImage("uv/UV-Grid-512.png");
          noUVBox();
          no_load = true;
          return;
        }
      }
      if (current_mode == skin_mode) {
        if (current_skin == 0) {
          loaded[sk_head_file] = true;
        } else if (current_skin == 1) {
          loaded[sk_top_file] = true;
        } else if (current_skin == 2) {
          loaded[sk_bottom_file] = true;
        }
      } else if (current_mode == hair_mode) {
        loaded[hair_file] = true;
      } else if (current_mode == eye_mode) {
        loaded[eyes_file] = true;
      } else if (current_mode == uv_mode) {
        loaded[uv_file] = true;
      }
      openNew(false);
      open_new = false;
      tab_key = false;
      return;
    }
  } else fill(208);
  text(new_button, 692, 264);
  
  /* Cancel button */
  if(mouseX > 736 && mouseX < 754 && mouseY > 248 && mouseY < 266) {
    fill(255);
    if (mousePressed) {
      open_new = false;
      if (current_mode == skin_mode) {
        if (current_skin == 0 && loaded[sk_head_file] == true) {
          skinMode(true);
          if (tab_key) showAlpha(sk_canvas, true);
          return;
        } else if (current_skin == 1 && loaded[sk_top_file] == true) {
          skinMode(true);
          if (tab_key) showAlpha(sk_canvas, true);
          return;
        } else if (current_skin == 2 && loaded[sk_bottom_file] == true) {
          skinMode(true);
          if (tab_key) showAlpha(sk_canvas, true);
          return;
        }
      } else if (current_mode == hair_mode) {
        if (loaded[hair_file]) {
          hairMode(true);
          if (tab_key) showAlpha(hr_canvas, true);
          return;
        }
      } else if (current_mode == eye_mode) {
        if (loaded[eyes_file]) {
          eyeMode(true);
          if (tab_key) showAlpha(i_canvas, true);
          return;
        }
      } else if (current_mode == uv_mode) {
        if (loaded[uv_file]) {
          uvMode(true);
          if (tab_key) showAlpha(uv_canvas, true);
          return;
        }
      }
    }
  } else fill(208);
  text(cancel_button, 738, 264);
  
  if (!init) {
    fill(0);
    text(texturename[file_type].content, 370, 264);
  }
  
  /* Text input */
  if (current_mode == uv_mode && uv_map_type == uv_custom) {
    textInput(uv_map_name);
  } else textInput(texturename[file_type]);
  
} 

boolean openNew(boolean openfile) {
  
  /* Check that the name is valid */
  String file_ext = texturename[file_type].content.substring((texturename[file_type].content.length() - 4));
  if ((!file_ext.equals(".png")) && (!file_ext.equals(".jpg")) && (!file_ext.equals(".tga")) ){
    texturename[file_type].content = texturename[file_type].content + ".png";
  }
  
  /* Open existing file */
  if(openfile) {
    if (current_mode == skin_mode ) {
      if (current_skin == sk_head) {
        sl_skin_head = loadImage("skin/" + texturename[file_type].content);
        if (sl_skin_head == null) return false;
        loaded[sk_head_file] = true;
      } else if (current_skin == sk_top) {
        sl_skin_top = loadImage("skin/" + texturename[file_type].content);
        if (sl_skin_top == null) return false;
        loaded[sk_top_file] = true;
      } else  if (current_skin == sk_bottom) {
        sl_skin_bottom = loadImage("skin/" + texturename[file_type].content);
        if (sl_skin_bottom == null) return false;
        loaded[sk_bottom_file] = true;
      }
      skinMode(true);
    } else if (current_mode == hair_mode) {
      sl_hair = loadImage("hair/" + texturename[file_type].content);
      if (sl_hair == null) return false;
      loaded[hair_file] = true;
      hairMode(true);
    } else if (current_mode == eye_mode) {
      sl_eyes = loadImage("eyes/" + texturename[file_type].content);
      if (sl_eyes == null) return false;
      loaded[eyes_file] = true;
      eyeMode(true);
    } else if (current_mode == uv_mode) {
      uv_texture = loadImage("uv/" + texturename[file_type].content);
      if (uv_texture == null) return false;
      loaded[uv_file] = true;
      uvMode(true);
    }
    saveTemp();
  }
  
  /* Initiate new file or overwrite existing file */
  else if (current_mode == skin_mode ) {
    if (current_skin == sk_head) {
      sl_skin_head = loadImage("blank/Blank-512.png");
    } else if (current_skin == sk_top) {
      sl_skin_top = loadImage("blank/Blank-512.png");
    } else if (current_skin == sk_bottom) {
      sl_skin_bottom = loadImage("blank/Blank-512.png");
    }
    graphSkin();
  } else if (current_mode == hair_mode) {
    sl_hair = loadImage("blank/Blank-512.png");
    graphHair();
  } else if (current_mode == eye_mode) {
    sl_eyes = loadImage("blank/Blank-256.png");
    graphEyes();
  } else if (current_mode == uv_mode) {
    uv_texture = loadImage("blank/Blank-512.png");
    graphUV();
  }
  return true;
}

/* Open/Save Alpha channel */
boolean openAlpha() {
  return true;
}

/* Open UV Base Map */
boolean openBaseuv() {
  return true;
}

/* No Load Box */
void noloadBox() {
  String not_loaded = "Could Not Load Texture";
  noStroke();
  fill(12);
  rect(256, 240, 308, 32);
  textFont(font, 18);
  fill(208);
  text(not_loaded, 260, 264);
}

/* No UV Map Box */
void noUVBox() {
  String not_loaded = "Could Not Load UV Map";
  noStroke();
  fill(12);
  rect(256, 280, 308, 32);
  textFont(font, 18);
  fill(208);
  text(not_loaded, 260, 304);
}

/* Save key command */
void saveKey () {
  if (tab_key) tab_key = false;
  saveTemp();
  if(ctrl_key) {
    savingBox();
    if (current_mode == skin_mode) {
      for(int i = 0; i < 3; i++) {
        nextKey();
        if (current_skin == sk_head) {
          sk_canvas.save("data/skin/" + texturename[0].content);
        } else if (current_skin == sk_top) {
          sk_canvas.save("data/skin/" + texturename[1].content);
        } else if (current_skin == sk_bottom) {
          sk_canvas.save("data/skin/" + texturename[2].content);
        }
        savingBox();
      }
    } else if (current_mode == hair_mode) {
      savingBox();
      hr_canvas.save("data/hair/" + texturename[3].content);
    } else if (current_mode == eye_mode) {
      savingBox();
      i_canvas.save("data/eyes/" + texturename[4].content);
    } else if (current_mode == uv_mode) {
      savingBox();
      uv_canvas.save("data/uv/" + texturename[5].content);
    }
    show_save = true;
  }
}

/* Saving Box */
void savingBox() {
  String saving = "SAVING";
  noStroke();
  fill(12);
  rect(256, 240, 308, 32);
  textFont(font, 18);
  fill(208);
  text(saving, 260, 264);
}

/* Next key command */
void nextKey() {
  saveTemp();
  if(current_skin < 2) {
    current_skin += 1;
   } else current_skin = 0;
   graphSkin();
   saveTemp();
}

/* Back key command */
void backKey() {
   saveTemp();
   if(current_skin > 0) {
      current_skin -= 1;
    } else current_skin = 2;
    graphSkin();
    saveTemp();
}
  
/* Save temp command */
void saveTemp () {
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
  } else if (current_mode == uv_mode) {
    uv_canvas.save("data/temp/Sim-Temp-UV-512.png");
    uv_texture = loadImage("temp/Sim-Temp-UV-512.png");
  }
}

/* Undo key command */
void undoTemp () {
  if (tab_key) tab_key = false;
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
  } else if (current_mode == uv_mode) {
    uv_texture = loadImage("temp/Sim-Temp-UV-512.png");
    graphUV();
  }
}

void showHelp() {
  noStroke();
  textFont(font, 14); 
  fill(0, 192);
  rect(0, 0, width, height);
  String help_txt = "ESC           - Quit SimEdit\n\nH              - Show/Hide Help screen w/list of key commands\n\nSPACE       - Mark/Draw on main canvas\n\nNum 0..9 - Change the tone (darkness) of current color. 1 to 9 is darkest to lightest; 0 resets to original\n\n+/-          - Increase/Decrease the size of the drawing mark (up to 32 pixels wide)\n\nO              - Open file or initiate a New file with the given name\n                 To open, the file must be placed in the appropriate folder ( i.e. './data/skin', './data/uv', etc.)\n\nG              - Grab color from canvas (based on position of cursor)\n\nShift + G  - Grab grayscale value from canvas (based on position of cursor)\n\nF               - Fill all pixels matching the color at the cursor position with selected color\n\nShift + F   - Fill all pixels matching the brightness (whiteness) of the color at the cursor position\n\nS               - Temporarily save canvas for later retrieval via undo (see below; this does NOT save to file)\n\nShift + S   - Save current canvas to file (normal save)\n\nU               - Undo to last saved state of current canvas\n\nF1/F2/F3/F4 - Skin/Hair/Eyes/UV modes. File's are opened/saved to './data/skin/' or\n                 './data/hair/' or './data/eyes/' or './data/uv/' repsective of each mode\n\nN/B          - Next/Previous portion of skin in skin mode (head, upper, lower)\n\nTAB          - Switch between normal and alpha mode.\n                 Edit the alpha channel of a texture using grayscale values; white is opaque; black is transparent (erase)";
  fill(255);
  text(help_txt, 8, 48);
  
}

/* Get text input from keyboard */
void textInput(Textline texttype) {
  if (time_t >= 4 && keyPressed) {
    if ((key == BACKSPACE) && (texttype.content.length() > 0)) {
      time_t = 0;
      texttype.content = texttype.content.substring(0, (texttype.content.length()-1));
    } else if (key != CODED) {
      time_t = 0;
      switch (key) {
        case '1':
          texttype.content = texttype.content + key;
          break;
        case '2':
          texttype.content = texttype.content + key;
          break;
        case '3':
          texttype.content = texttype.content + key;
          break;
        case '4':
          texttype.content = texttype.content + key;
          break;
        case '5':
          texttype.content = texttype.content + key;
          break;
        case '6':
          texttype.content = texttype.content + key;
          break;
        case '7':
          texttype.content = texttype.content + key;
          break;
        case '8':
          texttype.content = texttype.content + key;
          break;
        case '9':
          texttype.content = texttype.content + key;
          break;
        case '0':
          texttype.content = texttype.content + key;
          break;
        case '-':
          texttype.content = texttype.content + key;
          break;
        case '_':
          texttype.content = texttype.content + key;
          break;
        case '.':
          texttype.content = texttype.content + key;
          break;
        case '/':
          texttype.content = texttype.content + key;
          break;
        case '(':
          texttype.content = texttype.content + key;
          break;
        case ')':
          texttype.content = texttype.content + key;
          break;
        case '[':
          texttype.content = texttype.content + key;
          break;
        case ']':
          texttype.content = texttype.content + key;
          break;
        case 'q':
          texttype.content = texttype.content + key;
          break;
        case 'Q':
          texttype.content = texttype.content + key;
          break;
        case 'w':
          texttype.content = texttype.content + key;
          break;
        case 'W':
          texttype.content = texttype.content + key;
          break;
        case 'e':
          texttype.content = texttype.content + key;
          break;
        case 'E':
          texttype.content = texttype.content + key;
          break;
        case 'r':
          texttype.content = texttype.content + key;
          break;
        case 'R':
          texttype.content = texttype.content + key;
          break;
        case 't':
          texttype.content = texttype.content + key;
          break;
        case 'T':
          texttype.content = texttype.content + key;
          break;
        case 'y':
          texttype.content = texttype.content + key;
          break;
        case 'Y':
          texttype.content = texttype.content + key;
          break;
        case 'u':
          texttype.content = texttype.content + key;
          break;
        case 'U':
          texttype.content = texttype.content + key;
          break;
        case 'i':
          texttype.content = texttype.content + key;
          break;
        case 'I':
          texttype.content = texttype.content + key;
          break;
        case 'o':
          texttype.content = texttype.content + key;
          break;
        case 'O':
          texttype.content = texttype.content + key;
          break;
        case 'p':
          texttype.content = texttype.content + key;
          break;
        case 'P':
          texttype.content = texttype.content + key;
          break;
        case 'a':
          texttype.content = texttype.content + key;
          break;
        case 'A':
          texttype.content = texttype.content + key;
          break;
        case 's':
          texttype.content = texttype.content + key;
          break;
        case 'S':
          texttype.content = texttype.content + key;
          break;
        case 'd':
          texttype.content = texttype.content + key;
          break;
        case 'D':
          texttype.content = texttype.content + key;
          break;
        case 'f':
          texttype.content = texttype.content + key;
          break;
        case 'F':
          texttype.content = texttype.content + key;
          break;
        case 'g':
          texttype.content = texttype.content + key;
          break;
        case 'G':
          texttype.content = texttype.content + key;
          break;
        case 'h':
          texttype.content = texttype.content + key;
          break;
        case 'H':
          texttype.content = texttype.content + key;
          break;
        case 'j':
          texttype.content = texttype.content + key;
          break;
        case 'J':
          texttype.content = texttype.content + key;
          break;
        case 'k':
          texttype.content = texttype.content + key;
          break;
        case 'K':
          texttype.content = texttype.content + key;
          break;
        case 'l':
          texttype.content = texttype.content + key;
          break;
        case 'L':
          texttype.content = texttype.content + key;
          break;
        case 'z':
          texttype.content = texttype.content + key;
          break;
        case 'Z':
          texttype.content = texttype.content + key;
          break;
        case 'x':
          texttype.content = texttype.content + key;
          break;
        case 'X':
          texttype.content = texttype.content + key;
          break;
        case 'c':
          texttype.content = texttype.content + key;
          break;
        case 'C':
          texttype.content = texttype.content + key;
          break;
        case 'v':
          texttype.content = texttype.content + key;
          break;
        case 'V':
          texttype.content = texttype.content + key;
          break;
        case 'b':
          texttype.content = texttype.content + key;
          break;
        case 'B':
          texttype.content = texttype.content + key;
          break;
        case 'n':
          texttype.content = texttype.content + key;
          break;
        case 'N':
          texttype.content = texttype.content + key;
          break;
        case 'm':
          texttype.content = texttype.content + key;
          break;
        case 'M':
          texttype.content = texttype.content + key;
          break;
        case ' ':
          texttype.content = texttype.content + key;
          break; 
      }
    }
  }
}

