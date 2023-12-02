class Trips {
  final int? id;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String imagePath;

  Trips({
    this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id ?? 0,
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'imagePath': imagePath,
    };
  }

  factory Trips.fromMap(Map<String, dynamic> map) {
    return Trips(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startDate: map['startDate'] ?? "",
      endDate: map['endDate'] ?? "",
      imagePath: map['imagePath'] ?? "",
    );
  }
}
