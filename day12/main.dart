import "dart:io";

typedef Coord = (int, int);

bool isInside(Coord c, List<String> map) =>
    (0 <= c.$1 && c.$1 < map[0].length) && (0 <= c.$2 && c.$2 < map.length);

List<Coord> getNeighbours(Coord c, List<String> map) {
  return [
    (c.$1 - 1, c.$2),
    (c.$1 + 1, c.$2),
    (c.$1, c.$2 - 1),
    (c.$1, c.$2 + 1),
  ];
}

bool checkCell(Coord c, String id, List<String> map) {
  if (!isInside(c, map)) {
    return false;
  }
  return map[c.$2][c.$1] == id;
}

void part1(List<String> lines) {
  var visited = <List<bool>>[];
  for (final l in lines) {
    visited.add(List<bool>.filled(l.length, false));
  }

  int sum = 0;

  for (int y = 0; y < lines.length; y++) {
    for (int x = 0; x < lines[y].length; x++) {
      if (visited[y][x]) {
        continue;
      }

      // flood fill
      var id = lines[y][x];
      var next = <Coord>{(x, y)};

      int perimeter = 0;
      int area = 0;

      while (next.isNotEmpty) {
        var curr = next.first;
        next.remove(curr);
        visited[curr.$2][curr.$1] = true;
        area++;

        for (final n in getNeighbours(curr, lines)) {
          if (!isInside(n, lines) || lines[n.$2][n.$1] != id) {
            perimeter++;
          } else if (!visited[n.$2][n.$1] && lines[n.$2][n.$1] == id) {
            next.add(n);
          }
        }
      }
      sum += area * perimeter;
    }
  }

  print("Part 1: $sum");
}

void part2(List<String> lines) {
  var visited = <List<bool>>[];
  for (final l in lines) {
    visited.add(List<bool>.filled(l.length, false));
  }

  const deltaCorner = const <Coord>[
    (-1, -1),
    (1, -1),
    (-1, 1),
    (1, 1),
  ];

  int sum = 0;

  for (int y = 0; y < lines.length; y++) {
    for (int x = 0; x < lines[y].length; x++) {
      if (visited[y][x]) {
        continue;
      }

      // flood fill
      var id = lines[y][x];
      var next = <Coord>{(x, y)};
      int corners = 0;
      int area = 0;

      while (next.isNotEmpty) {
        var curr = next.first;
        next.remove(curr);
        area++;
        visited[curr.$2][curr.$1] = true;
        for (final n in getNeighbours(curr, lines)) {
          if (checkCell(n, id, lines) && !visited[n.$2][n.$1]) {
            next.add(n);
          }
        }

        // every straight edge has two ends/corners and every corner is connected
        // to two edges, so the number of corners is the same as the number of
        // straight edges.
        for (final dc in deltaCorner) {
          // check for inside and outside corners
          if (!checkCell((curr.$1 + dc.$1, curr.$2), id, lines) &&
              !checkCell((curr.$1, curr.$2 + dc.$2), id, lines)) {
            corners++;
          }

          if (checkCell((curr.$1 + dc.$1, curr.$2), id, lines) &&
              checkCell((curr.$1, curr.$2 + dc.$2), id, lines) &&
              !checkCell((curr.$1 + dc.$1, curr.$2 + dc.$2), id, lines)) {
            corners++;
          }
        }
      }
      sum += area * corners;
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
