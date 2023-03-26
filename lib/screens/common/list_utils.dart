List minMaxList(List l) {
  List results = [];

  if (l.isNotEmpty) {
    var minL = l[0];
    var maxL = l[0];

    for (var element in l) {
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