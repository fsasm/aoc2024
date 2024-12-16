import "dart:io";
import "dart:math";

typedef Coord = ({int x, int y});

void part1(List<String> lines) {
  int sum = 0;

  var re = RegExp(r"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)");
  var quad = List<int>.filled(4, 0);
  const width = 101;
  const height = 103;
  for (final l in lines) {
    var match = re.firstMatch(l);
    if (match == null) {
      continue;
    }
    
    var p = (
      x: int.parse(match.group(1)!),
      y: int.parse(match.group(2)!),
    );
    
    var v = (
      x: int.parse(match.group(3)!),
      y: int.parse(match.group(4)!),
    );

    for (int i = 0; i < 100; i++) {
      p = (
        x: p.x + v.x,
        y: p.y + v.y,
      );
    }

    p = (
      x: p.x % width,
      y: p.y % height,
    );

    int midX = width ~/ 2;
    int midY = height ~/ 2;

    if (p.x == midX || p.y == midY) {
      continue;
    }

    if (p.x < midX) {
      if (p.y < midY) {
        quad[0]++;
      } else {
        quad[1]++;
      }
    } else {
      if (p.y < midY) {
        quad[2]++;
      } else {
        quad[3]++;
      }
    }
  }

  sum = quad.fold(1, (p,c) => p*c);
  print("Part 1: $sum");
}

(int, int, String) PrintRobots(List<(Coord, Coord)> robots) {
  var field = <Coord, int>{};
  int maxOverlapp = 0;
  for (final r in robots) {
    field[r.$1] = 1+(field[r.$1] ?? 0);
    maxOverlapp = max(maxOverlapp, field[r.$1]!);
  }

  int maxRun = 0;
  String line = "";
  for (int y = 0; y < 103; y++) {
    bool prevHasRobot = false;
    int curRun = 0;
    for (int x = 0; x < 101; x++) {
      var curr = (x: x, y: y);
      if (field.containsKey(curr)) {
        if (prevHasRobot) {
          curRun++;
          maxRun = max(maxRun, curRun);
        }
        prevHasRobot = true;
        line += "#";
      } else {
        prevHasRobot = false;
        line += " ";
      }
    }
    line += "\n";
  }
  return (maxRun, maxOverlapp, line);
}

void part2(List<String> lines) {
  int sum = 0;

  var re = RegExp(r"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)");
  const width = 101;
  const height = 103;
  var robots = <(Coord, Coord)>[];
  for (final l in lines) {
    var match = re.firstMatch(l);
    if (match == null) {
      continue;
    }
    
    var p = (
      x: int.parse(match.group(1)!),
      y: int.parse(match.group(2)!),
    );
    
    var v = (
      x: int.parse(match.group(3)!),
      y: int.parse(match.group(4)!),
    );
    
    robots.add((p, v));
  }

  for (int i = 0; i < 10000; i++) {
    for (int j = 0; j < robots.length; j++) {
      var (p, v) = robots[j];
      
      p = (
        x: (p.x + v.x) % width,
        y: (p.y + v.y) % height,
      );

      robots[j] = (p, v);
    }
    var (run, overlap, line) = PrintRobots(robots);
    if (run > 1 && overlap == 1) {
      print("$i:");
      print(line);
    }
  }

  print("Part 2: $sum");
}

void main() {
  var f = File("input");
  var lines = f.readAsLinesSync();

  part1(lines);
  part2(lines);
}
