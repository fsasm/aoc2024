import "dart:io";

class Field {
  List<String> _map;

  Field(this._map);
  Field.empty() : _map = <String>[];

  int get width => _map[0].length;
  int get height => _map.length;

  String get(Coord coord) => _map[coord.y][coord.x];
  void set(Coord coord, String cell) =>
      _map[coord.y] = _map[coord.y].replaceRange(coord.x, coord.x + 1, cell);
  bool isInside(Coord coord) =>
      (0 <= coord.x && coord.x < width) && (0 <= coord.y && coord.y < height);
  Field clone() => Field(List<String>.from(_map));
  void addLine(String line) => _map.add(line);

  void printDebug() {
    for (final l in _map) {
      print(l);
    }
  }
}

typedef Coord = ({int x, int y});

int score(Field field) {
  int sum = 0;
  const int SCALE_Y = 100;
  for (int y = 0; y < field.height; y++) {
    for (int x = 0; x < field.width; x++) {
      var coord = (x: x, y: y);
      var c = field.get(coord);
      if (c == "O") {
        sum += y * SCALE_Y + x;
      }
    }
  }
  return sum;
}

void part1(List<String> lines) {
  int sum = 0;

  String instructions = "";
  Field field = Field.empty();
  bool parseField = true;

  for (final l in lines) {
    if (l.length == 0) {
      parseField = false;
      continue;
    }

    if (parseField) {
      field.addLine(l);
    } else {
      instructions += l;
    }
  }

  field.printDebug();

  Coord robot = (x: -1, y: -1);
  for (int y = 0; y < field.height; y++) {
    for (int x = 0; x < field.width; x++) {
      var coord = (x: x, y: y);
      var c = field.get(coord);
      if (c == "@") {
        robot = coord;
        field.set(coord, ".");
        print("Robot starts at $coord");
      }
    }
  }

  for (int i = 0; i < instructions.length; i++) {
    var r = instructions[i];
    switch (r) {
      case '<':
        if (field.get((x: robot.x - 1, y: robot.y)) == ".") {
          robot = (x: robot.x - 1, y: robot.y);
        } else if (field.get((x: robot.x - 1, y: robot.y)) == "O") {
          bool canShift = false;
          int endX = robot.x;
          for (int x = robot.x - 1; x > 0; x--) {
            if (field.get((x: x, y: robot.y)) == "#") {
              canShift = false;
              break;
            }
            if (field.get((x: x, y: robot.y)) == ".") {
              canShift = true;
              endX = x;
              break;
            }
          }

          if (canShift) {
            for (int x = endX; x < robot.x; x++) {
              field.set((x: x, y: robot.y), field.get((x: x + 1, y: robot.y)));
            }
            robot = (x: robot.x - 1, y: robot.y);
          }
        }
        break;

      case '>':
        if (field.get((x: robot.x + 1, y: robot.y)) == ".") {
          robot = (x: robot.x + 1, y: robot.y);
        } else {
          bool canShift = false;
          int endX = robot.x;
          for (int x = robot.x + 1; x < field.width; x++) {
            if (field.get((x: x, y: robot.y)) == "#") {
              canShift = false;
              break;
            }
            if (field.get((x: x, y: robot.y)) == ".") {
              canShift = true;
              endX = x;
              break;
            }
          }

          if (canShift) {
            for (int x = endX; x > robot.x; x--) {
              field.set((x: x, y: robot.y), field.get((x: x - 1, y: robot.y)));
            }
            robot = (x: robot.x + 1, y: robot.y);
          }
        }
        break;

      case '^':
        if (field.get((x: robot.x, y: robot.y - 1)) == ".") {
          robot = (x: robot.x, y: robot.y - 1);
        } else {
          bool canShift = false;
          int endY = robot.y;
          for (int y = robot.y - 1; y > 0; y--) {
            if (field.get((x: robot.x, y: y)) == "#") {
              canShift = false;
              break;
            }
            if (field.get((x: robot.x, y: y)) == ".") {
              canShift = true;
              endY = y;
              break;
            }
          }

          if (canShift) {
            for (int y = endY; y < robot.y; y++) {
              field.set((x: robot.x, y: y), field.get((x: robot.x, y: y + 1)));
            }
            robot = (x: robot.x, y: robot.y - 1);
          }
        }
        break;

      case 'v':
        if (field.get((x: robot.x, y: robot.y + 1)) == ".") {
          robot = (x: robot.x, y: robot.y + 1);
        } else {
          bool canShift = false;
          int endY = robot.y;
          for (int y = robot.y + 1; y < field.height; y++) {
            if (field.get((x: robot.x, y: y)) == "#") {
              canShift = false;
              break;
            }
            if (field.get((x: robot.x, y: y)) == ".") {
              canShift = true;
              endY = y;
              break;
            }
          }

          if (canShift) {
            for (int y = endY; y > robot.y; y--) {
              field.set((x: robot.x, y: y), field.get((x: robot.x, y: y - 1)));
            }
            robot = (x: robot.x, y: robot.y + 1);
          }
        }
        break;

      default:
        print("Invalid character: $r");
    }
    print("Move: $r");
    field.set(robot, "@");
    field.printDebug();
    field.set(robot, ".");
  }

  sum = score(field);

  field.set(robot, "@");
  field.printDebug();

  print("Part 1: $sum");
}

void main() {
  var f = File("input");
  var lines = f.readAsLinesSync();

  part1(lines);
}
