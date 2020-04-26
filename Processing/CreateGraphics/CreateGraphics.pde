/**
 * Create Graphics. 
 * 
 * The createGraphics() function creates an object from the PGraphics class 
 * PGraphics is the main graphics and rendering context for Processing. 
 * The beginDraw() method is necessary to prepare for drawing and endDraw() is
 * necessary to finish. Use this class if you need to draw into an off-screen 
 * graphics buffer or to maintain two contexts with different properties.
 */

import processing.svg.*;
import processing.pdf.*;

PGraphics pg;

void setup() {
  size(640, 360);
  pg = createGraphics(4961, 3508);
}

void draw() {
  draw_(pg);
    
  // Draw the offscreen buffer to the screen with image() 
  image(pg, 120, 60, 400, 200); 
}

void draw_(PGraphics pg) {
  fill(0, 12);
  rect(0, 0, width, height);
  fill(255);
  noStroke();
  ellipse(mouseX, mouseY, 60, 60);
  
  pg.beginDraw();
  pg.scale(100);
  pg.background(51);
  pg.noFill();
  pg.stroke(255);
  pg.ellipse(mouseX-120, mouseY-60, 60, 60);

  pg.beginShape();
  pg.curveDetail(20);
  pg.curveVertex(84,  91);
  pg.curveVertex(84,  91);
  pg.curveVertex(68,  19);
  pg.curveVertex(21,  17);
  pg.curveVertex(32, 100);
  pg.curveVertex(32, 100);
  pg.endShape();

  pg.endDraw();
}

void keyPressed() {
  PGraphics graphic = createGraphics(4961, 3508, PDF, "test.pdf");
  draw_(graphic);
  graphic.dispose();
}
