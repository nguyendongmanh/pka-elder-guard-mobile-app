class DemoCameraItem {
  const DemoCameraItem({required this.id, required this.name});

  final int id;
  final String name;

  DemoCameraItem copyWith({String? name}) {
    return DemoCameraItem(id: id, name: name ?? this.name);
  }
}
