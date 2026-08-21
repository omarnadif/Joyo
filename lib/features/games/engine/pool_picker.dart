import 'dart:math';

/// Pesca un indice dal pool evitando quelli già usciti in questa partita.
/// Se il pool si esaurisce (partita lunghissima) ricomincia a pescare da tutti.
int pickPoolIndex(Set<int> used, int poolLength, [Random? random]) {
  final rng = random ?? Random();
  final available = <int>[
    for (var i = 0; i < poolLength; i++)
      if (!used.contains(i)) i,
  ];
  if (available.isEmpty) return rng.nextInt(poolLength);
  return available[rng.nextInt(available.length)];
}
