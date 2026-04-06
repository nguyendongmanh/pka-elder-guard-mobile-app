class DemoCameraItem {
  const DemoCameraItem({
    required this.id,
    required this.name,
    this.highlightedByAlert = false,
  });

  final int id;
  final String name;
  final bool highlightedByAlert;

  DemoCameraItem copyWith({String? name, bool? highlightedByAlert}) {
    return DemoCameraItem(
      id: id,
      name: name ?? this.name,
      highlightedByAlert: highlightedByAlert ?? this.highlightedByAlert,
    );
  }
}
