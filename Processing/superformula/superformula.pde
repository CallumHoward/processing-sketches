// Superformula
// Callum Howard 2019

// globals
int t = 0;

void setup() {
  size(500, 500);

  noFill();
  stroke(255);
  strokeWeight(2);
}

void draw() {
  background(0);

  translate(width / 2, height / 2);

  beginShape();

  float resolutionFactor = 100;
  for (float theta = 0; theta <= 2f * PI; theta += 1f / resolutionFactor) {

    float timeScaleFactor = 10f;

    float a = mouseX / 100f;  // size
    float b = mouseY / 100f;
    float m = 1f;            // number of rotational symmetry
    float n1 = 1f;
    float n2 = 1f; //sin(t / timeScaleFactor);  // shape of spikes
    float n3 = 1f; //cos(t / timeScaleFactor);  // shape of spikes
    float rad = r(theta, a, b, m, n1, n2, n3);

    // transform into radial coordinates
    float scaleFactor = 50;
    float x = rad * cos(theta) * scaleFactor;
    float y = rad * sin(theta) * scaleFactor;
    vertex(x, y);
  }

  endShape(CLOSE);

  t += 1;
}

/*
float r(float theta, float a, float b, float m, float n1, float n2, float n3) {
  return pow(
      pow(abs(cos(m * theta / 4f) / a), n2) +
      pow(abs(sin(m * theta / 4f) / b), n3), -1f / n1);
}
*/

float r(float theta, float a, float b, float m, float n1, float n2, float n3) {
  return pow(
      pow(abs(cos(m * theta / 4f) / a), n2) +
      pow(abs(sin(m * theta / 4f) / b), n3), -1f / n1);
}
