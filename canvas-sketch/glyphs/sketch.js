const canvasSketch = require("canvas-sketch");
const random = require("canvas-sketch-util/random");
const _ = require("lodash");

const settings = {
  dimensions: [2048, 2048],
};

const sketch = () => {
  random.setSeed(random.getRandomSeed());
  //console.log("seed:", random.getSeed());

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

  const connectedComponents = (points) => {
    const visited = [];
    const nodes = points.filter((p) => p.fill).map((p) => p.pos);

    const neighbours = ([x, y]) => {
      return _.filter(
        [
          [x + 1, y],
          [x, y + 1],
          [x - 1, y],
          [x, y - 1],
        ],
        (p) => contains(nodes, p)
      );
    };

    const bfs = (startNode) => {
      const queue = [startNode];
      let nodeCount = 0;
      while (queue.length > 0) {
        const node = queue.pop();
        if (!contains(visited, node)) {
          queue.push(...neighbours(node));
          visited.push(node);
          nodeCount++;
        }
      }
      return nodeCount;
    };

    let count = 0;
    const sizes = [];
    for (const node of nodes) {
      if (contains(visited, node)) {
        continue;
      }
      sizes.push(bfs(node));
      count++;
    }

    return {
      count,
      sizes,
    };
  };

  const contains = (ps, p) => {
    return !!_.find(ps, (q) => {
      const [x1, y1] = p;
      const [x2, y2] = q;
      return x1 === x2 && y1 === y2;
    });
  };

  const fitness = (count, sizes) => {
    let score = 50;
    if (count <= 3) {
      score += 10;
    }
    if (count > 1) {
      score += 5;
    }
    for (const s of sizes) {
      if (s == 1) {
        score -= 10;
      }
      if (s > 5) {
        score += 3;
      }
    }
    return score; // && sizes.every((x) => x > 1);
  };

  const gridSize = 7;
  let points = createGrid(gridSize, gridSize);
  let { count, sizes } = connectedComponents(points);
  while (fitness(count, sizes) < 0) {
    points = createGrid(gridSize, gridSize);
    const result = connectedComponents(points);
    count = result.count;
  }

  console.log("LOG: count", count);
  console.log("LOG: sizes", sizes);
  console.log("LOG: fitness", fitness(count, sizes));

  return ({ context, width, height }) => {
    context.fillStyle = "black";
    context.fillRect(0, 0, width, height);

    context.fillStyle = "white";

    const size = 220;
    const gap = 10;
    const offset = 0.85;
    points.forEach(({ pos, fill }) => {
      if (fill) {
        const [u, v] = pos;
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
