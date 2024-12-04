import "dart:io";

int countXmas(String s) => (s == "XMAS") || (s == "SAMX") ? 1 : 0;
int countMas(String s1, String s2) => 
  ((s1 == "MAS") || (s1 == "SAM")) && ((s2 == "MAS") || (s2 == "SAM")) ? 1 : 0;

void part1(List<String> lines) {
  int sum = 0;

  // extract all horizontal
  for (final l in lines) {
    for (var i = 0; i < l.length-3; i++) {
      sum += countXmas(l.substring(i, i+4));
    }
  }

  // extract all verticals
  for (int j = 0; j < lines.length-3; j++) {
    for (int i = 0; i < lines[j].length; i++) {
      String s = "";
      for (int x = 0; x < 4; x++) {
        s += lines[j+x][i];
      }
      sum += countXmas(s);
    }
  }

  // extract all diagonals
  for (int j = 0; j < lines.length-3; j++) {
    for (int i = 0; i < lines[j].length-3; i++) {
      String s1 = "";
      String s2 = "";
      for (int x = 0; x < 4; x++) {
        s1 += lines[j+x][i+x];
        s2 += lines[j+x][i+(3-x)];
      }
      sum += countXmas(s1);
      sum += countXmas(s2);
    }
  }

  print("Part 1: $sum");
}

void part2(List<String> lines) {
  int sum = 0;

  for (int j = 0; j < lines.length-2; j++) {
    for (int i = 0; i < lines[j].length-2; i++) {
      if (lines[j+1][i+1] != 'A') {
        continue;
      }
      String s1 = lines[j][i] + lines[j+1][i+1] + lines[j+2][i+2];
      String s2 = lines[j][i+2] + lines[j+1][i+1] + lines[j+2][i];
      sum += countMas(s1, s2);
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
