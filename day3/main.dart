import "dart:io";

void part1(List<String> lines) {
  int sum = 0;

  final re = RegExp(r"mul\((\d{1,3}),(\d{1,3})\)");
  for (final l in lines) {
    for (final m in re.allMatches(l)) {
      int a = int.parse(m.group(1)!);
      int b = int.parse(m.group(2)!);
      sum += a * b;
    }
  }

  print("Part 1: $sum");
}

void part2(List<String> lines) {
  int sum = 0;
  bool enabled = true;

  final re = RegExp(r"do\(\)|don\'t\(\)|mul\((\d{1,3}),(\d{1,3})\)");
  for (final l in lines) {
    for (final m in re.allMatches(l)) {
      if (m[0]!.contains("do()")) {
        enabled = true;
      }
      if (m[0]!.contains("don't()")) {
        enabled = false;
      }
      if (m[0]!.contains("mul(") && enabled) {
        int a = int.parse(m[1]!);
        int b = int.parse(m[2]!);
        sum += a * b;
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
