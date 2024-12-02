import "dart:io";

List<List<int>> parseLines(List<String> lines) {
  var result = <List<int>>[];

  for (var i in lines) {
    var nums = i.split(" ");
    result.add(
      [for (var n in nums) int.parse(n)]
    );
  }

  return result;
}

bool isSafe(List<int> report) {
  if (report[0] < report[1]) {
    // increasing
    for (int i = 1; i < report.length; i++) {
      int diff = report[i] - report[i-1];
      if (diff < 1 || diff > 3) {
        return false;
      }
    }
  } else {
    // decreasing
    for (int i = 1; i < report.length; i++) {
      int diff = report[i-1] - report[i];
      if (diff < 1 || diff > 3) {
        return false;
      }
    }
  }
  return true;
}

void part1(List<String> lines) {
  var reports = parseLines(lines);
  
  int sum = 0;
  for (var r in reports) {
    if (isSafe(r)) {
      sum++;
    }
  }

  print("Part 1: $sum");
}

void part2(List<String> lines) {
  var reports = parseLines(lines);
  
  int sum = 0;
  for (var r in reports) {
    for (int i = 0; i < r.length; i++) {
      var dampened = List<int>.from(r);
      dampened.removeAt(i);
      if (isSafe(dampened)) {
        sum++;
        break;
      }
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
