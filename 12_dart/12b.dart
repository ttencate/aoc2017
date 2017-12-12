#!/usr/bin/dart

import 'dart:io';

dfs(Map<int, List<int>> connections, int start, Set<int> remaining) {
  if (!remaining.contains(start)) {
    return;
  }
  remaining.remove(start);
  for (int next in connections[start]) {
    dfs(connections, next, remaining);
  }
}

main() async {
  Map<int, List<int>> connections = new Map();
  while (true) {
    String line = stdin.readLineSync();
    if (line == null) break;
    RegExp re = new RegExp(r'^(\d+) <-> (.*)$');
    Match match = re.firstMatch(line);
    int id = int.parse(match.group(1));
    List<int> conns = match.group(2).split(', ').map(int.parse);
    connections[id] = conns;
  }

  Set<int> remaining = new Set.from(connections.keys);
  int groups = 0;
  while (remaining.isNotEmpty) {
    groups++;
    dfs(connections, remaining.first, remaining);
  }

  print(groups);
}
