import "dart:io";

const costA = 3;
const costB = 1;

typedef Coord = ({int x, int y});

int detCramer(int a1, int b1, int a2, int b2) => a1 * b2 - b1 * a2;

int? solveCramer(Coord btnA, Coord btnB, Coord target) {
  int detD = detCramer(btnA.x, btnB.x, btnA.y, btnB.y);
  int detDa = detCramer(target.x, btnB.x, target.y, btnB.y);
  int detDb = detCramer(btnA.x, target.x, btnA.y, target.y);

  int timesA = detDa ~/ detD;
  int timesB = detDb ~/ detD;

  if (timesA < 0 || timesB < 0) {
    return null;
  }

  int reachX = timesA * btnA.x + timesB * btnB.x;
  int reachY = timesA * btnA.y + timesB * btnB.y;

  if (reachX != target.x || reachY != target.y) {
    return null;
  }
  return timesA * costA + timesB * costB;
}

int parseAndSolve(List<String> lines, int offset) {
  int sum = 0;

  Coord? btnA;
  Coord? btnB;
  Coord? prize;

  var reBtnA = RegExp(r"Button A: X\+(\d+), Y\+(\d+)");
  var reBtnB = RegExp(r"Button B: X\+(\d+), Y\+(\d+)");
  var rePrize = RegExp(r"Prize: X=(\d+), Y=(\d+)");
  for (final l in lines) {
    if (l.length == 0) {
      continue;
    }

    var matchBtnA = reBtnA.firstMatch(l);
    if (matchBtnA != null) {
      btnA = (
        x: int.parse(matchBtnA.group(1)!),
        y: int.parse(matchBtnA.group(2)!),
      );
    }

    var matchBtnB = reBtnB.firstMatch(l);
    if (matchBtnB != null) {
      btnB = (
        x: int.parse(matchBtnB.group(1)!),
        y: int.parse(matchBtnB.group(2)!),
      );
    }

    var matchPrize = rePrize.firstMatch(l);
    if (matchPrize != null) {
      prize = (
        x: int.parse(matchPrize.group(1)!) + offset,
        y: int.parse(matchPrize.group(2)!) + offset,
      );
    }

    if (btnA != null && btnB != null && prize != null) {
      int? tokens = solveCramer(btnA, btnB, prize);
      if (tokens != null) {
        sum += tokens;
      }
      btnA = null;
      btnB = null;
      prize = null;
    }
  }

  return sum;
}

void part1(List<String> lines) {
  int sum = parseAndSolve(lines, 0);
  print("Part 1: $sum");
}

void part2(List<String> lines) {
  int sum = parseAndSolve(lines, 10000000000000);
  print("Part 2: $sum");
}

void main() {
  var f = File("input");
  var lines = f.readAsLinesSync();

  part1(lines);
  part2(lines);
}
