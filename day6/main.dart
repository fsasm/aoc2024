import "dart:io";

(int, int) findGuardStart(List<String> lines) {
  for (var j = 0; j < lines.length; j++) {
    var i = lines[j].indexOf("^");
    if (i != -1) {
      return (i, j);
    }
  }

  return (-1, -1);
}

enum Dir {
  Up, Down, Left, Right, Out
}

void part1(List<String> lines) {
  int sum = 0;
  int maxSteps = 10000;

  var (guardX, guardY) = findGuardStart(lines);
  Dir dir = Dir.Up;

  lines[guardY] = lines[guardY].replaceRange(guardX, guardX+1, 'X');
  sum++;
  maxSteps--;

  while (maxSteps > 0) {
    maxSteps--;
    switch (dir) {
      case Dir.Up:
        if (guardY == 0) {
          dir = Dir.Out;
        } else if (lines[guardY-1][guardX] == '#') {
          dir = Dir.Right;
        } else {
          if (lines[guardY][guardX] == ".") {
            sum++;
          }
          lines[guardY] = lines[guardY].replaceRange(guardX, guardX+1, 'X');
          guardY--;
        }
        break;
      case Dir.Down:
        if (guardY == (lines.length-1)) {
          dir = Dir.Out;
        } else if (lines[guardY+1][guardX] == '#') {
          dir = Dir.Left;
        } else {
          if (lines[guardY][guardX] == ".") {
            sum++;
          }
          lines[guardY] = lines[guardY].replaceRange(guardX, guardX+1, 'X');
          guardY++;
        }
        break;
      case Dir.Left:
        if (guardX == 0) {
          dir = Dir.Out;
        } else if (lines[guardY][guardX-1] == '#') {
          dir = Dir.Up;
        } else {
          if (lines[guardY][guardX] == ".") {
            sum++;
          }
          lines[guardY] = lines[guardY].replaceRange(guardX, guardX+1, 'X');
          guardX--;
        }
        break;
      case Dir.Right:
        if (guardX == (lines[0].length-1)) {
          dir = Dir.Out;
        } else if (lines[guardY][guardX+1] == '#') {
          dir = Dir.Down;
        } else {
          if (lines[guardY][guardX] == ".") {
            sum++;
          }
          lines[guardY] = lines[guardY].replaceRange(guardX, guardX+1, 'X');
          guardX++;
        }
        break;
      case Dir.Out:
        if (lines[guardY][guardX] == ".") {
          sum++;
        }
        lines[guardY] = lines[guardY].replaceRange(guardX, guardX+1, 'X');
        print("Part 1: $sum");
        return;
    }
  }
}

bool walk(List<String> lines, int maxSteps) {
  int sum = 0;

  var (guardX, guardY) = findGuardStart(lines);
  Dir dir = Dir.Up;

  lines[guardY] = lines[guardY].replaceRange(guardX, guardX+1, 'X');
  sum++;
  maxSteps--;

  // cycle detection: mark the spot where the obstacle is and where we turned
  // if we visit it again without visiting new '.' then we have a cycle

  while (maxSteps > 0) {
    maxSteps--;
    switch (dir) {
      case Dir.Up:
        if (guardY == 0) {
          dir = Dir.Out;
        } else if (lines[guardY-1][guardX] == '#') {
          dir = Dir.Right;
        } else {
          if (lines[guardY][guardX] == ".") {
            sum++;
          }
          lines[guardY] = lines[guardY].replaceRange(guardX, guardX+1, 'X');
          guardY--;
        }
        break;
      case Dir.Down:
        if (guardY == (lines.length-1)) {
          dir = Dir.Out;
        } else if (lines[guardY+1][guardX] == '#') {
          dir = Dir.Left;
        } else {
          if (lines[guardY][guardX] == ".") {
            sum++;
          }
          lines[guardY] = lines[guardY].replaceRange(guardX, guardX+1, 'X');
          guardY++;
        }
        break;
      case Dir.Left:
        if (guardX == 0) {
          dir = Dir.Out;
        } else if (lines[guardY][guardX-1] == '#') {
          dir = Dir.Up;
        } else {
          if (lines[guardY][guardX] == ".") {
            sum++;
          }
          lines[guardY] = lines[guardY].replaceRange(guardX, guardX+1, 'X');
          guardX--;
        }
        break;
      case Dir.Right:
        if (guardX == (lines[0].length-1)) {
          dir = Dir.Out;
        } else if (lines[guardY][guardX+1] == '#') {
          dir = Dir.Down;
        } else {
          if (lines[guardY][guardX] == ".") {
            sum++;
          }
          lines[guardY] = lines[guardY].replaceRange(guardX, guardX+1, 'X');
          guardX++;
        }
        break;
      case Dir.Out:
        if (lines[guardY][guardX] == ".") {
          sum++;
        }
        lines[guardY] = lines[guardY].replaceRange(guardX, guardX+1, 'X');
        return false;
    }
  }
  return true;
}

void part2(List<String> lines) {
  int sum = 0;

  int width = lines[0].length;
  int height = lines.length;

  // brute-force try everything out
  for (int j = 0; j < height; j++) {
    for (int i = 0; i < width; i++) {
      if (lines[j][i] != '.') {
        continue;
      }

      var newMap = List<String>.from(lines);
      newMap[j] = newMap[j].replaceRange(i, i+1, '#');

      if (walk(newMap, 10000)) {
        sum++;
      }
    }
  }

  print("Part 2: $sum");
}

void main() {
  var f = File("input");
  var lines = f.readAsLinesSync();

  //part1(lines);
  part2(lines);
}
