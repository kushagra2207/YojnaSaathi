class HealthNotice {
  final int id;
  final String title;
  final String description;
  final String type;
  final String location;
  final String? eventDate;
  final String createdAt;
  final String updatedAt;

  HealthNotice({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.location,
    this.eventDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HealthNotice.fromJson(Map<String, dynamic> json) {
    return HealthNotice(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? 'notice',
      location: json['location'] as String? ?? '',
      eventDate: json['event_date'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'location': location,
      'event_date': eventDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory HealthNotice.fromDb(Map<String, dynamic> map) {
    return HealthNotice(
      id: map['id'] as int,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      type: map['type'] as String? ?? 'notice',
      location: map['location'] as String? ?? '',
      eventDate: map['event_date'] as String?,
      createdAt: map['created_at'] as String? ?? '',
      updatedAt: map['updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toDb() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'location': location,
      'event_date': eventDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
