import codeanticode.syphon.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.Vector3D;
import peasy.org.apache.commons.math.geometry.Rotation;
import peasy.org.apache.commons.math.geometry.RotationOrder;

SyphonServer server;
PeasyCam cam;

PImage sunImage;

int rows;
int cols;
float scale = 30.0f;
int w = 1800;
int h = 1600;
float heightThreshold = 0;
int flySpeed = 1;

CameraState state;


float flying = 0;

float[][] terrain;
float[][] distantTerrain;

public void settings() {
    size(1280, 720, P3D);
}

void setup() {
  cols = (int)(w / scale);
  rows = (int)(h / scale);

  frameRate(10);

  sunImage = loadImage("instagram-sun02.png");

  terrain = new float[cols][rows];

  distantTerrain = new float[cols][rows];
  for (int y = 0; y < rows - 1; ++y) {
    for (int x = 0; x < cols; ++x) {
      distantTerrain[x][y] = map(noise(x/5.0f, y/5.0f), 0, 1, -100, 100);
    }
  }

  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");

  cam = new PeasyCam(this, 400);
  cam.setPitchRotationMode();

  CameraState cs = new CameraState(
      new Rotation(RotationOrder.XYZ, -0.53, 0, 0),
      new Vector3D(627.0, 624.8, 549.0),
      93.3f);
  cam.setState(cs);
}

public void keyReleased() {
  if (key == '1') state = cam.getState();
  if (key == '2') cam.setState(state, 1000);
  if (key == '3') {
    println(cam.getPosition());
    println(cam.getDistance());
    println(cam.getRotations());
    println(cam.getWheelScale());
  }
  if (key == '4') {
    CameraState cs = new CameraState(
        new Rotation(RotationOrder.XYZ, -0.53, 0, 0),
        new Vector3D(627.0, 624.8, 549.0),
        93.3f);
    cam.setState(cs);
  }
}

void draw() {

  flying -= 0.2 * flySpeed;

  // generate terrain mesh
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

  background(0, 255, 0);

  //// draw sun
  //pushMatrix();
  //noStroke();
  //noFill();
  //translate(width / 2, (height / 2), 0);

  //beginShape();
  //texture(sunImage);
  //vertex(-100, -100, 0, 0, 0);
  //vertex( 100, -100, 0, sunImage.width, 0);
  //vertex( 100,  100, 0, sunImage.width, sunImage.height);
  //vertex(-100,  100, 0, 0, sunImage.height);
  //endShape();

  //popMatrix();

  // draw terrain
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

  // draw distant terrain
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

  // send screen with Syphon
  server.sendScreen();
}

float f(float in) {
  return in * 1.4f;
}

float f2(float in) {
  return in;
}
