import "dart:io";

class PatrolMap {
  List<String> _map;

  PatrolMap(this._map);

  int contains(int y, String cell) => _map[y].indexOf(cell);
  String Get(int x, int y) => _map[y][x];
  void Set(int x, int y, String cell) => _map[y] = _map[y].replaceRange(x, x+1, cell);
  int get width => _map[0].length;
  int get height => _map.length;
  void printDebug() {
    for (final l in _map) {
      print(l);
    }
  }

  PatrolMap clone() => PatrolMap(List<String>.from(_map));
}

(int, int) findGuardStart(PatrolMap map) {
  for (var j = 0; j < map.height; j++) {
    var i = map.contains(j, "^");
    if (i != -1) {
      return (i, j);
    }
  }

  return (-1, -1);
}

enum Dir {
  Up, Down, Left, Right, Out
}

void part1(PatrolMap map) {
  int sum = walk(map);
  print("Part 1: $sum");
}

int walk(PatrolMap map) {
  int sum = 0;
  int maxSteps = 10000;

  var (guardX, guardY) = findGuardStart(map);
  Dir dir = Dir.Up;

  map.Set(guardX, guardY, 'X');
  sum++;
  maxSteps--;

  while (maxSteps > 0) {
    maxSteps--;
    switch (dir) {
      case Dir.Up:
        if (guardY == 0) {
          dir = Dir.Out;
        } else if (map.Get(guardX, guardY-1) == '#') {
          dir = Dir.Right;
        } else {
          if (map.Get(guardX, guardY) == ".") {
            sum++;
          }
          map.Set(guardX, guardY, 'X');
          guardY--;
        }
        break;
      case Dir.Down:
        if (guardY == (map.height-1)) {
          dir = Dir.Out;
        } else if (map.Get(guardX, guardY+1) == '#') {
          dir = Dir.Left;
        } else {
          if (map.Get(guardX, guardY) == ".") {
            sum++;
          }
          map.Set(guardX, guardY, 'X');
          guardY++;
        }
        break;
      case Dir.Left:
        if (guardX == 0) {
          dir = Dir.Out;
        } else if (map.Get(guardX-1, guardY) == '#') {
          dir = Dir.Up;
        } else {
          if (map.Get(guardX, guardY) == ".") {
            sum++;
          }
          map.Set(guardX, guardY, 'X');
          guardX--;
        }
        break;
      case Dir.Right:
        if (guardX == (map.width-1)) {
          dir = Dir.Out;
        } else if (map.Get(guardX+1, guardY) == '#') {
          dir = Dir.Down;
        } else {
          if (map.Get(guardX, guardY) == ".") {
            sum++;
          }
          map.Set(guardX, guardY, 'X');
          guardX++;
        }
        break;
      case Dir.Out:
        if (map.Get(guardX, guardY) == ".") {
          sum++;
        }
        map.Set(guardX, guardY, 'X');
        return sum;
    }
  }

  return -1;
}

void part2(PatrolMap map) {
  int sum = 0;

  // NOTE how to improve:
  // - cycle detection: have a history of turns (being in front of an obstacle
  //   and turning by 90° CW) and if we are at the same cell and doing the same
  //   turn, then we have a cycle. Would eliminate the maxStep logic and terminate
  //   earlier.
  // - only place an obstacle on and next to the path without obstacles: no need
  //   to put an obstacle where the guards will never encounter it.

  // brute-force: try putting an obstacle on every empty cell
  for (int y = 0; y < map.height; y++) {
    for (int x = 0; x < map.width; x++) {
      if (map.Get(x, y) != '.') {
        continue;
      }

      var newMap = map.clone();
      newMap.Set(x, y, '#');

      if (walk(newMap) == -1) {
        sum++;
      }
    }
  }

  print("Part 2: $sum");
}

void main() {
  var f = File("input");
  var lines = f.readAsLinesSync();
  var map = PatrolMap(lines);

  part1(map.clone());
  part2(map);
}
