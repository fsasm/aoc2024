import "dart:io";

(int, int) parseRule(String line) {
  final s = line.split("|");
  return (int.parse(s[0]), int.parse(s[1]));
}

Set<int> addRule(int l, int r, Set<int>? rule) {
  if (rule == null) {
    return <int>{l};
  } else {
    rule.add(l);
    return rule;
  }
}

List<int> parsePages(String line) => 
  line.split(",").map<int>((s) => int.parse(s)).toList();

bool isPageListCorrect(List<int> pages, Map<int, Set<int>> rules) {
  for (int i = 0; i < pages.length; i++) {
    int page = pages[i];
    if (!rules.containsKey(page)) {
      continue;
    }

    var forbidden = rules[page]!;
    for (final p in pages.sublist(i+1)) {
      if (forbidden.contains(p)) {
        return false;
      }
    }
  }
  return true;
}

void part1(List<String> lines) {
  int sum = 0;

  var rules = <int, Set<int>>{};

  for (final l in lines) {
    if (l.contains("|")) {
      var (left, right) = parseRule(l);
      rules[right] = addRule(left, right, rules[right]);
    } else if (l.contains(",")) {
      final pages = parsePages(l);

      if (isPageListCorrect(pages, rules)) {
        sum += pages[pages.length ~/ 2];
      }
    }
  }

  print("Part 1: $sum");
}

bool correctPages(List<int> pages, Map<int, Set<int>> rules) {
  for (int i = 0; i < pages.length; i++) {
    int p = pages[i];
    if (rules.containsKey(p)) {
      var currentSet = rules[p]!;
      for (int j = i+1; j < pages.length; j++) {
        if (currentSet.contains(pages[j])) {
          int t = pages[j];
          pages[j] = pages[i];
          pages[i] = t;
          return true;
        }
      }
    }
  }

  return false;
}

void part2(List<String> lines) {
  int sum = 0;

  var rules = <int, Set<int>>{};

  for (final l in lines) {
    if (l.contains("|")) {
      var (left, right) = parseRule(l);
      rules[right] = addRule(left, right, rules[right]);
    } else if (l.contains(",")) {
      final pages = parsePages(l);
      if (!isPageListCorrect(pages, rules)) {
        while (correctPages(pages, rules)) {}
        sum += pages[pages.length ~/ 2];
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
