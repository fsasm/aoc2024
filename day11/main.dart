import "dart:io";

int numDigits(int i) => "$i".length;

(int, int) splitDigits(int i) {
  String digits = "$i";
  int mid = digits.length ~/ 2;
  return (
    int.parse(digits.substring(0, mid)),
    int.parse(digits.substring(mid))
  );
}

void part1(String line) {
  List<int> stoneList = line.split(" ").map<int>(int.parse).toList();

  int sum = blink(stoneList, 25);
  print("Part 1: $sum");
}

void part2(String line) {
  List<int> stoneList = line.split(" ").map<int>(int.parse).toList();

  int sum = blink(stoneList, 75);
  print("Part 2: $sum");
}

int blink(List<int> stoneList, int numBlinks) {
  // store the number together with how often times it appears
  // number is the key and the multiplicity is the value
  var stones = <int, int>{};
  for (final s in stoneList) {
    stones[s] = 1 + (stones[s] ?? 0);
  }

  for (int i = 0; i < numBlinks; i++) {
    var next = <int, int>{};
    for (final entry in stones.entries) {
      int stone = entry.key;
      int mult = entry.value;

      if (stone == 0) {
        next[1] = mult + (next[1] ?? 0);
      } else if (numDigits(stone) % 2 == 0) {
        var (l, r) = splitDigits(stone);

        next[l] = mult + (next[l] ?? 0);
        next[r] = mult + (next[r] ?? 0);
      } else {
        stone *= 2024;
        next[stone] = mult + (next[stone] ?? 0);
      }
    }
    stones = next;
  }

  return stones.values.reduce((a, b) => a + b);
}

void main() {
  var f = File("input");
  var lines = f.readAsLinesSync();

  part1(lines[0]);
  part2(lines[0]);
}
