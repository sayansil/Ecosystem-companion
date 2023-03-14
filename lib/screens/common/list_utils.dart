List<int> minMaxList(List<int> l) {
  List<int> results = [];

  if (l.isNotEmpty) {
    int minL = l[0];
    int maxL = l[0];

    for (int element in l) {
      if (element < minL) {
        minL = element;
      }
      if (element > maxL) {
        maxL = element;
      }
    }

    results.add(minL);
    results.add(maxL);
  }

  return results;
}