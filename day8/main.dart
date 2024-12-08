import "dart:io";

class Field {
  List<String> _map;

  Field(this._map);

  int get width => _map[0].length;
  int get height => _map.length;

  int contains(int y, String cell) => _map[y].indexOf(cell);
  String Get(int x, int y) => _map[y][x];
  void Set(int x, int y, String cell) => _map[y] = _map[y].replaceRange(x, x+1, cell);
  bool isInside(int x, int y) => (0 <= x && x < width) && (0 <= y && y < height);
  Field clone() => Field(List<String>.from(_map));

  void printDebug() {
    for (final l in _map) {
      print(l);
    }
  }
}

bool setAntinode(Field map, int x, int y) {
  if (!map.isInside(x, y)) {
    return false;
  }

  if (map.Get(x, y) == ".") {
    map.Set(x, y, "#");
    return true;
  }
  if (map.Get(x, y) == "#") {
    return false;
  }

  // overwrite an antenna with an antinode, otherwise multiple antinodes are on
  // the same cell, making the count too high
  map.Set(x, y, "#");
  return true;
}

Map<String, List<(int, int)>> extractAntennas(Field map) {
  var nodes = <String, List<(int, int)>>{};

  // get all antennas
  for (int y = 0; y < map.height; y++) {
    for (int x = 0; x < map.width; x++) {
      String cell = map.Get(x, y);
      if (cell == ".") {
        continue;
      }

      if (nodes.containsKey(cell)) {
        nodes[cell]!.add((x,y));
      } else {
        nodes[cell] = <(int, int)>[(x,y)];
      }
    }
  }
  return nodes;
}

void part1(Field map) {
  var nodes = extractAntennas(map);

  // calculate all antinodes
  int sum = 0;
  for (var n in nodes.entries) {
    for (int i = 0; i < n.value.length; i++) {
      var (x0, y0) = n.value[i];
      for (int j = i+1; j < n.value.length; j++) {
        var (x1, y1) = n.value[j];
        int dx = x1 - x0;
        int dy = y1 - y0;

        if (setAntinode(map, x1+dx, y1+dy)) {
          sum++;
        }

        if (setAntinode(map, x0-dx, y0-dy)) {
          sum++;
        }
      }
    }
  }

  print("Part 1: $sum");
}

void part2(Field map) {
  var nodes = extractAntennas(map);

  // calculate all antinodes
  int sum = 0;
  for (var n in nodes.entries) {
    for (int i = 0; i < n.value.length; i++) {
      var (x0, y0) = n.value[i];
      for (int j = i+1; j < n.value.length; j++) {
        var (x1, y1) = n.value[j];
        int dx = x1 - x0;
        int dy = y1 - y0;

        for (var f = 0; true; f++) {
          int x = x1 + dx * f;
          int y = y1 + dy * f;

          if (!map.isInside(x, y)) {
            break;
          }
          if (setAntinode(map, x, y)) {
            sum++;
          }
        }

        for (var f = 0; true; f++) {
          int x = x0 - dx * f;
          int y = y0 - dy * f;

          if (!map.isInside(x, y)) {
            break;
          }
          if (setAntinode(map, x, y)) {
            sum++;
          }
        }
      }
    }
  }

  print("Part 2: $sum");
}

void main() {
  var f = File("input");
  var lines = f.readAsLinesSync();
  var map = Field(lines);

  part1(map.clone());
  part2(map.clone());
}
