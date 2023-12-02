class Details {
  final int? id;
  final int? tripId;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String imagePath;

  Details(
      {this.id,
      this.tripId,
      required this.title,
      required this.description,
      required this.startDate,
      required this.endDate,
      required this.imagePath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripId': tripId,
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'imagePath': imagePath,
    };
  }

  factory Details.fromMap(Map<String, dynamic> map) {
    return Details(
      id: map['id'],
      tripId: map['tripId'],
      title: map['title'],
      description: map['description'],
      startDate: map['startDate'] ?? "",
      endDate: map['endDate'] ?? "",
      imagePath: map['imagePath'] ?? "",
    );
  }
}
