const canvasSketch = require("canvas-sketch");
const { lerp } = require("canvas-sketch-util/math");
const random = require("canvas-sketch-util/random");
const palettes = require("nice-color-palettes");

const settings = {
  dimensions: [2048, 2048],
};

const sketch = () => {
  const palette = random.pick(palettes);
  //random.setSeed(1);

  const createGrid = () => {
    const points = [];
    const count = 30;
    for (x = 0; x < count; x++) {
      for (y = 0; y < count; y++) {
        const u = count <= 1 ? 0.5 : x / (count - 1);
        const v = count <= 1 ? 0.5 : y / (count - 1);
        points.push({
          radius: Math.abs(0.01 + random.noise2D(u, v) * 0.05),
          position: [u, v],
          color: random.pick(palette),
        });
      }
    }
    return points;
  };

  const points = createGrid().filter(() => random.value() > 0.5);
  const margin = 100;

  return ({ context, width, height }) => {
    context.fillStyle = "white";
    context.fillRect(0, 0, width, height);

    points.forEach(({ position, radius, color }) => {
      const [u, v] = position;
      const x = lerp(margin, width - margin, u);
      const y = lerp(margin, height - margin, v);

      context.beginPath();
      context.arc(x, y, radius * width, 0, Math.PI * 2, false);
      context.fillStyle = color;
      context.fill();
    });
  };
};

canvasSketch(sketch, settings);
