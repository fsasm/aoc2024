import "dart:io";

typedef Equation = (int, List<int>); 

List<Equation> parseEquations(List<String> lines) {
  var result = <Equation>[];

  for (final l in lines) {
    var s = l.split(":");
    int testValue = int.parse(s[0]);
    
    var coeff = s[1].trim().split(" ").map<int>((a) => int.parse(a)).toList();

    result.add((testValue, coeff));
  }

  return result;
}

int concatInts(int l, int r) => int.parse("$l$r");

bool solveEquation(Equation eq, [int curr=0, bool concat=false]) {
  var (target, coeff) = eq;
  if (coeff.length == 0) {
    return target == curr;
  }

  int left = coeff[0];
  coeff = List<int>.from(coeff.sublist(1));
  eq = (target, coeff);

  if (solveEquation(eq, curr + left, concat)) {
    return true;
  }
  if (solveEquation(eq, curr * left, concat)) {
    return true;
  }
  if (concat && solveEquation(eq, concatInts(curr, left), concat)) {
    return true;
  }

  return false;
}

void part1(List<String> lines) {
  int sum = 0;

  var eqs = parseEquations(lines);
  for (final e in eqs) {
    if (solveEquation(e)) {
      sum += e.$1;
    }
  }
  print("Part 1: $sum");
}

void part2(List<String> lines) {
  int sum = 0;

  var eqs = parseEquations(lines);
  for (final e in eqs) {
    // NOTE we have to use the first coefficient as the start value otherwise
    // the sum is too high. Having 0 as start value somehow makes too many
    // equations valid. Don't know why though. Only clue is that it is connected
    // with the concatination.
    var (t, c) = e;
    int curr = c[0];
    c.removeAt(0);
    if (solveEquation((t, c), curr, true)) {
      sum += t;
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
