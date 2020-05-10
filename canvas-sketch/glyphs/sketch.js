const canvasSketch = require("canvas-sketch");
const random = require("canvas-sketch-util/random");

const settings = {
  dimensions: [2048, 2048],
};

const sketch = () => {
  random.setSeed(random.getRandomSeed());
  console.log("seed:", random.getSeed());

  const createGrid = (width, height) => {
    const grid = [];
    for (let row = 0; row < height; row++) {
      for (let col = 0; col < width; col++) {
        grid.push({
          pos: [row, col],
          fill: random.value() > 0.5,
        });
      }
    }
    return grid;
  };

  const points = createGrid(10, 10);

  return ({ context, width, height }) => {
    context.fillStyle = "black";
    context.fillRect(0, 0, width, height);

    context.fillStyle = "white";
    // context.fillRect(0, 0, 50, 50);

    const size = 150;
    const gap = 10;
    const offset = 1.5;
    points.forEach(({ pos, fill }) => {
      if (fill) {
        const [u, v] = pos;
        console.log("LOG: ", pos);
        context.fillRect(
          (u + offset) * (gap + size),
          (v + offset) * (gap + size),
          size,
          size
        );
      }
    });
  };
};

canvasSketch(sketch, settings);
