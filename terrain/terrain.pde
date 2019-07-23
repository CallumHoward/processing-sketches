import codeanticode.syphon.*;

SyphonServer server;

int rows;
int cols;
float scale = 30.0f;
int w = 1800;
int h = 1600;
float heightThreshold = 0;
int flySpeed = 1;


PVector cameraPos = new PVector(
    width / 2.0 - w / 2, 
    height / 2.0 - h / 2, 
    (height / 2.0) / tan(PI * 30.0 / 180.0));
PVector targetPos = new PVector(
    width / 2.0 + w / 2, 
    height / 2.0 + h / 2, 
    0);
float camZOff = 0;
float tarZOff = 0;

float flying = 0;

float[][] terrain;
float[][] distantTerrain;

void setup() {
  size(1920, 1080, P3D);
  cols = (int)(w / scale);
  rows = (int)(h / scale);

  //camera(
  //    cameraPos.x, cameraPos.y + camZOff, cameraPos.z,
  //    targetPos.x, targetPos.y + tarZOff, targetPos.z,
  //    0, 1, 0);

  //frameRate(3);
  smooth(2);

  terrain = new float[cols][rows];

  distantTerrain = new float[cols][rows];
  for (int y = 0; y < rows - 1; ++y) {
    for (int x = 0; x < cols; ++x) {
      distantTerrain[x][y] = map(noise(x/5.0f, y/5.0f), 0, 1, -100, 100);
    }
  }
  
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      camZOff += 5;
    } else if (keyCode == DOWN) {
      camZOff -= 5;
    } else if (keyCode == LEFT) {
      tarZOff += 5;
    //} else if (keyCode == RIGHT) {
    //  tarZOff -= 5;
    } else if (keyCode == RIGHT) {
      flySpeed = 0;
      println("flySpeed changed");
    }
  } else {
    
  }

  //camera(
  //    cameraPos.x, cameraPos.y + camZOff, cameraPos.z,
  //    targetPos.x, targetPos.y + tarZOff, targetPos.z,
  //    0, 1, 0);
}

void draw() {

  flying -= 0.2 * flySpeed;

  float yoff = flying;
  for (int y = 0; y < rows; ++y) {
    float xoff = 0;
    for (int x = 0; x < cols; ++x) {
      float noiseVal = map(noise(xoff, yoff), 0, 1, -100, 100);
      if (x > cols * 7 / 16 && x < cols * 9 / 16) {
        terrain[x][y] = heightThreshold;
      } else {
        terrain[x][y] = constrain(noiseVal, heightThreshold, 100);
      }
      xoff += 0.2;
    }
    yoff += 0.2;
  }

  background(0);

  translate(width / 2, height / 2);
  rotateX(PI / 3);
  translate(-w / 2, -h / 2);
  for (int y = 0; y < rows - 1; ++y) {
    fill(0, 0, 70, 255);//(int)map(y, 0, rows, 0, 255));
    for (int x = 0; x < rows - 1; ++x) {
      //fill(0, 0, 0, 127);
      noStroke();
      beginShape(TRIANGLE_STRIP);
      vertex(x * scale, y * scale, f(terrain[x][y]));
      vertex((x + 1) * scale, y * scale, f(terrain[(x + 1)][y]));
      vertex((x + 1) * scale, (y + 1) * scale, f(terrain[(x + 1)][(y + 1)]));
      vertex(x * scale, y * scale, f(terrain[x][y]));
      vertex(x * scale, (y + 1) * scale, f(terrain[x][(y + 1)]));
      vertex((x + 1) * scale, (y + 1) * scale, f(terrain[(x + 1)][(y + 1)]));
      endShape(CLOSE);

      stroke(100, 90, 255, 127);
      beginShape();
      vertex(x * scale, y * scale, f(terrain[x][y]));
      vertex((x + 1) * scale, y * scale, f(terrain[(x + 1)][y]));
      vertex((x + 1) * scale, (y + 1) * scale, f(terrain[(x + 1)][(y + 1)]));
      vertex(x * scale, (y + 1) * scale, f(terrain[x][(y + 1)]));
      endShape(CLOSE);
    }
  }

  translate(0, -h);
  for (int y = 0; y < rows - 1; ++y) {
    for (int x = 0; x < rows - 1; ++x) {
      beginShape();
      vertex(x * scale, y * scale, f2(distantTerrain[x][y]));
      vertex((x + 1) * scale, y * scale, f2(distantTerrain[(x + 1)][y]));
      vertex((x + 1) * scale, (y + 1) * scale, f2(distantTerrain[(x + 1)][(y + 1)]));
      vertex(x * scale, (y + 1) * scale, f2(distantTerrain[x][(y + 1)]));
      endShape(CLOSE);
    }
  }
  server.sendScreen();
}

float f(float in) {
  return in * 1.4f;
}

float f2(float in) {
  return in;
}
