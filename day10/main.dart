import "dart:io";

bool isInside(List<List<int>> map, int x, int y) => 
  (0 <= x && x < map[0].length) && (0 <= y && y < map.length);

Set<(int, int)> getNeighbours(List<List<int>> map, int x, int y) {
  var result = <(int, int)>{};

  var target = map[y][x]+1;

  if (isInside(map, x-1, y) && map[y][x-1] == target) {
    result.add((x-1, y));
  }
  if (isInside(map, x+1, y) && map[y][x+1] == target) {
    result.add((x+1, y));
  }
  if (isInside(map, x, y-1) && map[y-1][x] == target) {
    result.add((x, y-1));
  }
  if (isInside(map, x, y+1) && map[y+1][x] == target) {
    result.add((x, y+1));
  }

  return result;
}

List<List<int>> toInt2D(List<String> lines) {
  var map = <List<int>>[];
  for (final line in lines) {
    map.add(line.runes.map<int>((a) => a-48).toList());
  }
  return map;
}

Set<(int, int)> getHeads(List<List<int>> map) {
  var heads = <(int, int)>{};
  for (int y = 0; y < map.length; y++) {
    for (int x = 0; x < map[y].length; x++) {
      if (map[y][x] != 0) {
        continue;
      }

      heads.add((x, y));
    }
  }
  return heads;
}

void part1(List<String> lines) {
  int sum = 0;

  var map = toInt2D(lines);
  var heads = getHeads(map);
  
  for (var start in heads) {
    var next = <(int, int)>{start};
    var peaks = <(int, int)>{};

    while (next.isNotEmpty) {
      // pop
      var (x, y) = next.first;
      next.remove((x, y));

      if (map[y][x] == 9) {
        peaks.add((x, y));
      } else {
        next.addAll(getNeighbours(map, x, y));
      }
    }
    sum += peaks.length;
  }


  print("Part 1: $sum");
}

int pathFinding(List<List<int>> map, int x, int y) {
  if (map[y][x] == 9) {
    return 1;
  }

  var neighbours = getNeighbours(map, x, y);
  int sum = 0;
  for (var (nx, ny) in neighbours) {
    sum += pathFinding(map, nx, ny);
  }

  return sum;
}

void part2(List<String> lines) {
  var map = toInt2D(lines);
  var heads = getHeads(map);

  int sum = 0;
  for (var (x, y) in heads) {
    sum += pathFinding(map, x, y);
  }

  print("Part 2: $sum");
}

void main() {
  var f = File("input");
  var lines = f.readAsLinesSync();

  part1(lines);
  part2(lines);
}
