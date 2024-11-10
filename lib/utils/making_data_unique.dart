List<T> filterUniqueById<T>(List<T> items, int Function(T) getId) {
  final ids = <int>{};
  final filteredItems = <T>[];

  for (var item in items) {
    final id = getId(item);
    if (!ids.contains(id)) {
      ids.add(id);
      filteredItems.add(item);
    }
  }

  return filteredItems;
}
