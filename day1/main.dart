import "dart:io";

(List<int>, List<int>) parseLines(List<String> lines) {
  var l = <int>[];
  var r = <int>[];

  // TODO this could be done better with a better string split
  var re = RegExp(r"(\d+)\s+(\d+)");
  for (var i in lines) {
    var nums = re.firstMatch(i);
    if (nums == null) {
      continue;
    }
    l.add(int.parse(nums.group(1)!));
    r.add(int.parse(nums.group(2)!));
  }

  return (l, r);
}

void part1(List<String> lines) {
  var (l, r) = parseLines(lines);

  l.sort();
  r.sort();

  int sum = 0;
  for (int i = 0; i < l.length; i++) {
    sum += (l[i] - r[i]).abs();
  }
  print("Part 1: $sum");
}

Map<int, int> countList(List<int> l) {
  var result = <int, int>{};

  for (var i in l) {
    result[i] = 1 + (result[i] ?? 0);
  }

  return result;
}

void part2(List<String> lines) {
  var (l, r) = parseLines(lines);

  var countTable = countList(r);

  int sum = 0;
  for (int i in l) {
    sum += i * (countTable[i] ?? 0);
  }

  print("Part 2: $sum");
}

void main() {
  var f = File("input");
  var lines = f.readAsLinesSync();

  part1(lines);
  part2(lines);
}
