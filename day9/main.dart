import "dart:io";

const FREE_SPACE = -1;

int checksum(List<int> fs) {
  int cksum = 0;
  int pos = 0;
  for (int b in fs) {
    if (b != FREE_SPACE) {
      cksum += pos * b;
    }
    pos++;
  }
  return cksum;
}

void printBlocks(List<int> blocks) {
  String out = "";
  for (int b in blocks) {
    if (b == FREE_SPACE) {
      out += ".";
    } else {
      out += "$b";
    }
  }
  print(out);
}

void part1(String fs) {
  int sum = 0;

  bool fileSizeMode = true;
  int id = 0;
  var blocks = <int>[];
  for (var r in fs.runes) {
    int size = int.parse(String.fromCharCode(r));
    if (fileSizeMode) {
      for (int i = 0; i < size; i++) {
        blocks.add(id);
      }
      id++;
    } else {
      for (int i = 0; i < size; i++) {
        blocks.add(FREE_SPACE);
      }
    }
    
    fileSizeMode = !fileSizeMode;
  }

  int leftPtr = 0;
  int rightPtr = blocks.length - 1;
  while (leftPtr < rightPtr) {
    // move leftPtr to the next free space
    while (blocks[leftPtr] != FREE_SPACE) {
      leftPtr++;
    }

    // move rightPtr to the next non-free space
    while (blocks[rightPtr] == FREE_SPACE) {
      rightPtr--;
    }

    if (leftPtr >= rightPtr) {
      break;
    }

    // swap
    blocks[leftPtr] = blocks[rightPtr];
    blocks[rightPtr] = FREE_SPACE;
  }

  sum = checksum(blocks);
  print("Part 1: $sum");
}

void part2(String fs) {
  int sum = 0;

  bool fileSizeMode = true;
  int id = 0;
  var blocks = <int>[];
  var blockInfo = <(int, int)>[];
  int pos = 0;
  for (var r in fs.runes) {
    int size = int.parse(String.fromCharCode(r));
    if (fileSizeMode) {
      for (int i = 0; i < size; i++) {
        blocks.add(id);
      }
      blockInfo.add((pos, size));
      id++;
    } else {
      for (int i = 0; i < size; i++) {
        blocks.add(FREE_SPACE);
      }
    }

    pos += size;
    fileSizeMode = !fileSizeMode;
  }

  for (id--; id >= 0; id--) {
    var (pos, size) = blockInfo[id];

    // find first free block with size >= size
    for (int i = 0; i < blocks.length && i < pos; i++) {
      if (blocks[i] != FREE_SPACE) {
        continue;
      }

      int fsize = 0;
      while ((i + fsize) < pos && blocks[i + fsize] == FREE_SPACE) {
        fsize++;
      }

      if (fsize < size) {
        continue;
      }

      for (int j = 0; j < size; j++) {
        blocks[i + j] = blocks[pos + j];
        blocks[pos + j] = FREE_SPACE;
      }
      break;
    }
  }

  sum = checksum(blocks);
  print("Part 2: $sum");
}

void main() {
  var f = File("input");
  var lines = f.readAsLinesSync();

  part1(lines[0]);
  part2(lines[0]);
}
